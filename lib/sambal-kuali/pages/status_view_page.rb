class StatusViewPage < BasePage

  value(:soc_state) { |b| b.span(id: "soc").text }
  value(:soc_scheduling_state) { |b| b.span(id: "soc_scheduling").text }
  value(:co_state) { |b| b.span(id: "course_offering").text }

  element(:ao_table) { |b| b.table(id: "ao_list") }

  AO_CODE = 0
  AO_STATE = 1
  FO_STATE = 2
  AO_SCHEDULING_STATE = 3

  def target_rows(code)
    ao_table.rows(text: /\b#{Regexp.escape(code)}\b/)
  end

  def offered_aos()
    target_rows("Scheduled")
  end

  def approved_aos()
    target_rows("Approved")
  end

  def ao_state(row)
     row.cells[AO_STATE].text
  end

  def fo_state(row)
    row.cells[FO_STATE].text
  end

  def ao_scheduling_state(row)
    row.cells[AO_SCHEDULING_STATE].text
  end

end