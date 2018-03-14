require 'yaml'

module OpenAPI::Core
  class Document
    # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#openapi-object

    attr_writer :openapi, :info, :servers, :paths, :components, :tags

    include Dry::Initializer.define -> do
      option :openapi, default: proc { OpenAPI::VERSION }
      option :info, default: proc { Info.new }
      option :servers, default: proc { Servers.new }
      option :paths, default: proc { Paths.new }
      option :components, default: proc { Components.new }
      option :tags, default: proc { Tags.new }
    end

    def empty?
      serialize.empty?
    end

    def serialize
      {}.tap do |h|
        h[:openapi] = openapi if openapi.present?
        h[:info] = info.serialize unless info.empty?
        h[:servers] = servers.serialize unless servers.empty?
        h[:paths] = paths.serialize unless paths.empty?
        h[:components] = components.serialize unless components.empty?
        h[:tags] = tags.serialize unless tags.empty?
      end
    end

    def to_yaml
      stringify_keys(serialize).to_yaml
    end

    private

    def stringify_keys(x)
      if x.is_a?(Hash)
        x.each_with_object({}) do |(k, v), h|
          h[k.to_s] = stringify_keys(v)
          h
        end
      elsif x.is_a?(Array)
        x.map { |v| stringify_keys(v) }
      else
        x
      end
    end
  end
end
