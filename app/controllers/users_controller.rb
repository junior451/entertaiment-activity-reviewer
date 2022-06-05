class UsersController < ApplicationController
  def signup
    @user = User.new(user_params)

    if @user.save
      render json: { message: "Successfully created account" }, status: :created
    else
      render json: { error: "Account not created" }
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
