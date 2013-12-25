include ApplicationHelper

def valid_signin(user)
	fill_in "Email", with: user.email
	fill_in "Password", with: user.password
	click_button "Sign In"
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


