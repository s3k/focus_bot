class CommonHandler < ApplicationHandler
  def cancel
    user.update_attributes(context: nil)
    UserHandler.new(@resp).list
  end
end
