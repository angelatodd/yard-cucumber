def init
  super
  sections.push :index, :step_definitions_section, :placeholders_section, :undefined_steps_section
end

def step_definitions
  @step_definitions ||= begin
    YARD::Registry.all(:stepdefinition).sort_by {|definition| definition.steps.length * -1 }
  end
end

def placeholders
  @placeholders ||= begin
    YARD::Registry.all(:placeholder).sort_by {|definition| definition.steps.length * -1 }
  end
end

def undefined_steps
  @undefined_steps ||= begin
    unique_steps(Registry.all(:step).reject {|s| s.definition || s.scenario.outline? }).sort_by{|steps| steps.last.length * -1 }
  end
end

def step_definitions_section
  @item_title = "Step Definitions"
  @item_anchor_name = "step_definitions"
  @item_type = "step definition"
  @items = step_definitions
  erb(:header) + erb(:step_definitions)
end

def placeholders_section
  @item_title = "Placeholders"
  @item_anchor_name = "placeholders"
  @item_type = "placeholder"
  @items = placeholders
  erb(:header) + erb(:placeholders)
end

def undefined_steps_section
  @item_title = "Undefined Steps"
  @item_anchor_name = "undefined_steps"
  @item_type = nil
  @items = undefined_steps
  erb(:header) + erb(:undefined_steps)
end


def unique_steps(steps)
  uniq_steps = {}
  steps.each {|s| (uniq_steps[s.value.to_s] ||= []) << s }
  uniq_steps
end

def display_comments_for(item)
  begin
    T('docstring').run(options.dup.merge({:object => item}))
  rescue
    log.warn %{An error occurred while attempting to render the comments for: #{item.location} }
    return ""
  end

end

def link_step_definition_name(step_definition)
    value = step_definition.literal_value.dup

    if step_definition.placeholders
      value.gsub!(/:[\w]+/) do |match|
        placeholder = step_definition.placeholders.find {|placeholder| placeholder.literal_value == match }
        placeholder ? "<a href='#{url_for(placeholder)}'>#{h(match)}</a>" : "<span class='match'>#{match}</span>"
      end
    end
    value
  end


def link_transformed_step(step)
  value = step.value.dup

  if step.definition
    matches = step.definition.regex.match(step.value)

    if matches
      matches[1..-1].reverse.each_with_index do |match,index|
        next if match == nil
        placeholder = step.placeholders.find {|placeholder| placeholder.regex.match(match) }

        value[matches.begin((matches.size - 1) - index)..(matches.end((matches.size - 1) - index) - 1)] = placeholder ? "<a href='#{url_for(placeholder)}'>#{h(match)}</a>" : "<span class='match'>#{h(match)}</span>"
      end
    end
  end
  value
end

def highlight_transformed_step(step, placeholder)
  value = step.value.dup
  if step.definition
    matches = step.definition.regex.match(value)
    matches[1..-1].reverse.each_with_index do |match,index|
      next if match == nil
      next unless placeholder.regex.match?(match)
      value[matches.begin((matches.size - 1) - index)..(matches.end((matches.size - 1) - index) - 1)] = "<span class='match'>#{match}</span>"
    end
  end
  value
end
