include ApplicationHelper

def signin(user, no_capybara = false)
	if no_capybara
		remember_token = User.new_remember_token
		cookies[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.encrypt(remember_token))
	else
		visit signin_path
		fill_in "Email", with: user.email
		fill_in "Password", with: user.password
		click_button "Sign In"
	end
end

RSpec::Matchers.define :have_error_message do |expected|
	el = '.alert-danger'
	match_for_should do |actual|
		expect(actual).to have_selector(el, text:expected)
	end
	match_for_should_not do |actual|
		expect(actual).not_to have_selector(el, text:expected)
	end
end


