class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(attachments_params)
    @attachment.destroy if current_user.author?(@attachment.attachmentable)
  end

  private

  def attachments_params
    params.require(:id)
  end
end