require "puma/plugin"
require "selenium-webdriver"

# Capybara.register_driver :chrome_kiosk do |app|
#   caps = Selenium::WebDriver::Remote::Capabilities.chrome( 
#     'chromeOptions' => {
#       "args" => [ "--start-maximized", "--otherthings" ]
#     } 
#   )

#   $driver = Capybara::Selenium::Driver.new(app, {:browser => :chrome, :desired_capabilities => caps})
# end

# caps = Selenium::WebDriver::Remote::Capabilities.chrome(
#   "moz:chromeOptions" => {
#     args: ["--start-maximized"] # and other arguments... 
#   }
# )

Puma::Plugin.create do
  def start(launcher)
    puts "PUMA START"

    Thread.new do
      sleep 5

      puts "LAUNCH CHROME"

      # pid = spawn("\"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome\" --user-data=chrome --app=\"http://localhost:3000/splash\" --kiosk --start-maximized --autoplay-policy=no-user-gesture-required")
      # Process.wait(pid)

      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--kiosk')
      options.add_argument('--start-maximized')
      options.add_argument('--autoplay-policy=no-user-gesture-required')

      driver = Selenium::WebDriver.for :chrome, options: options
      driver.get 'http://localhost:3000/splash'

      wait = Selenium::WebDriver::Wait.new(timeout: 60)

      element = wait.until { driver.find_element(:id, 'permissions-button') }
      element.click

      loop do
        sleep 1
        begin
          driver.current_url
        rescue Selenium::WebDriver::Error::NoSuchWindowError
          puts "Shutting down"
          Process.kill("TERM", Process.pid)
        end
      end
    end
    # #Extract the link we want to go to
    # address = driver.find_element(:link_text, "Gmail").attribute('href')

    # #Open a new browser window
    # driver.execute_script( "window.open()" )

    # #Use the newest window
    # driver.switch_to.window( driver.window_handles.last )
    # driver.get 'http://yahoo.com'
  end
end