class CommonService < ApplicationHandler
  def cancel
    user.update_attributes(context: nil)
    UserService.new(@resp).list
  end
end
