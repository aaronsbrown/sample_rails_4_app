require 'spec_helper'

feature 'Authentication Pages' do

	context "signin" do
		
		before { visit signin_path }
		scenario { page.should have_content('Sign In')}
		scenario { page.should have_title(full_title('Sign In'))}
	
		context "with invalid information" do
			before { click_button "Sign In" }
			scenario { page.should have_title(full_title('Sign In'))}
			scenario { page.should have_selector('.alert-danger', text: 'Invalid') }

			context "after visiting another page" do
				before { click_link "Home" }
				scenario { page.should_not have_selector('.alert-danger') }
			end
		end
		
		context "with valid information" do 

		let(:user) { FactoryGirl.create(:user) }
		before do
			fill_in "Email", with: user.email.upcase
			fill_in "Password", with: user.password
		  click_button "Sign In" 
		end

		scenario { page.should have_title(full_title(user.name)) }
		scenario { page.should have_link('Profile', href: user_path(user)) }
		scenario { page.should have_link('Settings') }
		scenario { page.should have_link('Sign Out', href: signout_path) }
		scenario { page.should_not have_link('Sign In', href: signin_path) }

		end

	end


end
