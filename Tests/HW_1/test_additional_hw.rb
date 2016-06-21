require 'test/unit'
require 'watir-webdriver'

class TestBonusTasks < Test::Unit::TestCase

  def setup
    @browser = Watir::Browser::new :firefox
    @browser.driver.manage.timeouts.implicit_wait = 5
    @browser.goto 'https://the-internet.herokuapp.com/'
  end

  def teardown
    @browser.quit
  end

  def test_hover
    @browser.link(text: 'Hovers').click
    # @browser.img(xpath: '(//img[@alt="User Avatar"])[1]').when_present.hover
    # @browser.divs(class:  'figure').first.when_present.hover
    @browser.images(src:  '/img/avatar-blank.jpg').first.hover
    assert(@browser.div(class:'figcaption').text.include? 'name: user1')
    assert(@browser.div(xpath:'//div[@class="figcaption"]').text.include? 'name: user1')

  end

  def test_drag_and_drop
    @browser.link(xpath: '//a[.="Drag and Drop"]').click
    dnd_js = File.read(Dir.pwd + '/dnd.js')
    @browser.execute_script(dnd_js+"$('#column-a').simulateDragDrop({ dropTarget: '#column-b'});")
    assert(@browser.div(id:'column-b').text.include? 'A')
    assert(@browser.div(id:'column-a').text.include? 'B')
  end

  def test_dropdown
    @browser.link(text: 'Dropdown').click
    @browser.select_list(id: 'dropdown').select_value('1')
    assert @browser.select_list(id: 'dropdown').selected?('Option 1')
    # assert browser.select_list(:name, ‘sel1′).includes?(‘Option 1′)
  end

  def test_iframes
    @browser.link(text: 'Frames').click
    @browser.link(text: 'iFrame').click
    @browser.iframe(id: 'mce_0_ifr').send_keys 'hello world'
    assert(@browser.iframe(id: 'mce_0_ifr').p.text.include? 'Your content goes here.hello world')
  end

  def test_key_press
    @browser.link(text: 'Key Presses').click
    @browser.send_keys :alt
    assert(@browser.p(id: 'result').text.include?('You entered: ALT'))
  end

  def test_jquery_menu
    @browser.link(text: 'JQuery UI Menus').click
    @browser.link(text: 'Enabled').hover
    @browser.link(text: 'Back to JQuery UI').click
    assert(@browser.link(text: 'Menu').present?)
  end

  def test_js_alert
    @browser.link(text: 'JavaScript Alerts').click
    @browser.button(text: 'Click for JS Alert').click
    a = @browser.alert.text
    puts a
    @browser.alert.ok
    @browser.button(text: 'Click for JS Prompt').click
    @browser.alert.set 'Yes'
    @browser.alert.ok
    assert(@browser.p(text: 'You entered: Yes').present?)
  end

  def test_new_window
    @browser.link(text: 'Multiple Windows').click
    @browser.link(text: 'Click Here').click
    @browser.window(title:  'New Window').use do
    assert(@browser.h3(text: 'New Window').present?)
    end
  end


end