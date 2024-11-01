class BadgesController < ApplicationController
    def index
        @badges = Badge.all
    end

    def show
        @badge = Badge.find(params[:id])
        @badge_user = BadgeUser.find_by(badge: @badge, user: current_user)
    end
end
