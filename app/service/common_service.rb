class CommonService < ApplicationHandler
  def cancel
    user.update_attributes(context: nil)
    list_result("*Список текущих задач:*")
  end
end
