class Api::V1::UploadsController < ApplicationController
  def index
    user = User.find(params[:userid])
    attachments = user.attachments.order(updated_at: :desc)
    render json: attachments.map { |attachment|
      attachment.as_json.merge({ file_name: attachment.csv_file.filename.to_s })
    }
  end

  def create
    original_file = params[:csv_file]
    file_type = original_file.content_type
    if ['text/csv', 'text/x-csv', 'application/csv', 'application/x-csv', 'text/comma-separated-values', 'text/x-comma-separated-values', 'application/vnd.ms-excel', 'text/plain'].include? file_type
      user_id = params[:userid]
      attachment = Attachment.create(user_id: user_id, csv_file: original_file, processed: false)
      ExportWorker.perform_async(attachment.id)
      render json: { error: false, message: "File is processing" }
    else
      render json: { error: true, message: "File format not supported. Please upload CSV file." }, status: :not_acceptable
    end
  end
end
