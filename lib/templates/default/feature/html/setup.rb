def init
  super
  @feature = object

  sections.push :feature

  sections.push :scenarios if object.scenarios

end

def background
  @scenario = @feature.background
  @id = "background"
  erb(:scenario)
end

def scenarios
  scenarios = ""

  if @feature.background
    @scenario = @feature.background
    @id = "background"
    scenarios += erb(:scenario)
  end

  @feature.scenarios.each_with_index do |scenario,index|
    @scenario = scenario
    @id = "scenario_#{index}"
    scenarios += erb(:scenario)
  end

  scenarios
end


def highlight_matches(step)
  step.value.dup.tap do |value|
    if step.definition
      matches = step.definition.regex.match(step.value)
      if matches
        matches.named_captures.to_a.reverse.each_with_index do |(name,match),index|
          next if match == nil
          next unless name.start_with?("placeholder_")
          highlight = "<span class='match'>#{h(match)}</span>"
          value[matches.begin((matches.size - 1) - index)..(matches.end((matches.size - 1) - index) - 1)] = highlight
        end
      end
    end
  end
end

def htmlify_with_newlines(text)
  text.split("\n").collect {|c| h(c).gsub(/\s/,'&nbsp;') }.join("<br/>")
end
