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


    element(:delivery_logistics_table) { |b| b.frm.div(id: "ActivityOffering-DeliveryLogistic-Actuals").table }
    TBA_COLUMN = 0
    DAYS_COLUMN = 1
    ST_TIME_COLUMN = 2
    END_TIME_COLUMN = 3
    FACILITY_COLUMN = 4
    ROOM_COLUMN = 5
    CAPACITY_COLUMN = 6
    FEATURES_COLUMN = 7

    value(:days) { |b| b.delivery_logistics_table.rows[1].cells[DAYS_COLUMN].text }


    #value(:days) { |b| b.frm.div(data_label: "Days").span(index: 2).text }
    #value(:start_time) { |b| b.frm.div(data_label: "Start Time").span(index: 2).text }
    #value(:start_time_ampm) { |b| b.frm.div(id: "u349").span(id: "u349").text } #TODO static id
    #value(:end_time) { |b| b.frm.div(data_label: "End Time").span(index: 2).text }
    #value(:end_time_ampm) { |b| b.frm.div(id: "u379").span(id: "u379").text }  #TODO  static id
    #value(:facility) { |b| b.frm.div(data_label: "Facility").span(index: 2).text }
    #value(:room) { |b| b.frm.div(data_label: "Room").span(index: 2).text }

    element(:personnel_table) { |b| b.frm.div(id: "ao-personnelgroup").table() }
    ID_COLUMN = 0
    PERS_NAME_COLUMN = 1
    AFFILIATION_COLUMN = 2
    INST_EFFORT_COLUMN = 3

    def get_affiliation(id)
      target_person_row(id).cells[AFFILIATION_COLUMN].text
      #target_person_row(id).span(id: /u725_line/).text
    end

    def get_inst_effort(id)
      target_person_row(id).cells[INST_EFFORT_COLUMN].text
      #target_person_row(id).span(id: /u740_line/).text
    end

    element(:seat_pools_table) { |b| b.frm.div(id: "ao-seatpoolgroup").table() } # Need persistent ID!

    PRIORITY_COLUMN = 0
    SEATS_COLUMN = 1
    PERCENT_COLUMN = 2
    POP_NAME_COLUMN = 3
    EXP_MILESTONE_COLUMN = 4

    value(:seat_pool_count) { |b| b.frm.div(data_label: "Seat Pools").span(index: 2).text }
    value(:seats_remaining) { |b| b.frm.div(data_label: "Seats Remaining").span(index: 2).text }
    value(:percent_seats_remaining) {  |b| b.frm.div(data_label: "Seats Remaining").span(index: 2).text[/\d+(?=%)/] }
    value(:seat_count_remaining) {  |b| b.frm.div(data_label: "Seats Remaining").span(index: 2).text[/\d+(?=.S)/] }
    value(:course_url) { |b| b.frm.div(data_label: "Course URL").span(index: 2).text }
    value(:evaluation)  { |b| b.frm.div(data_label: "This lecture requires an evaluation").span().text }
    value(:honors){ |b| b.frm.div(data_label: "This is an honors course").span().text }

    def get_priority(pop_name)
      target_pool_row(pop_name).cells[PRIORITY_COLUMN].text
      #target_pool_row(pop_name).div(id: /u886_line/).span(id: /u886_line/).text
    end

    def get_seats(pop_name)
      target_pool_row(pop_name).div(id: /seatLimit_line/).span(id: /seatLimit_line/).text
    end

    def get_pool_percentage(pop_name)
      target_pool_row(pop_name).div(id: /seatLimitPercent_line/).span(id: /seatLimitPercent_line/).text
    end

    def get_expiration_milestone(pop_name)
      target_pool_row(pop_name).cells[EXP_MILESTONE_COLUMN].text
      #target_pool_row(pop_name).div(id: /u927_line/).span(id: /u927_line/).text
    end

    private

    def target_pool_row(pop_name)
      seat_pools_table.row(text: /#{Regexp.escape(pop_name.to_s)}/)
    end

    def target_person_row(id)
      personnel_table.row(text: /#{Regexp.escape(id.to_s)}/)
    end


end