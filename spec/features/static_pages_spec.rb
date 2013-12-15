require 'spec_helper'

feature "Static pages" do

  subject { page }

  given(:base_title) { "Ruby on Rails Tutorial Sample App" }

  shared_examples_for "all static pages" do
    scenario { should have_selector('h1', text: heading) }
    scenario { should have_title(full_title(page_title)) }
  end

  scenario "have valid links" do
    visit root_path
    click_link "About"
    should have_title(full_title('About'))
    click_link 'Help'
    should have_title(full_title('Help'))
    click_link 'Contact'
    should have_title(full_title('Contact'))
    click_link 'Home'
    should have_title(base_title)
    click_link 'Sign up now!'
    should have_title(full_title('Sign up'))
    click_link 'Sample App'
    should have_title(base_title)
  end

  context "Home Page" do
    before { visit root_path }

    let(:heading) { 'Sample App'}
    let(:page_title) { '' }
    
    it_should_behave_like "all static pages"
    scenario { should_not have_title("| Home") }
  end

  context "Help Page" do

    before { visit help_path }

    let(:heading) { 'Help'}
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  context "About Page" do

    before { visit about_path }

    let(:heading) { 'About Us'}
    let(:page_title) { 'About' } 
 
    it_should_behave_like "all static pages"
  end

  context "Contact Page" do

    before { visit contact_path }
    let(:heading) { 'Contact'}
    let(:page_title) { 'Contact'}
 
    it_should_behave_like "all static pages"
  end

end
