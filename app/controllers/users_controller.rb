class UsersController < ApplicationController

  def my_portfolio
    @tracked_stocks = current_user.stocks
  end

  def my_friends
    @user_friends = current_user.friends
  end

  def search
    if params[:friend].present?
      @friends = User.search(params[:friend])
      @friends = current_user.except_current_user(@friends)
        if @friends
          respond_to do |format|
            format.js { render partial: 'users/friend_result' }
          end
        else
          respond_to do |format|
            flash.now[:alert] = "No such a user"
            format.js { render partial: 'users/friend_result' }
          end
        end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter an email first"
        format.js { render partial: 'users/friend_result' }
      end
    end
  end

end
