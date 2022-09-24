class AccountActivationsController < ApplicationController

    #GET /account_activations/:id/edit
    def edit
        user = User.find_by(email: params[:email])
        if user && !user.activated? && user.authenticated?(:activation, params[:id])
          user.update_attribute(:activated,    true)
          user.update_attribute(:activated_at, Time.zone.now)
          log_in user
          flash[:success] = "アカウントが認証されました。"
          redirect_to user
        else
          flash[:danger] = "無効なURLです。"
          redirect_to root_url
        end
      end
end
