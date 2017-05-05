class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment, only: [:destroy]

  respond_to :js

  authorize_resource

  def destroy
    respond_with(@attachment.destroy) if current_user.author?(@attachment.attachmentable)
  end

  private

  def load_attachment
    @attachment = Attachment.find(attachments_params)
  end

  def attachments_params
    params.require(:id)
  end
end