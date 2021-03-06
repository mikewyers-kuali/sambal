#================
# Blog Pages - NOT "Blogger"
#================

#
module BlogsMethods
  include PageObject
  # Returns an array containing the list of Bloggers
  # in the "All the blogs" table.
  def blogger_list
    bloggers = []
    frm.table(:class=>"listHier lines").rows.each do |row|
      bloggers << row[1].text
    end
    bloggers.delete_at(0)
    return bloggers
  end

  in_frame(:class=>"portletMainIframe") do |frame|
  end
end