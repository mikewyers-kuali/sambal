class ErrorPage < BasePage
  wrapper_elements
  frame_element

  value(:error_message){|b| b.message_element.text}
  element(:message_element) { |b| b.frm.div(id: "Uif-Application")}

  def error_401
    present = error_message.include? "Error 401: This page contains restricted content"
    return present
  end
end