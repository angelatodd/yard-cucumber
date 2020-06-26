#
# This step definition uses a placeholder custom
#
step "the/this :step_type step" do |step_type|
  puts "step type #{step_type}"
end

#
# This step definition uses a custom placeholder with forward slashes
#
step "the :step_number :step_type step on :date" do |step_number, step_type, day, month, year|
  puts "step type #{step_type}"
end

#
# This step definition uses alternative text syntax
#
step "the/this :step_number step" do |step_type|
  puts "step number #{step_type}"
end

#
# This step definition uses a default placeholder with optional text
#
step "the step(s) called :name" do |name|
  puts "name #{name}"
end


#
# This step definition uses both default and custom placeholders
#
step "the :step_number :name step" do |step_number, name|
  puts "step_number #{step_number} and name #{name}"
end

#
# This step definition uses a custom placeholder with regex special chars
#
step "the step at the [:first_term :arithmetic_operation :first_term] index" do
end

#
# Shouldn't match our handler as it's not inside a placeholder
#
match /blob/ do
end

#
# This placeholder matches the type of step
#
placeholder :step_type do
  match /(?:background|scenario)/
end

#
# This placeholder matches the step number using 2 separate calls to match
#
placeholder :step_number do
  match(/(?:first|second)/)
  match(/third/)
end

placeholder :date do
  match /(\d\d)\/(\d\d)\/(\d\d\d\d)/
end

placeholder :arithmetic_operation do
  match /\+|-|\*|\//
end
