require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  downloads = File.expand_path(Rails.root + 'tmp/downloads')
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400], options: {prefs:{
      'download.default_directory' => downloads,
      'download.prompt_for_download' => false,
  }}
end
