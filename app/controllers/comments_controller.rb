class CommentsController < ApplicationController
  before_action :logged_in_user

  def new
    @micropost = Micropost.find(params[:micropost_id])
    @comments = @micropost.comments.includes(:user)
    @comment = @micropost.comments.build(user_id: current_user.id) if current_user
  end

  def create
    @micropost = Micropost.find(params[:micropost_id])
    @comment = @micropost.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:success] = '投稿にコメントしました。'
      redirect_to micropost_path(@micropost)
    else
      @micropost = Micropost.find(params[:micropost_id]) 
      @comments = @micropost.comments.includes(:user)
      flash.now[:danger] = '投稿へのコメントに失敗しました。'
      render 'microposts/show'
    end
  end

  def destroy
    @micropost = Micropost.find(params[:micropost_id])
    @comment = Comment.find_by(id:params[:id], micropost_id: params[:micropost_id])
    if current_user.admin? || current_user?(@comment.user)
      @comment.destroy
      flash[:success] = "投稿が削除されました"
      redirect_to micropost_path(@micropost)
    else
      flash[:danger] = "他人の投稿は削除できません"
      redirect_to root_url
    end
    
  end



  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
