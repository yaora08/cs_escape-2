require 'rails_helper'

RSpec.describe "Users", type: :system do
  let!(:user) { create(:user) }
  let!(:admin_user) { create(:user, :admin) }
  let!(:other_user) { create(:user) }
  let!(:micropost) { create(:micropost, user: user) }

  describe "ユーザー一覧ページ" do
    context "管理者ユーザーの場合" do
      it "ぺージネーション、自分以外のユーザーの削除ボタンが表示されること" do
        create_list(:user, 30)
        login_for_system(admin_user)
        visit users_path
        expect(page).to have_css "div.pagination"
        User.paginate(page: 1).each do |u|
          expect(page).to have_link u.name, href: user_path(u)
          expect(page).to have_content "#{u.name} | 削除" unless u == admin_user
        end
      end
    end

    context "管理者ユーザー以外の場合" do
      it "ぺージネーション、自分のアカウントのみ削除ボタンが表示されること" do
        create_list(:user, 30)
        login_for_system(user)
        visit users_path
        expect(page).to have_css "div.pagination"
        User.paginate(page: 1).each do |u|
          expect(page).to have_link u.name, href: user_path(u)
          if u == user
            expect(page).to have_content "#{u.name} | 削除"
          else
            expect(page).not_to have_content "#{u.name} | 削除"
          end
        end
      end
    end

    context "お気に入り登録/解除ができること" do
      before do
        login_for_system(user)
      end

      it "料理のお気に入り登録/解除ができること" do
        expect(user.favorite?(micropost)).to be_falsey
        user.favorite(micropost)
        expect(user.favorite?(micropost)).to be_truthy
        user.unfavorite(micropost)
        expect(user.favorite?(micropost)).to be_falsey
      end

      it "トップページからお気に入り登録/解除ができること" do
        visit root_path
        link = find('.like')
        expect(link[:href]).to include "/favorites/#{micropost.id}/create"
        link.click
        link = find('.unlike')
        expect(link[:href]).to include "/favorites/#{micropost.id}/destroy"
        link.click
        link = find('.like')
        expect(link[:href]).to include "/favorites/#{micropost.id}/create"
      end

      it "ユーザー個別ページからお気に入り登録/解除ができること" do
        visit user_path(user)
        link = find('.like')
        expect(link[:href]).to include "/favorites/#{micropost.id}/create"
        link.click
        link = find('.unlike')
        expect(link[:href]).to include "/favorites/#{micropost.id}/destroy"
        link.click
        link = find('.like')
        expect(link[:href]).to include "/favorites/#{micropost.id}/create"
      end

      it "投稿詳細ページからお気に入り登録/解除ができること" do
        visit micropost_path(micropost)
        link = find('.like')
        expect(link[:href]).to include "/favorites/#{micropost.id}/create"
        link.click
        link = find('.unlike')
        expect(link[:href]).to include "/favorites/#{micropost.id}/destroy"
        link.click
        link = find('.like')
        expect(link[:href]).to include "/favorites/#{micropost.id}/create"
      end
    end
  end

  describe "新規登録ページ" do
    before do
      visit signup_path
    end
  
    context "ページレイアウト" do
      it "「新規登録」の文字列が存在することを確認" do
        expect(page).to have_content '新規登録'
      end
  
      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title ('NEXT公務員')
      end
    end
  

    context "ユーザー登録処理" do
      it "有効なユーザーでユーザー登録を行うとユーザー登録成功のフラッシュが表示されること" do
        fill_in "user[name]", with: "Example"
        fill_in "user[email]", with: "user@example.com"
        fill_in "user[password]", with: "password"
        fill_in "user_password_confirmation", with: "password"
        click_button "アカウント作成"
        # expect(page).to have_content "NEXT公務員へようこそ!"
      end
   
      it "無効なユーザーでユーザー登録を行うとユーザー登録失敗のフラッシュが表示されること" do
        fill_in "user[name]", with: ""
        fill_in "user[email]", with: "user@example.com"
        fill_in "user[password]", with: "password"
        fill_in "user_password_confirmation", with: "pass"
        click_button "アカウント作成"
        expect(page).to have_content "ユーザー名を入力してください"
        expect(page).to have_content "パスワード(確認)とパスワードの入力が一致しません"
      end
    end
  end


  describe "プロフィール編集ページ" do
    before do
      login_for_system(user)
      visit user_path(user)
      click_link "プロフィールを編集"
    end

    context "ページレイアウト" do
      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title ('NEXT公務員')
      end
    end

    it "有効なプロフィール更新を行うと、更新成功のフラッシュが表示されること" do
      fill_in "user[name]", with: "Edit Example User"
      fill_in "user[email]", with: "edit-user@example.com"
      fill_in "user[introduction]", with: "編集：初めまして"
      click_button "更新する"
      expect(page).to have_content "プロフィールが更新されました！"
      expect(user.reload.name).to eq "Edit Example User"
      expect(user.reload.email).to eq "edit-user@example.com"
      expect(user.reload.introduction).to eq "編集：初めまして"
    end

    it "無効なプロフィール更新をしようとすると、適切なエラーメッセージが表示されること" do
      fill_in "user[name]", with: ""
      fill_in "user[email]", with: ""
      click_button "更新する"
      expect(page).to have_content 'ユーザー名を入力してください'
      expect(page).to have_content 'メールアドレスを入力してください'
      expect(page).to have_content 'メールアドレスは不正な値です'
      expect(user.reload.email).not_to eq ""
    end

    context "アカウント削除処理", js: true do
      it "正しく削除できること" do
        click_link "アカウントを削除する"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "自分のアカウントを削除しました"
      end
    end
  end


  
  describe "プロフィールページ" do
    context "ページレイアウト" do
      before do
        login_for_system(user)
        create_list(:micropost, 50, user: user)
        visit user_path(user)
      end
 
      it "ユーザー情報が表示されることを確認" do
        expect(page).to have_content user.name
      end

      it "プロフィール編集ページへのリンクが表示されていることを確認" do
        expect(page).to have_link 'プロフィールを編集', href: edit_user_path(user)
      end

      it "投稿の情報が表示されていることを確認" do
        Micropost.take(2).each do |micropost|
          expect(page).to have_link micropost.user.name
          expect(page).to have_content micropost.content
        end
      end

      it "投稿のページネーションが表示されていることを確認" do
        expect(page).to have_css "div.pagination"
      end
    end

    context "ユーザーのフォロー/アンフォロー処理", js: true do
      it "ユーザーのフォロー/アンフォローができること" do
        login_for_system(user)
        visit user_path(other_user)
        expect(page).to have_button 'フォローする'
        click_button 'フォローする'
        expect(page).to have_button 'フォローをやめる'
        click_button 'フォローをやめる'
        expect(page).to have_button 'フォローする'
      end
    end
  end
  
end




