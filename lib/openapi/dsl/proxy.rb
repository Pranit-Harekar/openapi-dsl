OpenAPI::DSL::Proxy = Module.new

require_relative './proxy/combinder'
require_relative './proxy/defineable'
require_relative './proxy/schema_types'

Dir.glob(File.expand_path('../proxy/*.rb', __FILE__)) { |f| require f }
