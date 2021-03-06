# coding: UTF-8

# Methods related to the expandable Collector item that can appear at the top of any page.
module CollectorWidget

  include PageObject

end

# Methods associated with the editing of Pages/Documents.
module DocumentWidget

  include PageObject

  thing(:insert_text) { |b| b.link(:title=>"Insert text block") }
  thing(:insert_title) { |b| b.link(:title=>"Insert title") }
  thing(:title_container) { |b| b.div(:class=>"pagetitle_widget") }
  thing(:title_field) { |b| b.text_field(:title=>"Title") }
  thing(:rich_text_editor) { |b| b.frame(:id=>/mce_\d+_ifr/).body(:id=>"tinymce")}
  thing(:insert_image) { |b| b.link(:title=>"Insert image") }
  thing(:insert_video) { |b| b.link(:title=>"Insert video") }
  thing(:insert_file_list) { |b| b.link(:title=>"Insert file list") }
  thing(:insert_web_page) { |b| b.link(:title=>"Insert web page") }
  thing(:insert_discussion_forum) { |b| b.link(:title=>"Insert Discussion forum") }
  thing(:insert_comment_stream) { |b| b.link(:title=>"Insert Comment stream") }
  thing(:insert_google_map) { |b| b.link(:title=>"Insert Google map") }
  thing(:cancel_edit) { |b| b.link(:id=>"inserterbar_cancel_edit_page") }
  thing(:save_changes) { |b| b.link(:id=>"inserterbar_save_edit_page") }
  thing(:view_more_widgets) { |b| b.link(:id=>"inserterbar_more_widgets") }
  thing(:carousel_left) { |b| b.div(:id=>"inserterbar_carousel_left") }
  thing(:carousel_right) { |b| b.div(:id=>"inserterbar_carousel_right") }
  thing(:container) { |b| b.div(:id=>"contentauthoring_widget").div(:id=>/-id\d+/, :index=>-1).div(:class=>"contentauthoring_table_row") }
  thing(:edit_box_element) { |b| b.div(:class=>"contentauthoring_dummy_element") }


  def add_text text
    if edit_box_element.present?
      edit_box_element.double_click
    else
      insert_video.drag_and_drop_by 0,90
      insert_image.drag_and_drop_by 0,85
      insert_google_map.drag_and_drop_by 0,83
      insert_text.drag_and_drop_by 0,81
      rich_text_editor.send_keys text
    end
  end

  def add_title title
    insert_text.drag_and_drop_by 0,85
    insert_video.drag_and_drop_by 0,85
    insert_google_map.drag_and_drop_by 0,83
    insert_title.drag_and_drop_by 0,80
    title_field.wait_until_present
    title_field.set(title)
  end

  def add_google_map
    insert_web_page.drag_and_drop_by 0,85
    insert_video.drag_and_drop_by 0,81
    insert_image.drag_and_drop_by 0,82
    insert_google_map.drag_and_drop_by 0,81
    self.class.class_eval { include GoogleMapsPopUp }
  end

  def add_comment_stream
    insert_video.drag_and_drop_by 0,85
    insert_image.drag_and_drop_by 0,82
    insert_google_map.drag_and_drop_by 0,83
    insert_comment_stream.drag_and_drop_by 0,81
    self.class.class_eval { include CommentStreamPopUp }
  end

end

# Methods related to the Library List page.
module LibraryWidget

  include PageObject

  text_field(:search_library, :id=>"mylibrary_livefilter")
  checkbox(:select_all_library_items, :id=>"mylibrary_select_checkbox")
  button(:add_selected_to_buton, :id=>"mylibrary_addpeople_button")
  button(:remove_selected_button, :id=>"mylibrary_remove")
  button(:share_selected_button, :id=>"mylibrary_content_share")
  select_list(:sort_by_list, :id=>"mylibrary_sortby")

  # Enters the specified string in the search field.
  # Note that it appends a line feed on the string, so the
  # search occurs immediately.
  def search_library_for=(text)
    self.search_library=("#{text}\n")
    self.wait_for_ajax
  end

  def sort_by=(sort_option)
    self.sort_by_list=sort_option
    self.linger_for_ajax(2)
  end

  # Returns the checkbox element itself for the specified
  # item in the list. Use this method for checking whether or
  # not the checkbox in question is selected or not--e.g.,
  # library.checkbox("textfile.txt").should be_set
  def checkbox(item)
    name_li(item).checkbox
  end

  # Checks the specified Library item.
  def check_content(item)
    name_li(item).checkbox.set
  end

  # Unchecks the specified library item.
  def uncheck_content(item)
    name_li(item).checkbox.clear
  end

  def add_selected_to
    self.add_selected_to_button
    self.wait_for_ajax
    self.class.class_eval { include AddToGroupsPopUp }
  end

  def add_to(name)
    name_li(name)
    # TODO - Finish writing this method
  end

  def share_selected
    self.share_selected_button
    self.text_field(:name=>"newsharecontent_sharelist").wait_until_present
    self.class.class_eval { include ShareWithPopUp }
  end

  def remove_selected
    self.remove_selected_button
    self.div(:id=>"deletecontent_dialog").wait_until_present
    self.class.class_eval { include DeleteContentPopUp }
  end

