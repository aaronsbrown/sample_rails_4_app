require 'spec_helper'

feature "StaticPages" do

  subject { page }

  given(:base_title) { "Ruby on Rails Tutorial Sample App" }

  context "Home Page" do
    before { visit root_path }

    scenario "should have the content 'Sample App'" do
      should have_content('Sample App')
    end

    scenario "should have base title" do
      should have_title("#{base_title}")
    end

    scenario "should not have a custom page title" do
      should_not have_title("| Home")
    end

  end

  context "Help Page" do

    scenario "Help Page should have the content 'Help'" do
      visit help_path
      should have_content('Help')
    end

    scenario "should have the right title" do
      visit help_path
      should have_title("#{base_title} | Help")
    end

  end

  context "About Page" do

    scenario "About page should have the content 'About Us'" do
      visit about_path
      should have_content('About Us')
    end

    scenario "should have the right title" do
      visit about_path
      should have_title("#{base_title} | About")
    end

  end

  context "Contact Page" do

    scenario "Contact page should have the content 'Contact Ruby on Rails'" do
      visit contact_path
      should have_content('Contact Ruby on Rails')
    end

    scenario "should have the right title" do
      visit contact_path
      should have_title("#{base_title} | Contact")
    end

  end

end
