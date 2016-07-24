module Utils::Searching
  extend ActiveSupport::Concern
  CLEAR_VALUE_OPTIONS = {
    simple_clear: /[\-|\s|\.|\(|\)]/
  }

  included do
    def self.searching(*attributes)
      options = attributes.last.is_a?(Hash) ? attributes.last : {}
      attributes = attributes[0..attributes.size-2] if options.present?
      query = generate_composite_query(attributes, options)

      scope :search, -> (text) {
        if text.present?
          cleared_values = {}
          CLEAR_VALUE_OPTIONS.each { |k,v| cleared_values[k] = I18n.transliterate("%#{text.gsub(v, '')}%") }

          where(query, {text: I18n.transliterate("%#{text}%")}.merge(cleared_values))
        end
      }
    end

    private

    def self.unaccent_query_attributes(attributes)
      attributes.collect! { |attr| "UNACCENT(#{attr})" }
    end

    def self.generate_composite_query(attributes, options)
      unaccent_query_attributes(attributes)
      main_query = attributes.join(' ILIKE :text OR ') + ' ILIKE :text'

      cleared_query = options.collect do |k,v|
        unaccent_query_attributes(v)
        v.join(" ILIKE :#{k} OR ") + " ILIKE :#{k}"
      end
        .join(' ')

      query_array = []
      query_array << main_query if main_query.present?
      query_array << cleared_query if cleared_query.present?

      query_array.join(' OR ')
    end
  end
end