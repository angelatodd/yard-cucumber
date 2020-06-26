@scenarios @bvt
Feature: Step Placeholders
  As a developer of the test suite I expect that step placeholders are documented correctly

  @first
  Scenario: Step with custom placeholders
    Given this scenario step
    Then I expect that the step, on the step transformer page, will link to the step transform

  @first
  Scenario: Step with custom placeholders
    Given the first step
    Then I expect that the step, on the step transformer page, will link to the step transform

  @second
  Scenario: Step with simple placeholders
    Given the step called 'bob'
    And the steps called 'pop'
    Then I expect that the step, on the step transformer page, will link to the step transform

  @third
  Scenario: Step with multiple custom placeholders
    Given the second scenario step on 12/04/2020
    Then I expect that the step, on the step transformer page, will link to the step transform 

  @third
  Scenario: Step with both simple and custom placeholders
    Given the second 'bob' step
    Then I expect that the step, on the step transformer page, will link to the step transform
    
  Scenario: Step with complex placeholder reges
    Given the step at the [0 + 1] index
    Then I expect that the step, on the step transformer page, will link to the step transform
    
