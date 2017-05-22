class Api::V1::ProfilesController < Api::V1::BaseController

  authorize_resource class: User

  def me
    respond_with current_resource_owner
  end

  def list
    respond_with User.all_another_users(current_resource_owner)
  end
end
