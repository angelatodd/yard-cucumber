#
# Finds and processes all the step definitions defined in the ruby source
#
class YARD::Handlers::Ruby::StepDefinitionHandler < YARD::Handlers::Ruby::Base

  handles method_call(:step)

  process do

    instance = YARD::CodeObjects::StepDefinition.new(step_transform_namespace,step_definition_name) do |o|
      o.source = statement.source
      o.comments = statement.comments
      step_name = statement.parameters[0].source
      if step_name[0] == ":"
        step_name = statement.parameters[1].source
      else
        o.pending = pending_keyword_used?(statement.block)
      end
      o.keyword = statement.method_name.source
      step_name.gsub!(/(?<!\\)"[\s]*(?:\+|\\)[\s]*"/,"")
      o.literal_value = step_name
      o.value = step_name.gsub(/^\"|\"$/, "")
    end

    obj = register instance
    parse_block(statement[2],:owner => obj) unless statement.parameters[0].source[0] == ":"
  rescue StandardError => e
    log.warn(e)
  end

  def pending_keyword
    "skip"
  end

  def pending_command_statement?(line)
    (line.type == :command || line.type == :vcall) && line.first.source == pending_keyword
  end

  def pending_keyword_used?(block)
    code_in_block = block.last
    code_in_block.find { |line| pending_command_statement?(line) }
  end

  def step_transform_namespace
    YARD::CodeObjects::Cucumber::CUCUMBER_STEPTRANSFORM_NAMESPACE
  end

  def step_definition_name
    "step_definition#{self.class.generate_unique_id}"
  end

  def self.generate_unique_id
    @step_definition_count = @step_definition_count.to_i + 1
  end
end
