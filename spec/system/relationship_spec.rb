require 'rails_helper'

RSpec.describe "Relationships", type: :system do
    let!(:user) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:user3) { create(:user) }
    let!(:user4) { create(:user) }
    let!(:micropost) { create(:micropost, user: user) }
    let!(:micropost2) { create(:micropost, user: user2) }
    let!(:micropost3) { create(:micropost, user: user3) }

    describe "フォローページ" do
        before do
            create(:relationship, follower_id: user.id, followed_id: user2.id)
            create(:relationship, follower_id: user.id, followed_id: user3.id)
            login_for_system(user)
            visit following_user_path(user)
        end

        context "ページレイアウト" do
            it "「フォロー」、「フォロワー」の文字列が存在すること" do
                expect(page).to have_content 'フォロー'
                expect(page).to have_content 'フォロワー'
            end

            it "ユーザー情報が表示されていること" do
                expect(page).to have_content user.name
                expect(page).to have_link user.name, href: user_path(user)
                expect(page).to have_content "#{user.following.count}人をフォロー中"
            end

            it "フォロー中のユーザーが表示されること" do
                within find('.users') do
                    user.following.each do |u|
                        expect(page).to have_link u.name, href: user_path(u)
                    end
                end
            end
        end
    end

    describe "フォロワーページ" do
        before do
            create(:relationship, follower_id: user2.id, followed_id: user.id)
            create(:relationship, follower_id: user3.id, followed_id: user.id)
            create(:relationship, follower_id: user4.id, followed_id: user.id)
            login_for_system(user)
            visit followers_user_path(user)
        end

        context "ページレイアウト" do
            it "「フォロー」、「フォロワー」の文字列が表示されること" do
                expect(page).to have_content 'フォロー'
                expect(page).to have_content 'フォロワー'
            end

            it "ユーザー情報が表示されていること" do
                expect(page).to have_content user.name
                expect(page).to have_link user.name, href: user_path(user)
                expect(page).to have_content "#{user.followers.count}人のフォロワー"
            end

            it "フォロワーが表示されていること" do
                within find('.users') do
                    expect(page).to have_css 'li', count: user.followers.count
                    user.followers.each do |u|
                        expect(page).to have_link u.name, href: user_path(u)
                    end
                end
            end
        end
    end

    describe "フィード" do
        before do
            create(:relationship, follower_id: user.id, followed_id: user2.id)
            login_for_system(user)

        end

        it "フィードに自分の投稿が含まれていること" do
            expect(user.feed).to include micropost
        end

        it "フィードにフォロー中ユーザーの投稿が含まれていること" do
            expect(user.feed).to include micropost2
        end

        it "フィードにフォローしていないユーザーの投稿が含まれないこと" do
            expect(user.feed).not_to include micropost3
        end
    end
end


