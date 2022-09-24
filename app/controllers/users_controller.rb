class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "本人確認のため、メールアドレスの認証をお願いします。"
      redirect_to root_url
    else
      render 'new'
    end
  end

  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "プロフィールが更新されました！"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    @user = User.find(params[:id])
    # 管理者ユーザーの場合
    if current_user.admin?
      @user.destroy
      flash[:success] = "ユーザーの削除に成功しました"
      redirect_to users_url
    # 管理者ユーザーではないが、自分のアカウントの場合
    elsif current_user?(@user)
      @user.destroy
      flash[:success] = "自分のアカウントを削除しました"
      redirect_to root_url
    else
      flash[:danger] = "他人のアカウントは削除できません"
      redirect_to root_url
    end
  end

  def following
    @title = "フォロー中"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    @following = "#{@user.following.count}人をフォロー中"
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    @followers = "#{@user.followers.count}人のフォロワー"
    render 'show_follow'
  end


    private

    def user_params
      params.require(:user).permit(:name, :email, :introduction,
                                   :password,
                                   :password_confirmation)
    end

    # プロフィール編集時に許可する属性
    def user_params_update
      params.require(:user).permit(:name, :email, :introduction)
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      if !current_user?(@user)
        flash[:danger] = "このページへはアクセスできません"
        redirect_to(root_url)
      end
    end
end