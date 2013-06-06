class ActivityOfferingConfirmDelete < BasePage

  wrapper_elements
  validation_elements
  frame_element

  expected_element :delete_activity_offering_button

  element(:delete_activity_offering_button) { |b| b.frm.button(id: "AoDeleteConfirmationDeleteButton") }
  action(:delete_activity_offering) { |b| b.frm.button(id: "AoDeleteConfirmationDeleteButton").click; b.loading.wait_while_present }

  action(:cancel) { |b| b.frm.link(text: "Cancel").click; b.loading.wait_while_present }
  value(:delete_warning_message) { |b| b.frm.div(id: "KS-SelectedAoDeleteConfirmation-WarningMessage").text }
  value(:delete_confirm_message) { |b| b.frm.div(id: "KS-SelectedAoDeleteConfirmation-Message").text}

end