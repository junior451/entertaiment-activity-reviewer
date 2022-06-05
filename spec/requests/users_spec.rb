require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /sign up" do
    context "With the correct user info" do
      let(:user_info) { { user: {username: "junior451", email: "junior541@gmail.com", password: "thepassword123"  } } }

      before { post '/signup', params: user_info }

      it "outputs a successful response" do
        expect(response.body).to eq({message: "Successfully created account"}.to_json)
      end

      it "returns the correct status" do
        expect(response.status).to eq(201)
      end

      it "saves a new user to the database" do
        expect(User.last.username).to eq "junior451"
        expect(User.last.email).to eq "junior541@gmail.com"
      end
    end

    context "With an incorrect user info" do
      let(:user_info) { { user: {username: "junior451", email: "junior541@gmail.no.email", password: ""  } } }

      before { post '/signup', params: user_info }

      it "outputs an error message" do
        expect(response.body).to eq({error: "Account not created"}.to_json)
      end
    end
  end
  
  describe "POST /login" do

  end

  describe "Get /logout" do

  end
end