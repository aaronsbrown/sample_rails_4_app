require 'spec_helper'

feature "User pages" do
  
  subject { page }

  context "Signup Page" do

  	before { visit signup_path}

	  scenario "should have content" do
	  	should have_content('Sign up')
	  end

	  scenario "should have title" do
	  	should have_title(full_title('Sign up'))
	  end
	end
end
