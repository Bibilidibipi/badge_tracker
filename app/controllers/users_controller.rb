class UsersController < ApplicationController
    skip_before_action :require_logged_in!, only: [ :new, :create ]

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)

        if @user.save
            log_in(@user)
            redirect_to root_url
        else
            flash.now[:errors] = @user.errors.full_messages
            render :new
        end
    end

    def show
        @user = current_user
    end

    private

    def user_params
        params.require(:user).permit(:name, :password)
    end
end
