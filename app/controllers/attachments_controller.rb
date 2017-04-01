class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(attachments_params)

    if current_user.id == @attachment.getPolymorphicResource.user_id
      @attachment.destroy
    end
  end

  private

  def attachments_params
    params.require(:id)
  end
end