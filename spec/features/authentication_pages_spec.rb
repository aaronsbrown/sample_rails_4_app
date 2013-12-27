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
				signin(user)
			end

			scenario { page.should have_title(full_title(user.name)) }
			scenario { page.should have_link('Users', href: users_path) }
			scenario { page.should have_link('Profile', href: user_path(user)) }
			scenario { page.should have_link('Settings', href: edit_user_path(user)) }
			scenario { page.should have_link('Sign Out', href: signout_path) }
			scenario { page.should_not have_link('Sign In', href: signin_path) }

			describe "followed by signout" do
				before { click_link 'Sign Out' }
				scenario { page.should have_link('Sign In') }
			end
		end
	end

	# specify request type because we aren't in the spec/requests folder
	context "authorization", type: :request do
		
		context "for non-signed-in users" do
			let(:user) { FactoryGirl.create(:user) }			
			
			context "in the Users controller" do 
				context "visiting the user index" do
					before { visit users_path }
					scenario { page.should have_title("Sign In") }
				end
				context "visiting the edit page" do
					before { visit edit_user_path(user) }
					scenario { page.should have_title('Sign In') }
				end
				context "submitting to the update action" do
					before { patch user_path(user) }
					specify { expect(response).to redirect_to(signin_path) }
				end
			end
			
			context "when attempting to visit a protected page" do
				before do
					visit edit_user_path(user)
					signin user
				end
				context "after signing in" do
					scenario { expect(page).to have_title('Edit User') }
				end
			end
		end	

		context "as wrong user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@ex.com") }
			before { signin user, no_capybara: true }

			describe "submitting a GET reqeust to the Users#edit action" do
				before { get edit_user_path(wrong_user) } 
				specify { expect(response.body).not_to match(full_title('Edit User'))}
				specify { expect(response).to redirect_to(root_path)}
			end

			describe "submitting a PATCH reqeust to the Users#update action" do
				before { patch user_path(wrong_user) } 
				specify { expect(response).to redirect_to(root_path) }
			end
		end

		context "as non-admin user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:non_admin) { FactoryGirl.create(:user) }
			before { signin non_admin, no_capybara: true }
			context "submitting a DELETE requests to the #destroy action" do
				before { delete user_path(user) }
				specify { expect(response).to redirect_to(root_path)}
			end
		end
	end


end