end

# Contains methods common to all Results lists
module ListWidget

  include PageObject

  # Page Objects
  # select_list(:sort_by, :id=>/sortby/) Collision with method in Library widget
  select_list(:filter_by, :id=>"facted_select")

  # Custom Methods...
  def item_li(item_name)
    self.link(:title=>item_name).parent.parent.parent
  end

  # Returns an array containing the text of the links (for Groups, Courses, etc.) listed
  def results_list
    list = []
    begin
      self.spans(:class=>"s3d-search-result-name").each do |element|
        list << element.text
      end
    rescue
      list = []
    end
    list
  end
  alias courses results_list
  alias course_list results_list
  alias groups_list results_list
  alias groups results_list
  alias projects results_list
  alias documents results_list
  alias documents_list results_list
  alias content_list results_list
  alias results results_list
  alias people_list results_list
  alias contacts results_list
  alias memberships results_list

  # Gets the text describing when the specified item was last changed.
  def last_updated(name)
    # Get the target class...
    klass = case
              when item_li(name).div(:class=>"searchgroups_result_usedin").present?
                "searchgroups_result_usedin"
              when item_li(name).div(:class=>"searchcontent_result_by").present?
                "searchcontent_result_by"
              when item_li(name).div(:class=>"mymemberships_item_usedin").present?
                "mymemberships_item_usedin"
              when item_li(name).div(:class=>"mylibrary_item_by").present?
                "mylibrary_item_by"
              else
                puts "Didn't find any expected DIVs. Please investigate and add missing class value"
                puts
                puts item_li(name).html
            end
    # Grab the text now that we know the class of the div...
    div_text = item_li(name).div(:class=>klass).text
    case(klass)
      when "mylibrary_item_by"
        return div_text[/(?<=\|.).+/]
      when "searchgroups_result_usedin"
        return div_text[/^.+(?=.\|)/]
      when "mymemberships_item_usedin"
        return div_text[/^.+(?=.\|)/]
      when "searchcontent_result_by"
        return div_text[/(?<=\|.).+/]
    end

  end
  alias last_changed last_updated

end

# Methods related to lists of Collections
module ListCollections

  include PageObject

end

# Methods related to lists of Content-type objects
module ListContent

  include PageObject

  # Returns the src text for the specified item's
  # Thumbnail image.
  def thumbnail(name)
    name_li(name).link(:title=>"View this item").image.src
  end

  # Clicks to share the specified item. Waits for the page
  # to refresh to bring up the Share Pop Up dialog.
  def share(name)
    name_li(name).button(:title=>"Share content").click
    self.wait_until { self.text.include? "Or, share it on a webservice:" }
    self.class.class_eval { include ShareWithPopUp }
  end

  # Adds the specified (listed) content to the library.
  def add_to_library(name)
    self.button(:title=>"Save #{name}").click
    self.wait_until { self.div(:id=>"savecontent_widget").visible? }
    self.class.class_eval { include SaveContentPopUp }
  end

  def delete(name)
    name_li(name).button(:title=>"Remove").click
    self.div(:id=>"deletecontent_dialog").wait_until_present
    self.class.class_eval { include DeleteContentPopUp }
  end
  alias remove_item delete

  # Clicks to view the owner information of the specified item.
  def view_owner_of(name)
    name_li(name).link(:class=>/s3d-regular-light-links (mylibrary_item_|searchcontent_result_)username/).click
    self.div(:id=>"entity_name").wait_until_present
    ViewPerson.new @browser
  end

  # Returns the item's owner name (as a text string).
  def content_owner(name)
    name_li(name).div(:class=>/(mylibrary_item_|searchcontent_result_)by/).link.text
  end

  # Returns an Array object containing the list of tags/categories
  # listed for the specified content item.
  def content_tags(name)
    array = []
    name_li(name).div(:class=>/(mylibrary_item_|searchcontent_result_)tags/).lis.each do |li|
      array << li.span(:class=>"s3d-search-result-tag").text
    end
    return array
  end

  # Returns the mimetype text next to the Content name--the text that describes
  # what the system thinks the content is.
  def content_type(name)
    name_li(name).span(:class=>/(mylibrary_item_|searchcontent_result_)mimetype/).text
  end

  def content_description(name)
    name_li(name).div(:class=>/(mylibrary_item_|searchcontent_result_)description/).text
  end

  def search_by_tag(tag)
    name_link(tag).click
    sleep 3
    self.wait_for_ajax
    ExploreAll.new @browser
  end

  def used_in_count(name)
    used_in_text(name)[/(?<=in.)\d+/].to_i
  end

  def comments_count(name)
    used_in_text(name)[/\d+(?=.comment)/].to_i
  end

  #Private methods
  private

  def used_in_text(name)
    name_li(name).div(:class=>/(mylibrary_item_|searchcontent_result_)usedin/).text
  end

