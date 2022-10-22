class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def all_posts
    if logged_in?
      @feed_items = Micropost.all.paginate(page: params[:page])
      render 'home'
    end
  end

  def help
  end 

  def about
  end
end
