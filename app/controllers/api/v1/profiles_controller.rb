class Api::V1::ProfilesController < Api::V1::BaseController

  def me
    authorize! :me, current_resource_owner
    respond_with current_resource_owner
  end

  def list
    authorize! :list, current_resource_owner
    respond_with User.all_another_users(current_resource_owner)
  end

  
end
