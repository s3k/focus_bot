class ApplicationHandler < SnapList::Handler

  private

  def user
    uid = @resp.message.from.id
    @user ||= User.find_by(tg_id: uid)
  end
end
