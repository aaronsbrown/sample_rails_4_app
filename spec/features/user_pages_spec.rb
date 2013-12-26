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
	  	#	scenario { page.should have_link('Sign Out')}
	  	end

		end
	end

	context "Index Page" do
		before do
			signin FactoryGirl.create(:user)
			FactoryGirl.create(:user, name: "Bob", email: "bob@ex.com")
			FactoryGirl.create(:user, name: "Ben", email: "ben@ex.com")
			visit users_path
		end
		scenario { page.should have_title('All users') }
		scenario { page.should have_content('All users') }
		scenario "should list each user" do
			User.all.each do |user|
				expect(page).to have_selector('li', text: user.name)
			end
		end
	end

	context "Profile Page" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }
		scenario { page.should have_content(user.name) }
		scenario { page.should have_title(user.name) }
	end

	context "Edit Page" do 
		let(:user) { FactoryGirl.create(:user) }
		before do 
			signin user
			visit edit_user_path(user) 
		end
		scenario { page.should have_content('Update your profile') }
		scenario { page.should have_title("Edit User") }
		scenario { page.should have_link("change", href: 'http://gravatar.com/emails') }
	end

	context "Edit with Invalid Information" do
		let(:user) { FactoryGirl.create(:user) }
		before do 
			signin user
			visit edit_user_path(user) 
			click_button "Save Changes"
		end
		scenario { page.should have_content('error') }
	end
		
	context "Edit with valid Information" do
		let(:user) { FactoryGirl.create(:user) }
		let(:new_name) { "New Name" }
		let(:new_email) { "new@example.com" }
		before do 
			signin user
			visit edit_user_path(user) 
			fill_in "Name", with: new_name
			fill_in "Email", with: new_email
			fill_in "Password", with: "password"
			fill_in "Password Confirmation", with: "password"
			click_button "Save Changes"
		end
		scenario { should have_title(new_name) }
		scenario { should have_selector('.alert-success') }
		scenario { should have_link('Sign Out', href: signout_path) }
		scenario { expect(user.reload.name).to eq new_name }
		scenario { expect(user.reload.email).to eq new_email }
	end
end
