require 'test_helper'

class WordCountTest <  ActionDispatch::IntegrationTest

  def setup
    use_chrome!
    login_admin 
  end

  test "should count the words in the justification field" do
    click_link "New Labor Request"
    words = " word " * 100
    fill_in 'Justification', with: words
    assert page.has_content?("25 words remaining")
    fill_in 'Justification', with: words + words
    assert page.has_content?("Limit exceeded (75 words over )")
  end

end
