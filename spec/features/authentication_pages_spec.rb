require 'spec_helper'

feature 'Authentication Pages' do

	context "signin" do
		
		before { visit signin_path }
		scenario { page.should have_content('Sign In')}
		scenario { page.should have_title(full_title('Sign In'))}
	
		context "with invalid information" do
			before { click_button "Sign In" }
			scenario { page.should have_title(full_title('Sign In'))}
			scenario { page.should have_error_message('Invalid') }

			context "after visiting another page" do
				before { click_link "Home" }
				scenario { page.should_not have_selector('.alert-danger') }
				# TODOAB: couldn't get this to work
				# scenario { page.should_not have_error_message('Invalid') }
			end
		end
		
		context "with valid information" do 

			let(:user) { FactoryGirl.create(:user) }
			before do
				valid_signin(user)
			end

			scenario { page.should have_title(full_title(user.name)) }
			scenario { page.should have_link('Profile', href: user_path(user)) }
			scenario { page.should have_link('Settings') }
			scenario { page.should have_link('Sign Out', href: signout_path) }
			scenario { page.should_not have_link('Sign In', href: signin_path) }

			describe "followed by signout" do
				before { click_link 'Sign Out' }
				scenario { page.should have_link('Sign In') }
			end

		end

	end


end
