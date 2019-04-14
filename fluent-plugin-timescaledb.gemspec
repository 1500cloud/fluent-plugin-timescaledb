Gem::Specification.new do |s|
  s.name        = 'fluent-plugin-timescaledb'
  s.version     = '1.0.0'
  s.license     = 'Apache 2.0'
  s.summary     = "Write Fluent logs to TimescaleDB"
  s.description = "Write Fluent logs to TimescaleDB"
  s.authors     = ["Chris Northwood"]
  s.email       = 'chris.northwood@1500cloud.com'
  s.homepage    = 'https://github.com/1500cloud/fluent-plugin-timescaledb'
  s.files       = ["lib/fluent/plugin/out_timescaledb.rb"]

  s.add_runtime_dependency 'pg'
end
