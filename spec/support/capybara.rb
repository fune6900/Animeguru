require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.register_driver :remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('no-sandbox')
  options.add_argument('headless')
  options.add_argument('disable-gpu')
  options.add_argument('window-size=1024,768') # ウィンドウサイズ調整
  options.add_argument('disable-dev-shm-usage') # /dev/shmの使用を無効にしてメモリを直接使用
  options.add_argument('disable-software-rasterizer') # ソフトウェアラスタライザーを無効にする
  options.add_argument('disable-extensions') # 拡張機能を無効にする
  Capybara::Selenium::Driver.new(app, browser: :remote, url: ENV['SELENIUM_DRIVER_URL'], capabilities: options)
end

Capybara.javascript_driver = :selenium_chrome_headless
