require 'rails_helper'

RSpec.describe "お気に入り登録", type: :request do
    let(:user) { create(:user)}
    let(:micropost) { create(:micropost) }

    context "お気に入り登録処理" do
      context "ログインしている場合" do
        before do
            login_for_request(user)
        end

        it "投稿をお気に入り登録できること" do
            expect {
                post "/favorites/#{micropost.id}/create"
            }.to change(user.favorites, :count).by(1)
        end

        it "Ajaxにより投稿をお気に入り登録できること" do
            expect {
                post "/favorites/#{micropost.id}/create", xhr: true
            }.to change(user.favorites, :count).by(1)
        end

        it "投稿のお気に入り解除ができること" do
            user.favorite(micropost)
            expect {
                delete "/favorites/#{micropost.id}/destroy"
            }.to change(user.favorites, :count).by(-1)
        end

        it "Ajaxにより投稿のお気に入り解除ができること" do
            user.favorite(micropost)
            expect {
                delete "/favorites/#{micropost.id}/destroy", xhr: true
            }.to change(user.favorites, :count).by(-1)
        end
      end


      context "ログインしていない場合" do
        it "お気に入り登録は実行できず、ログインページへリダイレクトする" do
            expect {
                post "/favorites/#{micropost.id}/create"
            }.not_to change(Favorite, :count)
            expect(response).to redirect_to login_path
        end

        it "お気に入り解除は実行できず、ログインページへリダイレクトする" do
            expect {
                delete "/favorites/#{micropost.id}/destroy"
            }.not_to change(Favorite, :count)
            expect(response).to redirect_to login_path
        end
      end
    end
end
