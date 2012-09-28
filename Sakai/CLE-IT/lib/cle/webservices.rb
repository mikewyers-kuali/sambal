module Webservices

  def create_job
    url = "#{$server}/sakai-axis/SakaiJob.jws?method=createJob&sessionId=#{$admin_session_id}&name=#{$test_job_name}&type=#{$test_job_type}"
    puts url
    Nokogiri::HTML(open(url)).text
  end

  def run_job
    url = "#{$server}/sakai-axis/SakaiJob.jws?method=runJob&sessionId=#{$admin_session_id}&name=#{$test_job_name}"
    puts url
    Nokogiri::HTML(open(url)).text
  end

  def get_user_type
    url = "#{$server}/sakai-axis/SakaiScript.jws?method=getUserType&sessionid=#{$admin_session_id}&userid=#{$user_id}"
    puts url
    Nokogiri::HTML(open(url)).text
  end

  def find_site_by_property
    url = "#{$server}/sakai-axis/SakaiScript.jws?method=findSiteByProperty&sessionid=#{$admin_session_id}&propertyName=externalSiteId&propertyValue=#{$site_id}"
    puts url
    Nokogiri::HTML(open(url)).text
  end

  def delete_job
    url = "#{$server}/sakai-axis/SakaiJob.jws?method=deleteJob&sessionId=#{$admin_session_id}&name=#{$test_job_name}"
    puts url
    Nokogiri::HTML(open(url)).text
  end

  def delete_site
    url = "#{$server}/sakai-axis/SakaiScript.jws?method=removeSite&sessionid=#{$admin_session_id}&siteid=#{$siteId}"
    puts "url = #{url}"
    doc = Nokogiri::HTML(open(url))
    puts "text = #{doc.text}"
  end

  def get_sites_user_can_access
    url = "#{$server}/sakai-axis/SakaiScript.jws?method=getSitesUserCanAccess&sessionid=#{$admin_session_id}&eid=#{$user_id}"
    puts url
    Nokogiri::HTML(open(url)).text
  end

end