OpenAPI::Core = Module.new

require_relative './core/abstract_array'
require_relative './core/abstract_hash'

Dir.glob(File.expand_path('../core/*.rb', __FILE__)) { |f| require f }
