module YARD::CodeObjects
  class StepDefinition < StepTransformer

    attr_accessor :placeholders

    OPTIONAL_WORD_REGEXP = %r{(\\\s)?\\\((?!:)([^)]+)\\\)(\\s)?}
    PLACEHOLDER_REGEXP = /(:[\w]+)/
    ALTERNATIVE_WORD_REGEXP = /([[:alpha:]]+)((\/[[:alpha:]]+)+)/

    def value
      unless @processed
        @placeholders = []
        @processed = true
        @value = Regexp.escape(@value)
        @value.gsub!(PLACEHOLDER_REGEXP) do |_|
          find_value_for_placeholder($1)
        end
        @value.gsub!(OPTIONAL_WORD_REGEXP) do |_|
          [$1, $2, $3].compact.map { |m| "(?:#{m})?" }.join
        end
        @value.gsub!(ALTERNATIVE_WORD_REGEXP) do |_|
          "(?:#{$1}#{$2.tr('/', '|')})"
        end
      end
      @value
    end


    private

    #
    # Looking through all the constants in the registry and returning the value
    # with the regex items replaced from the constnat if present
    #
    def find_value_for_placeholder(name)
      placeholder_matches = YARD::Registry.all(:placeholder).select{ |p|  p.literal_value == name }
      regex = if placeholder_matches.empty?
        YARD::CodeObjects::Placeholder::DEFAULT_PLACE_HOLDER_REGEXP_STRING
      else
        placeholders.push(*placeholder_matches)
        placeholder_matches.map(&:regex).join('|')
      end
      "(?<placeholder_#{name[1..-1]}>#{regex})"
    end
  end
end
