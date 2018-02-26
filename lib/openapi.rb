require 'yaml'

module OpenAPI
  def self.define(&block)
    Document.new.tap do |document|
      DocumentProxy.new(document).instance_eval(&block)
    end
  end

  class Document
    # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#oasObject

    attr_accessor :title, :version, :paths

    VERSION = '3.0.1'

    def initialize
      @servers = []
      @tags = []
    end

    def add_server(url)
      @servers << ServerObject.new(url)
    end

    def add_tag(name)
      @tags << TagObject.new(name)
    end

    def serialize
      {
        openapi: VERSION,
        info: { title: title, version: version },
        servers: serialize_servers,
        paths: @paths.serialize
      }.tap do |h|
        h[:tags] = @tags.map(&:serialize) unless @tags.empty?
      end
    end

    def to_yaml
      stringify_keys(serialize).to_yaml
    end

    private

    def serialize_servers
      if @servers.empty?
        [ ServerObject.new('/').serialize ]
      else
        @servers.map(&:serialize)
      end
    end

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

  class ServerObject
    # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#serverObject

    def initialize(url)
      @url = url
    end

    def serialize
      { url: @url }
    end
  end

  class PathsObject
    # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#pathsObject

    def initialize
      @paths = {}
    end

    def add(path, http_method, operation_object)
      @paths[path] ||= {}
      @paths[path][http_method] = operation_object
    end

    def serialize
      @paths.each_with_object({}) do |(path, http_methods), h|
        h[path] = serialize_http_methods(http_methods)
        h
      end
    end

    private

    def serialize_http_methods(http_methods)
      http_methods.each_with_object({}) do |(http_method, operation_object), h|
        h[http_method] = operation_object.serialize
        h
      end
    end
  end

  class TagObject
    # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#tagObject

    def initialize(name)
      @name = name
    end

    def serialize
      { name: @name }
    end
  end

  class OperationObject
    # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#operationObject

    attr_accessor :description, :data, :responses

    def initialize
      @tags = []
    end

    def add_tag(name)
      @tags << name
    end

    def serialize
      {
        description: description,
        requestBody: {
          content: {
            'application/vnd.api+json' => {
              schema: {
                type: 'object',
                properties: {
                  data: data.serialize
                }
              }
            }
          }
        },
        responses: responses.serialize
      }.tap do |h|
        h[:tags] = @tags unless @tags.empty?
      end
    end
  end

  class HeaderObject
    # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#headerObject

    attr_reader :name

    def initialize(name, opts)
      @name = name
      @opts = opts
    end

    def serialize
      {
        description: @opts[:description] || 'No description provided.',
        schema: { type: 'string' }
      }
    end
  end

  class Responses
    def initialize
      @responses = []
    end

    def add_response(response)
      @responses << response
    end

    def serialize
      @responses.each_with_object({}) do |response, h|
        h[response.code] = response.serialize
        h
      end
    end
  end

  class Response
    attr_accessor :description, :data, :meta
    attr_reader :code

    DEFAULT_OPTIONS = {
      errors: false
    }

    def initialize(code, opts)
      @code = code
      @opts = DEFAULT_OPTIONS.merge(opts)
      @headers = []
      @errors = []
    end

    def add_header(name, opts)
      @headers << HeaderObject.new(name, opts)
    end

    def serialize
      {
        description: description,
        content: {
          'application/vnd.api+json' => {
            schema: {
              type: 'object',
              properties: @opts[:errors] ? serialize_errors_and_meta : serialize_data_and_meta
            }
          }
        }
      }.tap do |h|
        h[:headers] = serialize_headers unless @headers.empty?
      end
    end

    private

    def serialize_errors_and_meta
      {}.tap do |h|
        h[:errors] = {
          type: 'array',
          items: {
            type: 'object',
            required: ['detail'],
            properties: {
              detail: {
                type: 'string'
              },
              source: {
                type: 'object',
                properties: {
                  pointer: {
                    type: 'string'
                  }
                }
              }
            }
          }
        }

        h[:meta] = meta.serialize if meta
      end
    end

    def serialize_data_and_meta
      {}.tap do |h|
        h[:data] = data.serialize if data
        h[:meta] = meta.serialize if meta
      end
    end

    def serialize_headers
      @headers.each_with_object({}) do |header, h|
        h[header.name] = header.serialize
        h
      end
    end
  end

  class Data
    attr_accessor :type

    DEFAULT_OPTIONS = {
      id: false
    }

    def initialize(opts = {})
      @ops = DEFAULT_OPTIONS.merge(opts)
      @props = []
    end

    def add_prop(name, opts)
      @props << Property.new(name, opts)
    end

    def serialize
      required = ['type']
      properties = { type: { type: 'string' } }

      if @ops[:id]
        required << 'id'
        properties[:id] = { type: 'string' }
      end

      unless @props.empty?
        properties[:attributes] = {
          type: 'object',
          properties: serialize_props
        }.tap do |h|
          h[:required] = required_props unless required_props.empty?
        end
      end

      {
        type: 'object',
        required: required,
        properties: properties
      }
    end

    private

    def serialize_props
      @props.each_with_object({}) do |prop, h|
        h[prop.name] = prop.serialize
        h
      end
    end

    def required_props
      @_required_props ||= @props.select(&:required?).map(&:name).map(&:to_s).sort
    end
  end

  class Meta
    def initialize
      @props = []
    end

    def add_prop(name, opts)
      @props << Property.new(name, opts)
    end

    def serialize
      {
        type: 'object',
        properties: serialize_props
      }.tap do |h|
        h[:required] = required_props unless required_props.empty?
      end
    end

    private

    def serialize_props
      @props.each_with_object({}) do |prop, h|
        h[prop.name] = prop.serialize
        h
      end
    end

    def required_props
      @_required_props ||= @props.select(&:required?).map(&:name).map(&:to_s).sort
    end
  end

  class Property
    attr_reader :name

    DEFAULT_OPTIONS = {
      required: true,
      type: 'string'
    }

    def initialize(name, opts)
      @name = name
      @opts = DEFAULT_OPTIONS.merge(opts)
    end

    def required?
      @opts[:required]
    end

    def serialize
      {
        type: @opts[:type].to_s
      }.tap do |h|
        h[:description] = @opts[:description] if @opts[:description]
      end
    end
  end

  # Proxies

  class DocumentProxy < Struct.new(:document)
    def title(s)
      document.title = s
    end

    def version(s)
      document.version = s
    end

    def server(url)
      document.add_server(url)
    end

    def tag(name)
      document.add_tag(name)
    end

    def paths(&block)
      PathsObject.new.tap do |paths|
        document.paths = paths
        PathsObjectProxy.new(paths).instance_eval(&block)
      end
    end
  end

  class PathsObjectProxy < Struct.new(:paths_object)
    def post(path, &block)
      OperationObject.new.tap do |operation_object|
        paths_object.add(path, :post, operation_object)
        OperationObjectProxy.new(operation_object).instance_eval(&block)
      end
    end
  end

  class OperationObjectProxy < Struct.new(:operation_object)
    def tag(name)
      operation_object.add_tag(name)
    end

    def description(s)
      operation_object.description = s
    end

    def data(&block)
      Data.new.tap do |data|
        operation_object.data = data
        DataProxy.new(data).instance_eval(&block)
      end
    end

    def responses(&block)
      Responses.new.tap do |responses|
        operation_object.responses = responses
        ResponsesProxy.new(responses).instance_eval(&block)
      end
    end
  end

  class ResponsesProxy < Struct.new(:responses)
    def status(code, opts = {}, &block)
      Response.new(code, opts).tap do |response|
        responses.add_response(response)
        ResponseProxy.new(response).instance_eval(&block)
      end
    end
  end

  class ResponseProxy < Struct.new(:response)
    def description(s)
      response.description = s
    end

    def header(name, options = {})
      response.add_header(name, options)
    end

    def data(&block)
      Data.new(id: true).tap do |data|
        response.data = data
        DataProxy.new(data).instance_eval(&block)
      end
    end

    def meta(&block)
      Meta.new.tap do |meta|
        response.meta = meta
        MetaProxy.new(meta).instance_eval(&block)
      end
    end
  end

  class DataProxy < Struct.new(:data)
    def type(s)
      data.type = s
    end

    def prop(name, opts = {})
      data.add_prop(name, opts)
    end
  end

  class MetaProxy < Struct.new(:meta)
    def prop(name, opts = {})
      meta.add_prop(name, opts)
    end
  end
end
