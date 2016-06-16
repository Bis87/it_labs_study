require 'test/unit'
require 'selenium-webdriver'

require_relative 'create_random_account'

class TestRegistration < Test::Unit::TestCase
  include CreateRandomAccount


  def setup
    @driver = Selenium::WebDriver.for :firefox
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    @driver.navigate.to 'http://demo.redmine.org'
  end

  def teardown
    @driver.quit
  end

  def login
    @wait.until{@driver.find_element(:xpath, '//a[@class="login"]').displayed?}
    @driver.find_element(:class, 'login').click
    @driver.find_element(:id, 'username').send_keys(@login)
    @driver.find_element(:id, 'password').send_keys('1234')
    @driver.find_element(:xpath, '//input[@type="submit"]').click
  end



  #-------------- Auxiliary methods --------------
  def logout
    @driver.find_element(:class, 'logout').click
    @wait.until{@driver.find_element(:xpath, '//a[@class="register"]').displayed?}
  end

  def change_password
    @driver.find_element(:xpath, '//a[@class="icon icon-passwd"]').click
    @driver.find_element(:name, 'password').send_keys('1234')
    @driver.find_element(:name, 'new_password').send_keys('12345')
    @driver.find_element(:name, 'new_password_confirmation').send_keys('12345')
    @driver.find_element(:name, 'commit').click
  end

  def new_project
    @driver.find_element(:class, 'projects').click
    @driver.find_element(:xpath, '//a[@class="icon icon-add"]').click
    @driver.find_element(:id, 'project_name').send_keys(@login)
    @driver.find_element(:id, 'project_identifier').send_keys(@login)
    @driver.find_element(:name, 'commit').click
  end

  def new_participant
    @driver.find_element(:id, 'tab-members').click
    @driver.find_element(:xpath, '//a[.="Новый участник"]').click
    @wait.until{@driver.find_element(:xpath, '//input[@id="principal_search"]').displayed?}
    @driver.find_element(:xpath, '//input[@id="principal_search"]').send_keys(@lizard_firstname + ' ' + @lizard_lastname)
    @wait.until{@driver.find_element(:xpath, '//label[contains(.,"'+@lizard_firstname +' '+ @lizard_lastname+'")]/input[@type="checkbox"]').displayed?}
    @driver.find_element(:xpath, '//label[contains(.,"'+@lizard_firstname +' '+ @lizard_lastname+'")]/input[@type="checkbox"]').click
    @wait.until{@driver.find_element(:xpath, '(//label[contains(.,"Developer")]/input[@type="checkbox"])[2]').displayed?}
    @driver.find_element(:xpath, '(//label[contains(.,"Developer")]/input[@type="checkbox"])[2]').click
    @wait.until{@driver.find_element(:id, 'member-add-submit').displayed?}
    @driver.find_element(:id, 'member-add-submit').click
  end

  def new_feature
    @driver.find_element(:xpath, '//a[@class="new-issue"]').click
    @dropdown = @driver.find_element(:id, 'issue_tracker_id')
    @select_list = Selenium::WebDriver::Support::Select.new(@dropdown)
    @select_list.select_by(:text, 'Feature')
    @driver.find_element(:id, 'issue_subject').send_keys('Lizards issue' + rand(100).to_s)
    @driver.find_element(:name, 'commit').click
  end

  def new_support
    @driver.find_element(:xpath, '//a[@class="new-issue"]').click
    @dropdown = @driver.find_element(:id, 'issue_tracker_id')
    @select_list = Selenium::WebDriver::Support::Select.new(@dropdown)
    @select_list.select_by(:text, 'Support')
    @driver.find_element(:id, 'issue_subject').send_keys('Lizards issue' + rand(100).to_s)
    @driver.find_element(:name, 'commit').click
  end

  def new_bug
    @driver.find_element(:xpath, '//a[@class="new-issue"]').click
    @dropdown = @driver.find_element(:id, 'issue_tracker_id')
    @select_list = Selenium::WebDriver::Support::Select.new(@dropdown)
    @select_list.select_by(:text, 'Bug')
    @driver.find_element(:id, 'issue_subject').send_keys('Lizards issue' + rand(100).to_s)
    @driver.find_element(:name, 'commit').click
  end

  # --------------- Test methods ---------------

  def test_registration
    create_random_account
    expected_text = 'Ваша учётная запись активирована. Вы можете войти.'
    actual_text = @driver.find_element(:id, 'flash_notice').text
    assert_equal(expected_text, actual_text)
  end

  def test_login_logout
    create_random_account
    logout
    login
    name_after_login = @driver.find_element(:xpath, '//a[.="'+ @login + '"]')
    assert(name_after_login.displayed?)
    puts @login
  end

  def test_change_pwd
    create_random_account
    change_password
    expected_text = 'Пароль успешно обновлён.'
    actual_text = @driver.find_element(:id, 'flash_notice').text
    assert_equal(expected_text, actual_text)
  end

  def test_create_project
    create_random_account
    new_project
    confirmation_message = @driver.find_element(:xpath, '//div[.="Создание успешно."]')
    assert(confirmation_message.displayed?)
  end

  def test_add_participant
    create_random_account
    logout
    create_participant
    logout
    login
    new_project
    new_participant
    added_username = @driver.find_element(:xpath, '//label[contains(.,"'+@lizard_firstname +' '+ @lizard_lastname+'")]/input[@type="checkbox"]')
    @wait.until{@driver.find_element(:xpath, '//label[contains(.,"'+@lizard_firstname +' '+ @lizard_lastname+'")]/input[@type="checkbox"]').displayed?}
    assert(added_username.displayed?)
  end

  def test_edit_participant_role
    create_random_account
    logout
    create_participant
    logout
    login
    new_project
    new_participant
    @wait.until{@driver.find_element(:xpath, '//a[contains(.,"'+ @firstname+ ' ' + @lastname + '")]/ancestor::tr//a[contains(.,"Редактировать")]').displayed?}
     sleep 1
    @driver.find_element(:xpath, '//a[contains(.,"'+ @firstname+ ' ' + @lastname + '")]/ancestor::tr//a[contains(.,"Редактировать")]').click
    @driver.find_element(:xpath, '//a[contains(.,"'+ @firstname+ ' ' + @lastname + '")]/ancestor::tr//label[contains(.,"Reporter")]/input[@type="checkbox"]').click
    @driver.find_element(:xpath, '//a[contains(.,"'+ @firstname+ ' ' + @lastname + '")]/ancestor::tr//input[@class="small"]').click
     sleep 1
    role = @driver.find_element(:xpath, '//a[contains(.,"'+ @firstname+ ' ' + @lastname + '")]/ancestor::tr//span[contains(.,"Reporter")]')
    assert(role.displayed?)
  end

  def test_create_project_version
    create_random_account
    new_project
    @driver.find_element(:id, 'tab-versions').click
    @driver.find_element(:xpath, '//a[contains(@href,"versions/new?back_url=")]').click
    @driver.find_element(:id, 'version_name').send_keys(@firstname)
    @driver.find_element(:xpath, '//input[@type="submit"]').click
    message = @driver.find_element(:xpath, '//div[@id="flash_notice"][contains(.,"Создание успешно.")]')
    assert(message.displayed?)
  end

  def test_create_issues
    create_random_account
    new_project
    new_feature
    new_support
    new_bug
    @driver.find_element(:xpath, '//a[@class="issues selected"]').click
    support_issue = @driver.find_element(:xpath, '//td[.="Support"]')
    assert(support_issue.displayed?)
    feature_issue = @driver.find_element(:xpath, '//td[.="Feature"]')
    assert(feature_issue.displayed?)
    bug_issue = @driver.find_element(:xpath, '//td[.="Bug"]')
    assert(bug_issue.displayed?)
  end


end
