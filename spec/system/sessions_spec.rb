require 'rails_helper'

RSpec.describe "Sessions", type: :system do
    let!(:user) {create(:user)}

    before do
        visit login_path
    end

    describe "ログインページ" do
        context "ページレイアウト" do
            it "「ログイン」の文字列が存在することを確認" do
                expect(page).to have_content 'ログイン'
            end

            it "ログインフォームが正しく表示されることを確認" do
                expect(page).to have_css 'input#session_email'
                expect(page).to have_css 'input#session_password'
            end

            it "「ログイン状態を保持する」チェックボックスが表示される" do
                expect(page).to have_content 'ログイン状態を保持する'
                expect(page).to have_css 'input#session_remember_me'
            end

            it "ログインボタンが表示される" do
                expect(page).to have_button 'ログイン'
            end
        end

        context "ログイン処理" do
            it "無効なユーザーでログインを行うとログインが失敗することを確認" do
              fill_in "session[email]", with: "user@example.com"
              fill_in "session[password]", with: "pass"
              click_button "ログイン"
              expect(page).to have_content 'メールアドレスとパスワードの組み合わせが誤っています'
            end

            it "画面遷移するとエラーメッセージが消える" do
              visit root_path
              expect(page).not_to have_content "メールアドレスとパスワードの組み合わせが誤っています"
            end
        end
    end
end