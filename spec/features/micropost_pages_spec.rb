require 'spec_helper'

feature "Micropost" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	before { signin user }

	context "micropost creation" do
		
		before { visit root_path }
		context "with invalid information" do

			scenario "should not create a micropost" do
				expect { click_button "Post" }.not_to change(Micropost, :count)
			end

			context "error messages" do
				before { click_button "Post" }
				scenario { page.should have_content('error') }
			end

		end
		
		context "with valid information" do
			before { fill_in 'micropost_content', with: 'Lorem Ipsum' }
			scenario "should create a micropost" do
				expect { click_button "Post" }.to change(Micropost, :count).by(1)
			end
		end

		context "micropost destruction" do
			before { FactoryGirl.create(:micropost, user: user) }
			context "as a correct user" do
				before { visit root_path }
				scenario "should delete a micropost" do
					expect{ click_link "delete" }.to change(Micropost, :count).by(-1)
				end
			end
		end

	end
end
