class CustomComponentsData
  include Foundry
  include DataFactory

  attr_accessor :course, :gpa, :test_score, :test_name, :department, :organization, :grade_select

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
    }

    options = defaults.merge(opts)

    set_options(options)
  end
end