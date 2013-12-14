require 'spec_helper'

feature "StaticPages" do
  
  given(:base_title) { "Ruby on Rails Tutorial Sample App | " }

  context "Home Page" do

    scenario "should have the content 'Sample App'" do
      visit '/static_pages/home'
      expect(page).to have_content('Sample App')
    end

    scenario "should have the right title" do
      visit '/static_pages/home'
      expect(page).to have_title("#{base_title}Home")
    end

  end

  context "Help Page" do

    scenario "Help Page should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end

    scenario "should have the right title" do
      visit '/static_pages/help'
      expect(page).to have_title("#{base_title}Help")
    end

  end

  context "About Page" do

    scenario "About page should have the content 'About Us'" do
      visit '/static_pages/about'
      expect(page).to have_content('About Us')
    end

    scenario "should have the right title" do
      visit '/static_pages/about'
      expect(page).to have_title("#{base_title}About")
    end

  end

  context "Contact Page" do

    scenario "Contact page should have the content 'Contact Ruby on Rails'" do
      visit '/static_pages/contact'
      expect(page).to have_content('Contact Ruby on Rails')
    end

    scenario "should have the right title" do
      visit '/static_pages/contact'
      expect(page).to have_title("#{base_title}Contact")
    end

  end

end
