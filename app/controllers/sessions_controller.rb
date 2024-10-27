class SessionsController < ApplicationController
    before_action :ensure_logged_out, only: :new

    def new
        @user = User.new
    end

    def create
        @user = User.find_by(name: params[:user][:name])
            &.authenticate(params[:user][:password])

        if @user
            log_in(@user)
            redirect_to root_url
        else
            @user = User.new(name: params[:user][:name])
            flash.now[:errors] = [ "Invalid name or password" ]
            render :new
        end
    end

    def destroy
        log_out
        redirect_to new_session_url
    end

    private

    def ensure_logged_out
        unless !current_user
            flash[:messages] = [ "Log out before logging in" ]
            redirect_to root_url
        end
    end
end
