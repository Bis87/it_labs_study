module CreateRandomAccount

  def create_random_account
    @driver.find_element(:xpath, '//a[@class="register"]').click
    @wait.until{@driver.find_element(:xpath, '//input[@id="user_login"]').displayed?}
    @login = ('login' + rand(999999).to_s)
    @firstname = ('lizard_name' + rand(999999).to_s)
    @lastname = ('lizard_lastname' + rand(999999).to_s)
    @driver.find_element(:xpath, '//input[@id="user_login"]').send_keys @login
    @driver.find_element(:xpath, '//input[@id="user_password"]').send_keys '1234'
    @driver.find_element(:xpath, '//input[@id="user_password_confirmation"]').send_keys '1234'
    @driver.find_element(:xpath, '//input[@id="user_firstname"]').send_keys @firstname
    @driver.find_element(:xpath, '//input[@id="user_lastname"]').send_keys @lastname
    @driver.find_element(:xpath, '//input[@id="user_mail"]').send_keys (@login + '@sagfdas.com')
    @driver.find_element(:name, 'commit').click
  end

  def create_participant
    @driver.find_element(:xpath, '//a[@class="register"]').click
    @wait.until{@driver.find_element(:xpath, '//input[@id="user_login"]').displayed?}
    @participant_login = ('participant_login' + rand(999999).to_s)
    @lizard_firstname = ('lizard_participant' + rand(999999).to_s)
    @lizard_lastname = ('lizard_participant' + rand(999999).to_s)
    @driver.find_element(:xpath, '//input[@id="user_login"]').send_keys @participant_login
    @driver.find_element(:xpath, '//input[@id="user_password"]').send_keys '1234'
    @driver.find_element(:xpath, '//input[@id="user_password_confirmation"]').send_keys '1234'
    @driver.find_element(:xpath, '//input[@id="user_firstname"]').send_keys @lizard_firstname
    @driver.find_element(:xpath, '//input[@id="user_lastname"]').send_keys @lizard_lastname
    @driver.find_element(:xpath, '//input[@id="user_mail"]').send_keys (@participant_login + '@sagfdas.com')
    @driver.find_element(:name, 'commit').click
  end
end