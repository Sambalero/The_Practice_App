require 'spec_helper'

describe "User pages" do

  subject { page } #referencing the page variable supplied by Capybara...

  describe "profile page" do #what profile page?
    let(:user) { FactoryGirl.create(:user) } #spec/factories.rb creates a user with some magic
    before { visit user_path(user) } #visit (capybara) user_path--"rake 
      # routes" on command line will reveal  "user GET    /users/:id(.:format)      users#show"
      # meaning that "/users/:id" is the "user_path" {how cool is that!}

    it { should have_selector('h1',    text: user.name) } #IT is therefore /users/show/:id
    it { should have_selector('title', text: user.name) }
  end

  describe "edit" do
  let(:user) { FactoryGirl.create(:user) }
  before do
    sign_in user
    visit edit_user_path(user)  #edit_user_path(user) is RubyObscure for
   #GET    /users/:id/edit ??How do we get here through the app??
  end

    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do #this seems to be the same as "with no information"
      before { click_button "Save changes" } #PUT to user => User/update because config/routes/ resources :users

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name } #"This reloads 
        #the user variable from the test database using user.reload, 
        #and then verifies that the user’s new name and email match the new values."
      specify { user.reload.email.should == new_email }
    end
  end


	describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }
      end
    end
  end
end


