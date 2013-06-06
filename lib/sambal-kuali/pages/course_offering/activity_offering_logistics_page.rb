class ActivityOfferingLogistics < BasePage

  frame_element
  wrapper_elements

  action(:save_request) { |b| b.frm.button(text: "Save Request").click; b.loading.wait_while_present }
  action(:cancel_element) { |b| b.frm.link(text: "Cancel") }
  action(:cancel) { |b| b.cancel_element.click; b.loading.wait_while_present }
  action(:save_and_process) { |b| b.frm.button(text: "Save and Process Request").click; b.loading.wait_while_present }

end