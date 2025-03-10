# frozen_string_literal: true

require "ferrum"

module Images
  # Saves web page as screenshot.
  class Screensaver
    SETTINGS = {
      browser_options: {
        "disable-dev-shm-usage" => nil,
        "disable-gpu" => nil,
        "hide-scrollbar" => nil,
        "no-sandbox" => nil
      },
      js_errors: true,
      window_size: [800, 480]
    }.freeze

    def initialize settings: SETTINGS, browser: Ferrum::Browser
      @settings = settings
      @browser = browser
    end

    def call content, path
      save content, path
      path
    end

    private

    attr_reader :settings, :browser

    def save content, path
      browser.new(settings).then do |instance|
        instance.create_page
        instance.resize(**dimensions)
        instance.execute "document.documentElement.innerHTML = `#{content}`;"
        instance.network.wait_for_idle
        instance.screenshot path: path.to_s
        instance.quit
      end
    end

    def dimensions = settings.fetch(:window_size).then { |width, height| {width:, height:} }
  end
end
