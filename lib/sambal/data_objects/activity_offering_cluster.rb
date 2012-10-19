class ActivityOfferingCluster

  include PageHelper
  include Workflows
  include Utilities

  attr_accessor :is_default,
                :private_name,
                :published_name,
                :is_valid,
                :expected_msg,
                :assigned_ao_list

  alias_method :default?, :is_default
  alias_method :valid?, :is_valid

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :is_default=>false,
        :private_name=>"test1_pri",
        :published_name=>"test1_pub",
        :is_valid=>true,
        :expected_msg=>"",
        :assigned_ao_list=>["A","AA","AB"]
    }
    options = defaults.merge(opts)
    set_options(options)
  end

  def create
    on ManageRegistrationGroups do |page|

      page.private_name.set @private_name
      page.published_name.set @published_name
      page.create_new_cluster_button
      puts page.ao_table.rows.count
      puts page.cluster_list_row_name_text("test1pri")
      page.ao_cluster_select.select("test1")
      page.cluster_list_row_generate_reg_groups("test1")
      puts page.target_ao_row("A").cells[1].text
      puts page.target_ao_row("A").cells[2].text
      page.select_ao_row("A")
      page.ao_cluster_select.select("test1pub")
      page.ao_cluster_assign_button
    end
  end

end
