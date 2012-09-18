class ActivityOfferingMaintenanceView < BasePage

    wrapper_elements
    validation_elements
    frame_element

    expected_element :header

    element(:header) { |b| b.frm.span(class: "uif-headerText-span") }

    value(:status) { |b| b.frm.div(data_label: "Status").span(index: 2).text }
    value(:term) { |b| b.frm.div(data_label: "Term").span(index: 2).text }
    value(:activity_type) { |b| b.frm.div(data_label: "Activity Type").span(index: 2).text }
    value(:format) { |b| b.frm.div(data_label: "Format").span(index: 2).text }
    value(:activity_code) { |b| b.frm.div(data_label: /Activity Code/).span(index: 2).text }
    value(:max_enrollment) { |b| b.frm.div(data_label: "Total Maximum Enrollment").span(index: 2).text }
    value(:days) { |b| b.frm.div(data_label: "Days").span(index: 2).text }
    value(:start_time) { |b| b.frm.div(data_label: "Start Time").span(index: 2).text }
    value(:start_time_ampm) { |b| b.frm.div(id: "u141").span(id: "u141").text } #TODO static id
    value(:end_time) { |b| b.frm.div(data_label: "End Time").span(index: 2).text }
    value(:end_time_ampm) { |b| b.frm.div(id: "u171").span(id: "u171").text }  #TODO  static id
    value(:facility) { |b| b.frm.div(data_label: "Facility").span(index: 2).text }
    value(:room) { |b| b.frm.div(data_label: "Room").span(index: 2).text }

    element(:personnel_table) { |b| b.frm.table(id: "u410") } # Need persistent ID!
    element(:seat_pools_table) { |b| b.frm.table(id: "u590") } # Need persistent ID!
    value(:seat_pool_count) { |b| b.frm.div(data_label: "Seat Pools").span(index: 2).text }
    value(:seats_remaining) { |b| b.frm.div(data_label: "Seats Remaining").span(index: 2).text }
    value(:percent_seats_remaining) {  |b| b.frm.div(data_label: "Seats Remaining").span(index: 2).text[/\d+(?=%)/] }
    value(:seat_count_remaining) {  |b| b.frm.div(data_label: "Seats Remaining").span(index: 2).text[/\d+(?=.S)/] }
    value(:course_url) { |b| b.frm.div(data_label: "Course URL").span(index: 2).text }
    value(:evaluation)  { |b| b.frm.div(id: "u813").span(id: "u813").text }
    value(:honors) { |b| b.frm.div(id: "u835").span(id: "u835").text }

    def get_affiliation(id)
      target_person_row(id).span(id: /u501_line/).text
    end

    def get_inst_effort(id)
      target_person_row(id).span(id: /u516_line/).text
    end

    def get_priority(pop_name)
      target_pool_row(pop_name).div(id: /u663_line/).span(id: /u663_line/).text
    end

    def get_seats(pop_name)
      target_pool_row(pop_name).div(id: /seatLimit_line/).span(id: /seatLimit_line/).text
    end

    def get_pool_percentage(pop_name)
      target_pool_row(pop_name).div(id: /seatLimitPercent_line/).span(id: /seatLimitPercent_line/).text
    end

    def get_expiration_milestone(pop_name)
      target_pool_row(pop_name).div(id: /u704_line/).span(id: /u704_line/).text
    end

    private

    def target_pool_row(pop_name)
      seat_pools_table.row(text: /#{Regexp.escape(pop_name.to_s)}/)
    end

    def target_person_row(id)
      personnel_table.row(text: /#{Regexp.escape(id.to_s)}/)
    end


end