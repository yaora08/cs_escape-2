require "rails_helper"

RSpec.describe "投稿の削除", type: :request do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let!(:micropost) { create(:micropost, user: user) }
    
    context "ログインしていて自分の投稿を削除する場合" do
        it "処理が成功し、ユーザーページにリダイレクトすること" do
            login_for_request(user)
            expect {
                delete micropost_path(micropost)
            }.to change(Micropost, :count).by(-1)
            redirect_to user_path(user)
            follow_redirect!
            expect(response).to render_template('users/show')
        end
    end

    context "ログインしていて他人の投稿を削除する場合" do
        it "処理が失敗しトップページへリダイレクトすること" do
            login_for_request(other_user)
            expect {
                delete micropost_path(micropost)
            }.not_to change(Micropost, :count)
            expect(response).to have_http_status "302"
            expect(response).to redirect_to root_path
        end
    end

    context "ログインしていない場合" do
        it "ログインページへリダイレクトすること" do
            expect {
                delete micropost_path(micropost)
            }.not_to change(Micropost, :count)
            expect(response).to have_http_status "302"
            expect(response).to redirect_to login_path
        end
    end
end