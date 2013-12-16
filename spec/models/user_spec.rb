require 'spec_helper'

describe User do

	before { @user = User.new(name: "Aaron Brown", email: "aaron@stitchfix.com",
														password: "foobar", password_confirmation: "foobar")}
	subject {@user}

	it { should respond_to :name }
	it { should respond_to :email }
	it { should respond_to :password_digest }
	it { should respond_to :password }
	it { should respond_to :password_confirmation }
	it { should respond_to :authenticate }

	describe "when name is not present" do
		before { @user.name = "" }
		it { should_not be_valid }
	end

	describe "when email is not present" do
		before { @user.email = "" }
		it { should_not be_valid }
	end

	describe "when name is too long" do
		before { @user.name = "A"*51 }
		it { should_not be_valid }
	end

	describe "when email format is invalid" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com foo@efi..jim]
      
      addresses.each do |invalid_address|
       	@user.email = invalid_address
       	expect(@user).to_not be_valid
      end
    end
  end

  describe "when email format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.COM A_US-ER@fb.org frst.lst@foo.jp a+b@baz.cn jim@it.foo.io]
      
      addresses.each do |valid_address|
       	@user.email = valid_address
       	expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
  	before do	
  		user_with_same_email = @user.dup
  		user_with_same_email.email.upcase!
  		user_with_same_email.save
  	end

  	it { should_not be_valid }
  end

  describe "when email has uppercase characters" do
  	let(:email) { "UPPERCASE@mail.cOm" }
  	it "should be lowercase after save" do
  		@user.email = email
  		@user.save
  		expect(@user.reload.email).to eq email.downcase
  	end
  end

  describe "when password not present" do
  	before do 
  		@user.password = " "
			@user.password_confirmation = " " 
		end
  	it { should_not be_valid }
  end

  describe "when password confirmation doesn't match" do
  	before { @user.password = "f__bar" }
  	it { should_not be_valid }
  end

  context "return value of authenticate method" do

  	before { @user.save }
  	let(:found_user) { User.find_by(email: @user.email) }

  	describe "with valid password" do
  		it { should eq found_user.authenticate(@user.password) }
  	end

  	describe "with invalid password" do
  		it { should_not eq found_user.authenticate("invalid") }
  		specify { expect(found_user.authenticate("invalid")).to be_false } #synonym for "it"
  	end

  end

  describe "with a password that is too short" do
  	before { @user.password = @user.password_confirmation = "a" * 5 }
  	it { should be_invalid }
  end

end
