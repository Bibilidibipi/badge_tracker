class BadgeUsersController < ApplicationController
    def create
        @badge_user = BadgeUser.new
        authorize! :create, @badge_user

        if !@badge_user.update(badge_user_params)
            flash[:errors] = @badge_user.errors.full_messages
        end

        redirect_to url_for(@badge_user.badge)
    end

    def update
        @badge_user = BadgeUser.find(params[:id])
        authorize! :update, @badge_user

        if !@badge_user.update(badge_user_params)
            flash[:errors] = @badge_user.errors.full_messages
        end

        redirect_to url_for(@badge_user.badge)
    end

    private
    
    def badge_user_params
        params.require(:badge_user).permit(:badge_id, :user_id, :eligible, :earned)
    end
end
