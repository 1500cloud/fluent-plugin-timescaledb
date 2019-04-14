# fluent-plugin-timescaledb

[Fluentd](https://fluentd.org/) output plugin to store logs in TimescaleDB

## Installation

You will probably need some Ruby tools available (e.g., `ruby-dev`) as well as
the libpq library (`libpq-dev`/`postgres-dev`, depending on your OS).

### RubyGems

```
$ gem install fluent-plugin-timescaledb
```

### Bundler

Add following line to your Gemfile:

```ruby
gem "fluent-plugin-timescaledb"
```

And then execute:

```
$ bundle
```

## Configuration

You must have a running instance of [TimescaleDB](https://www.timescale.com/) somewhere.

Create a database and then a table within it, something like this:

```sql
CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;
CREATE TABLE log_records (
                            time   TIMESTAMP NOT NULL,
                            tag    CHAR[128] NOT NULL,
                            record JSONB     NOT NULL
);
SELECT create_hypertable('log_records', 'time');
```

At your pleasure, you may want to add more indexes inside the JSONB block to
allow for better querying. That's left as an exercise for the reader,
depending on your exact needs.

To configure FluentD, add a block similar to this to your config.

```
<match **>
  @type timescaledb
  db_conn_string "host=localhost user=fluent password=supersecret dbname=fluent"
</match>
```

The exact value of db_conn_string is as defined by the `pg` Gem.

## Copyright

* Copyright(c) 2019: 1500 Services Ltd
* License
  * Apache License, Version 2.0
