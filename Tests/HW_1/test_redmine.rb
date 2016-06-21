require 'test/unit'
require 'selenium-webdriver'

require_relative 'create_random_account'

class TestRedmine < Test::Unit::TestCase
  include CreateRandomAccount


  def setup
    @driver = Selenium::WebDriver.for :firefox
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    @driver.manage.timeouts.implicit_wait = 10
    @driver.navigate.to 'http://demo.redmine.org'
  end

  def teardown
    @driver.quit
  end

  #-------------- Auxiliary methods --------------

  def login
    @driver.find_element(:class, 'login').click
    @driver.find_element(:id, 'username').send_keys(@login)
    @driver.find_element(:id, 'password').send_keys('1234')
    @driver.find_element(:name, 'login').click
  end

  def logout
    @driver.find_element(:class, 'logout').click
  end

  def change_password
    @driver.find_element(:class, 'icon-passwd').click
    @driver.find_element(:name, 'password').send_keys('1234')
    @driver.find_element(:name, 'new_password').send_keys('12345')
    @driver.find_element(:name, 'new_password_confirmation').send_keys('12345')
    @driver.find_element(:name, 'commit').click
  end

  def new_project
    @driver.find_element(:class, 'projects').click
    @driver.find_element(:class, 'icon-add').click
    @driver.find_element(:id, 'project_name').send_keys(@login)
    @driver.find_element(:id, 'project_identifier').send_keys(@login)
    @driver.find_element(:name, 'commit').click
  end

  def new_participant
    @driver.find_element(:id, 'tab-members').click
    @driver.find_element(:css, '#tab-content-members p .icon-add').click
    @driver.find_element(:id, 'principal_search').send_keys(@lizard_firstname +' '+ @lizard_lastname)
    @wait.until{@driver.find_element(:css, '#principals label input[type=checkbox]').displayed?}
    @driver.find_element(:css, '#principals label input[type=checkbox]').click
    @driver.find_element(:css, '.roles-selection input[value="4"]').click
    @driver.find_element(:id, 'member-add-submit').click
  end

  def edit_participant_role
    @wait.until {@driver.find_elements(:class, 'ui-widget-overlay').empty?}
    @driver.find_element(:css, '.odd .icon-edit').click
    @driver.find_element(:css, '[value="5"]').click
    @driver.find_element(:css, '.odd .small').click
  end


  def new_feature
    @driver.find_element(:class, 'new-issue').click
    @dropdown = @driver.find_element(:id, 'issue_tracker_id')
    @select_list = Selenium::WebDriver::Support::Select.new(@dropdown)
    @select_list.select_by(:text, 'Feature')
    @driver.find_element(:id, 'issue_subject').send_keys('Lizards feature')
    @driver.find_element(:name, 'commit').click
  end

  def new_support
    @driver.find_element(:class, 'new-issue').click
    @dropdown = @driver.find_element(:id, 'issue_tracker_id')
    @select_list = Selenium::WebDriver::Support::Select.new(@dropdown)
    @select_list.select_by(:text, 'Support')
    @driver.find_element(:id, 'issue_subject').send_keys('Lizards support')
    @driver.find_element(:name, 'commit').click
  end

  def new_bug
    @driver.find_element(:class, 'new-issue').click
    @dropdown = @driver.find_element(:id, 'issue_tracker_id')
    @select_list = Selenium::WebDriver::Support::Select.new(@dropdown)
    @select_list.select_by(:text, 'Bug')
    @driver.find_element(:id, 'issue_subject').send_keys('Lizards bug')
    @driver.find_element(:name, 'commit').click
  end

  # --------------- Test methods ---------------

  def test_registration
    create_random_account
    expected_text_en = 'Your account has been activated. You can now log in.'
    expected_text_ru = 'Ваша учётная запись активирована. Вы можете войти.'
    actual_text = @driver.find_element(:id, 'flash_notice').text
    assert(actual_text.include?(expected_text_en) || actual_text.include?(expected_text_ru))
  end

  def test_login_logout
    create_random_account
    logout
    login
    logout_button = @driver.find_element(:class, 'logout')
    assert(logout_button.displayed?)
    name_after_login = @driver.find_element(:link, @login)
    assert(name_after_login.displayed?)
  end

  def test_change_pwd
    create_random_account
    change_password

    puts @login
    expected_text_en = 'Password was successfully updated.'
    expected_text_ru = 'Пароль успешно обновлён.'
    actual_text = @driver.find_element(:id, 'flash_notice').text
    assert(actual_text.include?(expected_text_en) || actual_text.include?(expected_text_ru))
  end

  def test_create_project
    create_random_account
    new_project
    expected_text_en = 'Successful creation.'
    expected_text_ru = 'Создание успешно.'
    actual_text = @driver.find_element(:id, 'flash_notice').text
    assert(actual_text.include?(expected_text_en) || actual_text.include?(expected_text_ru))
  end

  def test_add_participant
    create_random_account
    logout
    create_participant
    logout
    login
    new_project
    new_participant
    puts @login
    added_username1 = @driver.find_element(:link, @lizard_firstname+' '+ @lizard_lastname)
    assert(added_username1.displayed?)

  end

  def test_edit_participant_role
    create_random_account
    logout
    create_participant
    logout
    login
    new_project
    new_participant
    edit_participant_role
    role1 = @driver.find_element(:xpath,  '//span[.="Manager, Reporter"]')
    assert(role1.displayed?)
    puts @login
  end

  def test_create_project_version
    create_random_account
    new_project
    @driver.find_element(:id, 'tab-versions').click
    @driver.find_element(:css, '#tab-content-versions .icon-add').click
    @driver.find_element(:id, 'version_name').send_keys(@firstname)
    @driver.find_element(:name, 'commit').click
    expected_text_en = 'Successful creation.'
    expected_text_ru = 'Создание успешно.'
    actual_text = @driver.find_element(:id, 'flash_notice').text
    assert(actual_text.include?(expected_text_en) || actual_text.include?(expected_text_ru))
  end

  def test_create_issues
    create_random_account
    new_project
    new_feature
    new_support
    new_bug
    @driver.find_element(:class,'issues').click
    assert(@driver.find_element(:link, 'Lizards feature').displayed?)
    assert(@driver.find_element(:link, 'Lizards bug').displayed?)
    assert(@driver.find_element(:link, 'Lizards support').displayed?)
  end


end
