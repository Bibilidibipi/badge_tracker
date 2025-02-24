class BadgesController < ApplicationController
    def index
        @badges = Badge.all
    end

    def show
        @badge = Badge.find(params[:id])
        @badge_user = BadgeUser.find_by(badge: @badge, user: current_user)
    end

    def new
        @badge = Badge.new
        authorize! :create, @badge
    end

    def create
        @badge = Badge.new(badge_params)
        authorize! :create, @badge

        if @badge.save
            redirect_to url_for(@badge)
        else
            flash.now[:errors] = @badge.errors.full_messages
            render :new
        end
    end

    def edit
        @badge = Badge.find(params[:id])
        authorize! :update, @badge
    end

    def update
        @badge = Badge.find(params[:id])
        authorize! :update, @badge

        if @badge.update(badge_params)
            redirect_to url_for(@badge)
        else
            flash.now[:errors] = @badge.errors.full_messages
            render :edit
        end
    end

    def destroy
        @badge  = Badge.find(params[:id])
        authorize! :destroy, @badge

        if @badge.destroy
            redirect_to badges_url
        else
            flash.now[:errors] = @badge.errors.full_messages
            @badge_user = BadgeUser.find_by(badge: @badge, user: current_user)
            render :show
        end
    end

    private

    def badge_params
        params.require(:badge).permit(:name, :description, :image)
    end
end
