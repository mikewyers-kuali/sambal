module HelperModule

  def do_login(user, password)
    begin
      doc = Nokogiri::HTML(open("#{@server}/sakai-axis/SakaiLogin.jws?method=login&id=#{user}&pw=#{password}"))
      session_id = doc.css('loginreturn').text
    rescue
      session_id = nil
    end
    session_id
  end

  def admin_login
   $admin_session_id = do_login(@admin_user, @admin_password)
  end

  def admin_logged_in
    !$admin_session_id.nil?
  end

  def regular_user_login
    $regular_user_session_id = do_login(@regular_user, @regular_password)
  end

  def regular_user_logged_in
    !$regular_user_session_id.nil?
  end

end
