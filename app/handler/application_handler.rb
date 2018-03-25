class ApplicationHandler < Telegraph::Handler

  private

  def user
    uid = @resp.message.from.id
    @user ||= User.find_by(tg_id: uid)
  end

  def notify_result(status)
    UserHandler.new(@resp).list("*#{status}. Список дел*")
  end
end
