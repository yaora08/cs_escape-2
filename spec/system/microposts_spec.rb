require 'rails_helper'

RSpec.describe "Microposts", type: :system do
    let!(:user) { create(:user)}
    let!(:micropost) { create(:micropost, user: user) }

    describe "投稿ページ" do
        before do
            login_for_system(user)
            visit new_micropost_path
        end

        context "ページレイアウト" do
            it "「新規投稿」の文字列が存在すること" do
                expect(page).to have_content '新規投稿'
            end
        end

        context "投稿処理" do
            it "有効な投稿をすると投稿されました！のフラッシュが表示されること" do
                fill_in "micropost[content]", with: "あああああ"
                attach_file "micropost[picture]", "#{Rails.root}/spec/fixtures/B0BB633C-F9C6-4DCD-8272-4AD6619AF0C2.jpeg"
                click_button "投稿する"
                expect(page).to have_content "投稿されました！"
            end

            it "無効な投稿をすると投稿失敗のフラッシュが表示されること" do
                fill_in "micropost[content]", with: ""
                click_button "投稿する"
                expect(page).to have_content "Contentを入力してください"
            end
        end
    end

    describe "投稿詳細ページ" do
        context "ページレイアウト" do
            before do
                login_for_system(user)
                visit micropost_path(micropost)
            end

            it "投稿詳細が表示されること" do
                expect(page).to have_content micropost.content
            end
        end

        context "投稿の削除", js: true do
            it "投稿が削除されましたのフラッシュが表示されること" do
                login_for_system(user)
                visit micropost_path(micropost)
                click_on '削除'
                page.driver.browser.switch_to.alert.accept
                expect(page).to have_content '投稿が削除されました'
            end
        end
    end
end