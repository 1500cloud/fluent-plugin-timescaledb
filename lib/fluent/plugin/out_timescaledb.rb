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
        @conn.prepare('insert_record', "INSERT INTO \"#{@db_table_name}\" (time, tag, record) VALUES ($1, $2, $3)")
      end

      def close
        @conn.close if @conn
      end

      def write(chunk)
        chunk.msgpack_each do | tag, time, record |
          @conn.exec_prepared('insert_record', [Time.at(time.to_f), tag, record.to_json])
        end
      end

      def format(tag, time, record)
        [tag, time, record].to_msgpack
      end

      def formatted_to_msgpack_binary
        true
      end
    end
  end
end
