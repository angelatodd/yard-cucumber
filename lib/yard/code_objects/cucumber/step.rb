module YARD::CodeObjects::Cucumber
  class Step < Base

    attr_accessor :comments,
                  :definition,
                  :examples,
                  :keyword,
                  :scenario,
                  :table,
                  :text,
                  :placeholders,
                  :value

    def initialize(namespace, name)
      super(namespace, name.to_s.strip)
      @comments = @definition = @description = @keyword = @table = @text = @value = nil
      @examples = {}
      @placeholders = []
    end

    def has_table?
      !@table.nil?
    end

    def has_text?
      !@text.nil?
    end

    def definition=(stepdef)
      @definition = stepdef

      unless stepdef.steps.map(&:files).include?(files)
        stepdef.steps << self

        stepdef.placeholders.each do |placeholder|
          placeholders << placeholder
          placeholder.steps << self
        end
      end
    end

    def transformed?
      !@placeholders.empty?
    end
  end
end
