require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # Run in visible mode if VISIBLE_TESTS environment variable is set
  # Otherwise run in headless mode (good for CI)
  if ENV["VISIBLE_TESTS"]
    driven_by :selenium, using: :chrome, screen_size: [ 1400, 1400 ]
  else
    driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]
  end
end
