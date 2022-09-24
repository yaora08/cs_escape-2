require 'rails_helper'

RSpec.describe "投稿", type: :request do
    let!(:user) { create(:user) }
    let!(:micropost) { create(:micropost, user: user)}
    let(:picture_path) { File.join(Rails.root, 'spec/fixtures/B0BB633C-F9C6-4DCD-8272-4AD6619AF0C2.jpeg') }
    let(:picture) { Rack::Test::UploadedFile.new(picture_path) } 

    context "ログインしているユーザーの場合" do
      before do
        login_for_request(user)
        get new_micropost_path
      end
        it "レスポンスが正常に表示されること" do
            expect(response).to have_http_status "200"
            expect(response).to render_template('microposts/new')
        end

        it "有効な投稿ができること" do
          expect {
            post microposts_path, params: { micropost: { content: "あああああ",
                                                         picture: picture}}
          }.to change(Micropost, :count).by(1)
          follow_redirect!
          expect(response).to render_template('microposts/show')
        end

        it "無効な投稿はできないこと" do
          expect {
            post microposts_path, params: { micropost: { content: "",
                                                         picture: picture}}
          }.not_to change(Micropost, :count)
          expect(response).to render_template('microposts/new')
        end
    end

    context "ログインしていないユーザーの場合" do
        it "投稿しようとするとログイン画面にリダイレクトすること" do
          get new_micropost_path
          expect(response).to have_http_status "302"
          expect(response).to redirect_to login_path
        end

        it "投稿を削除しようとするとログイン画面にリダイレクトすること" do
            delete micropost_path(micropost)
            expect(response).to have_http_status "302"
            expect(response).to redirect_to login_path
          end
      end

end
