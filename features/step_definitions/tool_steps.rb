When(/^I attach a logo file$/) do
  attach_file 'Logo', fixture_image_path
end

Then(/^the logo thumbnail is displayed$/) do
  page.should have_xpath("//img[contains(@src, 'bulldog_logo.jpg')]")
  # src="/system/settings/logos/000/000/012/thumb/bulldog_logo.jpg?1407170684"
end

def fixture_image_path
  Rails.root.join('spec', 'support', 'bulldog_logo.jpg')
end