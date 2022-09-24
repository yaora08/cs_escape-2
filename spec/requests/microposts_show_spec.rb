require "rails_helper"

RSpec.describe "投稿詳細ページ", type: :request do
    let!(:user) { create(:user) }
    let!(:micropost) { create(:micropost, user: user) }

    context "ログインしているユーザーの場合" do
        it "レスポンスが正常に表示されること" do
            login_for_request(user)
            get micropost_path(micropost)
            expect(response).to have_http_status "200"
            expect(response).to render_template('microposts/show')
        end
    end

    context "ログインしていないユーザーの場合" do
        it "ログイン画面にリダイレクトすること"do
            get micropost_path(micropost)
            expect(response).to have_http_status "302"
            expect(response).to redirect_to login_path
        end
    end
end