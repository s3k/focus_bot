class ApplicationHandler < SnapList::Handler

  private

  def user
    uid = @resp.message.from.id
    @user ||= User.find_by(tg_id: uid)
  end

  def notify_result(status)
    UserService.new(@resp).list("*#{status}. Текущий список дел:*")
  end
end
