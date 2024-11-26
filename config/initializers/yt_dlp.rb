Rails.application.config.after_initialize do
  YtDlpManager.ensure_binary_exists
end
