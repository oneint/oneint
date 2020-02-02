class FileUploader < Shrine
  plugin :remove_invalid
  plugin :determine_mime_type, analyzer: :marcel, analyzer_options: { filename_fallback: true }
  plugin :infer_extension
  plugin :remote_url, max_size: 20*1024*1024
end