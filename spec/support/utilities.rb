module Utilities

  RSpec::Matchers.define :have_error_message do |message|
    match do |page|
      expect(page).to have_selector('div[id^=flash_danger]', text: message)
    end
  end

  RSpec::Matchers.define :have_alert_message do |message|
    match do |page|
      expect(page).to have_selector('div[class^=alert]', text: message)
    end
  end

  RSpec::Matchers.define :have_info_message do |message|
    match do |page|
      expect(page).to have_selector('div[id^=flash_info]', text: message)
    end
  end

  RSpec::Matchers.define :be_accessible do |attribute|
    match do |response|
      response.class.accessible_attributes.include?(attribute)
    end
    description { "be accessible :#{attribute}" }
    failure_message_for_should { ":#{attribute} should be accessible" }
    failure_message_for_should_not{ ":#{attribute} should not be accessible" }
  end

  RSpec::Matchers::define :have_title do |text|
    match do |page|
      Capybara.string(page.body).has_selector?('title', text: text)
    end
  end

  def logger
    SknApp.logger
  end

end
