module YARD::CodeObjects
  class StepTransformer < Base

    include Cucumber::LocationHelper

    attr_reader :constants, :keyword, :source, :value
    attr_accessor :steps, :pending, :substeps, :literal_value



    #
    # Set the literal value and the value of the step definition.
    #
    # The literal value is as it appears in the step definition file with any
    # constants. The value, when retrieved will attempt to replace those
    # constants with their regex or string equivalents to hopefully match more
    # steps and step definitions.
    #
    #
    def value=(value)
      @literal_value ||= format_source(value)
      @value = format_source(value)

      @steps = []
    end

    # Generate a regex with the step transformers value
    def regex
      @regex ||= Regexp.new(value)
    end
  end
end