end # ListContent

# Methods related to lists of People/Participants
module ListPeople

  include PageObject

  # Clicks the plus sign next to the specified Contact name.
  # Obviously the name must exist in the list.
  def add_contact(name)
    self.button(:title=>"Request connection with #{name}").click
    self.wait_until { @browser.button(:text=>"Invite").visible? }
    self.class.class_eval { include AddToContactsPopUp }
  end
  alias request_contact add_contact
  alias request_connection add_contact

  # Clicks the X to remove the selected person from the
  # Contacts list (in My Contacts).
  def remove(name)
    self.button(:title=>"Remove contact #{name}").click
    self.wait_for_ajax
    self.class.class_eval { include RemoveContactsPopUp }
  end
  alias remove_contact remove

  def send_message_to(name)
    name_li(name).button(:class=>"s3d-link-button s3d-action-icon s3d-actions-message searchpeople_result_message_icon sakai_sendmessage_overlay").click
    self.wait_for_ajax
    self.class.class_eval { include SendMessagePopUp }
  end

  # This method checks whether or not the listed
  # person has the "Add contact" button available.
  # To ensure the test case will be valid, it first
  # makes sure the specified person is in the list.
  # Returns true if the button is available.
  def addable?(name)
    if name_li(name).exists?
      self.button(:title=>"Request connection with #{name}").present?
    else
      puts "\n#{name} isn't in the results list. Check your script.\nThis may be a false negative.\n"
      return false
    end
  end

end

# Methods related to lists of Groups/Courses
module ListGroups

  include PageObject

  def join_button_for(name)
    name_li(name).div(:class=>/searchgroups_result_left_filler/)
  end

  # Clicks on the plus sign image for the specified group in the list.
  def add_group(name)
    join_button_for(name).fire_event("onclick")
    self.linger_for_ajax(1)
  end
  alias add_course add_group
  alias add_research add_group
  alias join_course add_group
  alias join_group add_group

  #
  def remove_membership(name)
    remove_membership_button(name).click
    self.linger_for_ajax
    self.class.class_eval { include LeaveWorldPopUp }
  end
  alias leave_group remove_membership

  # This returns the Remove button element itself, for the
  # specified Group/Course/Research listed. This is useful
  # for interacting directly with the element instead of
  # simply clicking on it.
  def remove_membership_button(name)
    self.button(:title=>"Remove membership from #{name}")
  end

  # Checks the checkbox for the specified group
  def check_group(name)
    self.checkbox(:title=>"Select #{name}").set
  end
  alias select_group check_group

  # Returns the specified item's "type", as shown next to the item name--i.e.,
  # "GROUP", "COURSE", etc.
  def group_type(name)
    self.span(:class=>"s3d-search-result-name",:text=>name).parent.parent.span(:class=>"mymemberships_item_grouptype").text
  end
  alias course_type group_type
  alias research_type group_type

  # Returns the number of content items (as an Integer, not a String) in the specified
  # course/group.
  def content_item_count(name)
    text = self.span(:class=>"s3d-search-result-name",:text=>name).parent.parent.parent.link(:title=>/\d+.content items/).text
    text[/\d+/].to_i
  end

  # Returns the count (as an Integer, not a String) of participants in the specified group/course.
  def participants_count(name)
    text = self.span(:class=>"s3d-search-result-name",:text=>name).parent.parent.parent.link(:title=>/\d+.participant/).text
    text[/\d+/].to_i
  end

  def view_group_participants(name)
    library_li(name).link(:title=>/\d+.participant/i).click
    self.linger_for_ajax(2)
    Participants.new @browser
  end

  # Clicks the Message button for the specified listed item.
  def message_course(name)
    message_button(name).click
    self.linger_for_ajax(2)
    self.class.class_eval { include SendMessagePopUp }
  end
  alias send_message_to_course message_course
  alias send_message_to_group message_course
  alias message_group message_course
  alias message_person message_course
  alias message_research message_course

  # Returns the message button element itself.
  def message_button(name)
    library_li(name).button(:class=>/sakai_sendmessage_overlay/)
  end

end

# Methods related to lists of Research Projects
module ListProjects

  include PageObject

  # Page Objects

  # Custom Methods...

  # Clicks the specified Link (will open any link that matches the
  # supplied text, but it's made for clicking on a Research item listed on
  # the page because it will instantiate the ResearchIntro class).
  def open_research(name)
    name_link(name).click
    sleep 1
    self.wait_for_ajax
    self.execute_script("$('#joinrequestbuttons_widget').css({display: 'block'})")
    ResearchIntro.new @browser
  end

  alias view_research open_research
  alias open_project open_research

end

# Methods related to the Participants "Area" or "Page" in
# Groups/Courses. This is not the same thing as the ManageParticipants
# module, which relates to the "Add People" Pop Up.
module ParticipantsWidget

  include PageObject

end

# Page Elements and Custom Methods that are shared among the three Error pages
module CommonErrorElements

  include PageObject

  # TBD

end
