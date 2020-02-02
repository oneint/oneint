class ExportFile < ApplicationRecord
  include FileUploader::Attachment.new(:file)
  belongs_to :external_request
end
