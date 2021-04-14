require 'fluent/plugin/output'
require 'pg'

module Fluent
  module Plugin
    class TimescaleDB < Output
      Fluent::Plugin.register_output('timescaledb', self)

      config_param :db_conn_string, :string, secret: true
      config_param :db_table_name, :string, default: 'log_records'

      def start
        super

        @conn = PG.connect(@db_conn_string)
      end

      def close
        @conn.close if @conn and !@conn.finished?
      end

      def write(chunk)
        reconnect_if_connection_bad!

        values = []
        chunk.msgpack_each do | tag, time, record |
          values << "('#{@conn.escape_string(format_time(time))}','#{@conn.escape_string(tag)}','#{@conn.escape_string(record.to_json)}'::jsonb)"
        end

        @conn.exec("INSERT INTO #{@conn.escape_identifier(@db_table_name)} (time, tag, record) VALUES #{values.join(',')}")
      end

      def format(tag, time, record)
        [tag, time.to_f, record].to_msgpack
      end

      def formatted_to_msgpack_binary
        true
      end

      private

      TIME_FORMAT = "%Y-%m-%d %H:%M:%S.%N".freeze

      def format_time(time)
        Time.at(time.to_f).utc.strftime(TIME_FORMAT)
      end

      def reconnect_if_connection_bad!
        if @conn.status == PG::CONNECTION_BAD
          @conn.reset
        end
      end
    end
  end
end
