class LUMMainPage < PageFactory

  #page_url "#{$test_site}/portal.do?selectedTab=main"
  page_url "#{$test_site}/org.kuali.student.lum.lu.ui.main.LUMMain/LUMMain.jsp#/HOME/CURRICULUM_HOME/DEFAULT"
  #expected_element :user_info_div

  element(:user_info_div)  { |b| b.link(:text=>"Logout").parent.parent }
  value(:logged_in_user) { |b| b.user_info_div.div(:index=>6).text }
  action(:logout) { |b| b.link(value: "Logout").click }
  element(:create_label) { |b| b.h2(:text=>"Create...") }

  element(:username_field) { |b| b.text_field(:name=>"j_username") }
  element(:password_field) { |b| b.text_field(:name=>"j_password") }
  element(:login_button) { |b| b.button(:value=>"Login") }
  action(:logout) { |b| b.link(text: "Logout").click }

  def login_with username, password
    username_field.set username
    password_field.set password
    login_button.click
    create_label.wait_until_present
  end

  def current_logged_in_user_id
    user = ""
    begin
      sleep 2
      create_label.wait_until_present(5)
      user = logged_in_user
    rescue Watir::Exception::UnknownObjectException
    rescue Watir::Wait::TimeoutError
      user = :no_user
    end
    user
  end

end