require 'spec_helper'

feature "User pages" do
  
  subject { page }

  context "Signup Page" do

  	before { visit signup_path }

	  scenario "should have content" do
	  	page.should have_content('Sign up')
	  end

	  scenario "should have title" do
	  	page.should have_title(full_title('Sign up'))
	  end

	  context "should support user registration"  do
	  	let(:submit) { "Create My Account" }

	  	scenario "with invalid information" do 
	  		expect { click_button submit }.not_to change(User, :count)
	  	end

	  	context "after invalid submission" do
	  		before { click_button submit }
	  		scenario { page.should have_title(full_title('Sign up'))}
	  		scenario { page.should have_content('errors') }
	  		scenario { page.should have_content("Name can't be blank") }
	  		scenario { page.should have_content("Email can't be blank") }
	  	end
	  		
			scenario "with valid information" do 
	  		fill_in "Name", with: "Example User"
	  		fill_in "Email", with: "user@example.com"
	  		fill_in "Password", with: "password"
	  		fill_in "Password Confirmation", with: "password"
	  		expect { click_button submit }.to change(User, :count).by(1)
	  	end

	  	context "after valid submission" do
	  		before do 
	  			fill_in "Name", with: "Example User"
	  			fill_in "Email", with: "user@example.com"
	  			fill_in "Password", with: "password"
	  			fill_in "Password Confirmation", with: "password"
	  			click_button submit 
  			end
	  		let(:user) { User.find_by(email: 'user@example.com') }
	  		scenario { page.should have_title(user.name) }
	  		scenario { page.should have_selector('.alert-success', text: 'Welcome') }
	  	end

		end
	end

	context "Profile Page" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }
		scenario { page.should have_content(user.name) }
		scenario { page.should have_title(user.name) }
	end
end
