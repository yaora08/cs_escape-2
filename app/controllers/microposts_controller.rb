class MicropostsController < ApplicationController
    before_action :logged_in_user
    before_action :correct_user, only: [:destroy]

    def new
      @micropost = Micropost.new
    end

    def show
      @micropost = Micropost.find(params[:id])
    end

    def create
        @micropost = current_user.microposts.build(micropost_params)
        if @micropost.save
          flash[:success] = "投稿されました！"
          redirect_to micropost_path(@micropost)
        else
          @feed_items = current_user.feed.paginate(page: params[:page])
          render 'microposts/new'
        end
      end
  
    def destroy
      @micropost = Micropost.find(params[:id])
      if current_user.admin? || current_user?(@micropost.user)
        @micropost.destroy
        flash[:success] = "投稿が削除されました"
        redirect_to user_url(@micropost.user)
      else
        flash[:danger] = "他人の投稿は削除できません"
        redirect_to root_url
      end
    end

    private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
      # 現在のユーザーが更新対象の料理を保有しているかどうか確認
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

end
