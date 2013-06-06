class DeleteCourseOffering < BasePage

  wrapper_elements
  frame_element

  expected_element :term

  element(:term) { |b| b.frm.text_field(name: "termCode") }
  element(:course_offering_code) { |b| b.frm.radio(value: "courseOfferingCode") }
  element(:confirm_delete_button) { |b| b.frm.button(id: "coDeleteConfirmationResultSection_confirmDeleteButton") }

  action(:show) { |b| b.frm.button(text: "Show").click; sleep 2; b.loading.wait_while_present } # Persistent ID needed!


  value(:delete_warning_message) { |b| b.frm.div(id: "KS-CoDeleteConfirmation-WarningMessage").text }

  action(:confirm_delete) { |b| b.confirm_delete_button.click; b.loading.wait_while_present(300) }
  action(:cancel_delete) { |b| b.frm.link(id: "coDeleteConfirmationResultSection_cancelDeleteButton").click }


end