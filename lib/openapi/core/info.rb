module OpenAPI::Core
  class Info
    # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#infoObject

    attr_writer :title, :version

    include Dry::Initializer.define -> do
      option :title, default: proc { '' }
      option :version, default: proc { '' }
    end

    def empty?
      serialize.empty?
    end

    def serialize
      {}.tap do |h|
        h[:title] = title if title.present?
        h[:version] = version if version.present?
      end
    end
  end
end
