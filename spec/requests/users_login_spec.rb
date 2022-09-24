require "rails_helper"

RSpec.describe "ログイン", type: :request do
  let!(:user) { create(:user) }

  it "正常なレスポンスを返すこと" do
    get login_path
    expect(response).to be_successful
    expect(response).to have_http_status "200"
  end

  it "有効なユーザーでログイン、ログアウト" do
    get login_path
    post login_path, params: { session: { email: user.email,
                                          password: user.password } }
    redirect_to user
    follow_redirect!
    expect(response).to render_template('users/show')
    expect(is_logged_in?).to be_truthy
    delete logout_path
    expect(is_logged_in?).not_to be_truthy
    redirect_to root_url
    delete logout_path  
    follow_redirect!    
  end

  it "無効なユーザーでログイン" do
    get login_path
    post login_path, params: { session: { email: "xxx@example.com",
                                         password: user.password } }
    expect(is_logged_in?).not_to be_truthy
  end
end

RSpec.describe "永続セッション機能", type: :request do
  let(:user) { create(:user) }

  context "「ログインしたままにする」にチェックを入れてログインする場合" do
    before do
      login_remember(user)
    end

    it "remember_tokenが空でないことを確認" do
      expect(response.cookies['remember_token']).not_to eq nil
    end

    it "セッションがnilのときでもcurrent_userが正しいユーザーを指すことを確認" do
      expect(current_user).to eq user
      expect(is_logged_in?).to be_truthy
    end
  end

  context "ログアウトする場合" do
    it "ログイン中のみログアウトすることを確認" do
      login_for_request(user)
      expect(response).to redirect_to user_path(user)
      # ログアウトする
      delete logout_path
      expect(response).to redirect_to root_path
      expect(session[:user_id]).to eq nil
      # 2番目のウィンドウでログアウトする
      delete logout_path
      expect(response).to redirect_to root_path
      expect(session[:user_id]).to eq nil
    end
  end
end
