require 'active_support'
require 'active_support/core_ext/object/blank'
require 'dry-initializer'

module OpenAPI
  VERSION = '3.0.1'
end

require_relative 'openapi/core'
require_relative 'openapi/dsl'

module OpenAPI
  def self.define(&block)
    DSL::Proxy::Document.define(&block)
  end
end
