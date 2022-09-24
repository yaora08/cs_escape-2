require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  describe "トップページ" do
    context "ページ全体" do
      before do
        visit root_path
      end

      it "クックログの文字列が存在することを確認" do
        expect(page).to have_content 'NEXT公務員'
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title title
      end
    end

    context "投稿フィード", js: true do
      let!(:user) { create(:user) }
      let!(:micropost) { create(:micropost, user: user) }

      it "投稿一覧の文字が表示されること" do
        login_for_system(user)
        create_list(:micropost, 6, user: user)
        visit root_path
        expect(page).to have_content "投稿一覧"
      end
    end
  end

end
