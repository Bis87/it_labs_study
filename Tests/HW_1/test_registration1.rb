require 'test/unit'
require 'watir-webdriver'

class TestBonusTasks < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @browser = Watir::Browser::new :firefox
    @browser.goto 'https://the-internet.herokuapp.com/'
  end

  def teardown
    @browser.quit
  end

  def test_hover
    @browser.link(text: 'Hovers').when_present.click
    # @browser.img(xpath: '(//img[@alt="User Avatar"])[1]').when_present.hover
    # @browser.divs(class:  'figure').first.when_present.hover
    @browser.images(src:  '/img/avatar-blank.jpg').first.when_present.hover
    # assert @browser.header(xpath:'//h5[.="name: user1"]')____________________________непонятно почему не работает?
    assert(@browser.div(class:'figcaption').text.include? 'name: user1')
    assert(@browser.div(xpath:'//div[@class="figcaption"]').text.include? 'name: user1')

  end

  def test_drag_and_drop
    @browser.link(xpath: '//a[.="Drag and Drop"]').when_present.click
    a = @browser.div(id: 'column-a')
    b = @browser.div(id: 'column-b')
    a.drag_and_drop_on b
    assert @browser.header(xpath: '//div[@id="column-b"]/header[.="A"]')
    assert(@browser.div(id:'column-b').text.include? 'A')
  end

  def test_dropdown
    @browser.link(text: 'Dropdown').when_present.click
    @browser.select_list(id: 'dropdown').select_value('1')
    assert @browser.select_list(id: 'dropdown').selected?('Option 1')
    # assert browser.select_list(:name, ‘sel1′).includes?(‘Option 1′)
    # assert browser.select_list(:name, ‘sel1′).selected?(/option/i)
  end


end