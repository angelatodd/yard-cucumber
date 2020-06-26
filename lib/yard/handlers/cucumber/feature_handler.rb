module YARD
  module Handlers
    module Cucumber
      class FeatureHandler < Base

        handles CodeObjects::Cucumber::Feature

        def process
          #
          # Features have already been created when they were parsed. So there
          # is no need to process the feature further. Previously this is where
          # feature steps were matched to step definitions and step definitions
          # were matched to placeholders. This only worked if the feature
          # files were were assured to be processed last which was accomplished
          # by overriding YARD::SourceParser to make it load file in a similar
          # order as Cucumber.
          #
          # As of YARD 0.7.0 this is no longer necessary as there are callbacks
          # that can be registered after all the files have been loaded. That
          # callback _after_parse_list_ is defined below and performs the
          # functionality described above.
          #
        end

        #
        # Register, once, when that when all files are finished to perform
        # the final matching of feature steps to step definitions and step
        # definitions to step placeholders.
        #
        YARD::Parser::SourceParser.after_parse_list do |files,globals|
          # For every feature found in the Registry, find their steps and step
          # definitions...
          YARD::Registry.all(:feature).each do |feature|
            log.debug "Finding #{feature.file} - steps, step definitions, and step placeholders"
            FeatureHandler.match_steps_to_step_definitions(feature)
          end
        end

        class << self
          def match_steps_to_step_definitions(statement)
            if statement
              # For the background and the scenario, find the steps that have definitions
              process_scenario(statement.background) if statement.background

              statement.scenarios.each do |scenario|
                if scenario.outline?
                  #log.info "Scenario Outline: #{scenario.value}"
                  scenario.scenarios.each_with_index do |example,index|
                    #log.info " * Processing Example #{index + 1}"
                    process_scenario(example)
                  end
                else
                  process_scenario(scenario)
                end
              end
            else
              log.warn "Empty feature file.  A feature failed to process correctly or contains no feature"
            end

          rescue YARD::Handlers::NamespaceMissingError
          rescue Exception => exception
            log.error "Skipping feature because an error has occurred."
            log.error "\n#{exception}\n#{exception.backtrace.join("\n")}\n"
          end

          # process a scenario
          def process_scenario(scenario)
            scenario.steps.each {|step| process_step(step) }
          end

          # process a step
          def process_step(step)
            match_step_to_step_definition_and_placeholders(step)
          end

          #
          # Given a step object, attempt to match that step to a step
          # transformation
          #
          def match_step_to_step_definition_and_placeholders(step)
            YARD::Registry.all(:stepdefinition).each do |stepdef|
              stepdef_matches = stepdef.regex.match(step.value)

              if stepdef_matches
                step.definition = stepdef
                # Step has been matched to step definition and step placeholders
                # TODO: If the step were to match again then we would be able to display ambigous step definitions
                break
              end
            end
          end
        end
      end
    end
  end
end
