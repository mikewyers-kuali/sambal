module Authenticate

  def do_login(user, password)
    begin
      doc = Nokogiri::HTML(open("#{$server}/sakai-axis/SakaiLogin.jws?method=login&id=#{user}&pw=#{password}"))
      session_id = doc.css('loginreturn').text
    rescue
      session_id = nil
    end
    session_id
  end

  def admin_login
   $admin_session_id = do_login($admin_user, $admin_password)
  end

  def admin_logged_in
    !$admin_session_id.nil?
  end

  def role_user_login
    $role_user_session_id = do_login($role_user, $role_password)
  end

  def role_user_logged_in
    !$role_user_session_id.nil?
  end

end
