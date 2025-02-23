class BadgeUsersController < ApplicationController
    def create
        @badge_user = BadgeUser.new(badge_user_params)
        authorize! :create, @badge_user

        @badge = Badge.find(params[:badge_user][:badge_id])

        if !@badge_user.save
            flash[:errors] = @badge_user.errors.full_messages
        end

        redirect_to url_for(@badge)
    end

    private
    
    def badge_user_params
        params.require(:badge_user).permit(:badge_id, :user_id, :eligible, :earned)
    end
end
