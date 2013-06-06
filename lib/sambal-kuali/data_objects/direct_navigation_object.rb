# Stores constants for direct navigation URL's
# class attributes are initialized with the constants to act as a repository for direct links
# Current Usage: Navigation to pages that cannot be navigated to by hyperlink for Authorization Tests
class DirectNavigation
  include Foundry
  include DataFactory
  include DateFactory
  include StringFactory
  include Workflows

  attr_accessor :edit_course_offering,
                :edit_activity_offering,
                :manage_course_offering,
                :create_course_offering,
                :course_offering_results,
                :single_course_results,
                :manage_registration_group

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :edit_course_offering=> "#{$test_site}/kr-krad/courseOffering?showHome=false&courseOfferingInfo.id=b8bfd4cd-a804-41d0-8659-f4a1a3771e92&methodToCall=maintenanceEdit&history=null%255E%2524%255Enull%255E%2524%255EHome%255E%2524%255Ehttp%253A%252F%252Fenv2.ks.kuali.org%252Fportal.do%255E%2524%255Enull%2524%255E%2524courseOfferingManagementView%255E%2524%255EsearchInputPage%255E%2524%255EManage%2BCourse%2BOfferings%255E%2524%255Ehttp%253A%252F%252Fenv2.ks.kuali.org%252Fkr-krad%252FcourseOfferingManagement%253FmethodToCall%253Dstart%2526pageId%253DsearchInputPage%2526withinPortal%253Dfalse%2526viewId%253DcourseOfferingManagementView%2526formKey%253D4c449395-8f1d-4f15-bed6-0db4a274b372%2526showHome%253Dfalse%255E%2524%255E4c449395-8f1d-4f15-bed6-0db4a274b372&dataObjectClassName=org.kuali.student.enrollment.class2.courseoffering.dto.CourseOfferingEditWrapper",
        :edit_activity_offering=>"#{$test_site}/kr-krad/activityOffering?showHome=false&courseOfferingId=b8bfd4cd-a804-41d0-8659-f4a1a3771e92&methodToCall=maintenanceEdit&history=null%255E%2524%255Enull%255E%2524%255EHome%255E%2524%255Ehttp%253A%252F%252Fenv2.ks.kuali.org%252Fportal.do%255E%2524%255Enull%2524%255E%2524courseOfferingManagementView%255E%2524%255EsearchInputPage%255E%2524%255EManage%2BCourse%2BOfferings%255E%2524%255Ehttp%253A%252F%252Fenv2.ks.kuali.org%252Fkr-krad%252FcourseOfferingManagement%253FpageId%253DsearchInputPage%2526methodToCall%253Dstart%2526withinPortal%253Dfalse%2526viewId%253DcourseOfferingManagementView%2526formKey%253Dbb17bf70-210e-4cfd-be30-940cc828b5af%2526showHome%253Dfalse%255E%2524%255Ebb17bf70-210e-4cfd-be30-940cc828b5af&aoInfo.id=ff255717-2a11-4a97-ac8a-cf4a38433f79&dataObjectClassName=org.kuali.student.enrollment.class2.courseoffering.dto.ActivityOfferingWrapper",
        :manage_course_offering=>"#{$test_site}/kr-krad/courseOffering?methodToCall=start&dataObjectClassName=org.kuali.student.enrollment.class2.courseoffering.dto.CourseOfferingCreateWrapper&hideReturnLink=true",
        :course_offering_results=>"#{$test_site}/kr-krad/courseOfferingManagement?viewId=courseOfferingManagementView&pageId=searchInputPage&methodToCall=start&withinPortal=false",
        :single_course_results=>"#{$test_site}/kr-krad/courseOfferingManagement?viewId=courseOfferingManagementView&pageId=searchInputPage&methodToCall=start&withinPortal=false",
        :manage_registration_group=>"#{$test_site}/kr-krad/registrationGroupManagement?previousFormKey=89201957-5ddf-4a7f-b1d9-dfefd3bbc13e&withinPortal=false&pageId=manageRegistrationGroupsPage&previousViewId=courseOfferingManagementView&showHome=false&methodToCall=start&coInfo.id=b8bfd4cd-a804-41d0-8659-f4a1a3771e92&history=null%255E%2524%255Enull%255E%2524%255EHome%255E%2524%255Ehttp%253A%252F%252Fenv2.ks.kuali.org%252Fportal.do%255E%2524%255Enull%2524%255E%2524courseOfferingManagementView%255E%2524%255EsearchInputPage%255E%2524%255EManage%2BCourse%2BOfferings%255E%2524%255Ehttp%253A%252F%252Fenv2.ks.kuali.org%252Fkr-krad%252FcourseOfferingManagement%253FmethodToCall%253Dstart%2526pageId%253DsearchInputPage%2526withinPortal%253Dfalse%2526viewId%253DcourseOfferingManagementView%2526formKey%253D89201957-5ddf-4a7f-b1d9-dfefd3bbc13e%2526showHome%253Dfalse%255E%2524%255E89201957-5ddf-4a7f-b1d9-dfefd3bbc13e&previousFormHistory=null%255E%2524%255Enull%255E%2524%255EHome%255E%2524%255Ehttp%253A%252F%252Fenv2.ks.kuali.org%252Fportal.do%255E%2524%255Enull%2524%255E%2524courseOfferingManagementView%255E%2524%255EsearchInputPage%255E%2524%255EManage%2BCourse%2BOfferings%255E%2524%255Ehttp%253A%252F%252Fenv2.ks.kuali.org%252Fkr-krad%252FcourseOfferingManagement%253FmethodToCall%253Dstart%2526pageId%253DsearchInputPage%2526withinPortal%253Dfalse%2526viewId%253DcourseOfferingManagementView%2526formKey%253D89201957-5ddf-4a7f-b1d9-dfefd3bbc13e%2526showHome%253Dfalse%255E%2524%255E89201957-5ddf-4a7f-b1d9-dfefd3bbc13e&previousControllerPath=courseOfferingManagement&viewId=manageRegistrationGroupsView&previousHomeUrl=http%3A%2F%2Fenv2.ks.kuali.org%2Fportal.do",
        :create_course_offering=>"#{$test_site}/kr-krad/courseOffering?methodToCall=start&dataObjectClassName=org.kuali.student.enrollment.class2.courseoffering.dto.CourseOfferingCreateWrapper&hideReturnLink=true"
    }
    options = defaults.merge(opts)
    set_options(options)
  end

  def setup_navigation
    @course_offering = make CourseOffering, :term=>Rollover::MAIN_TEST_TERM_SOURCE, :course=>"CHEM132"
    @course_offering.manage
    on ManageCourseOfferings do |page|
      page.edit('A')
    end
    @edit_activity_offering = @browser.url
  end
end