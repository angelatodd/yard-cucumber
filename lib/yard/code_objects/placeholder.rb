module YARD::CodeObjects
  class Placeholder < StepTransformer

    CONSTANT_PATTERN = /#\{\s*([^}]+)\s*\}/

    DEFAULT_PLACE_HOLDER_REGEXP_STRING = "['\"]?((?:(?<=\")[^\"]*)(?=\")|(?:(?<=')[^']*(?='))|(?<!['\"])[[:alnum:]_-]+(?!['\"]))['\"]?"

    def value
      return if @value.nil?
      unless @processed
        @processed = true
        loop do
          break if substitute_constants.nil?
        end
      end
      @value
    end

    private

    def substitute_constants
      @value.gsub!(CONSTANT_PATTERN) do |_|
        find_value_for_constant($1)
      end
    end

    # Look through the specified data for the escape pattern and return an array
    # of those constants found. This defaults to the @value within step transformer
    # as it is used internally, however, it can be called externally if it's
    # needed somewhere.
    def constants_from_value(data=@value)
      data.scan(CONSTANT_PATTERN).flatten.collect { |value| value.strip }
    end

    #
    # Looking through all the constants in the registry and returning the value
    # with the regex items replaced from the constnat if present
    #
    def find_value_for_constant(name)
      constant = YARD::Registry.all(:constant).find{|c| c.name == constant.to_sym }
      log.warn "StepTransformer#find_value_for_constant : Could not find the CONSTANT [#{name}] using the string value." unless constant
      constant ? constant.value : DEFAULT_PLACE_HOLDER_REGEXP_STRING
    end
  end
end
