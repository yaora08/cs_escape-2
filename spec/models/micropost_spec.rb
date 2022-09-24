require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let!(:micropost_yesterday) { create(:micropost, :yesterday) } 
  let!(:micropost_one_week_ago) { create(:micropost, :one_week_ago) } 
  let!(:micropost_one_month_ago) { create(:micropost, :one_month_ago) }  
  let!(:micropost) { create(:micropost) }

  context "バリデーション" do
    it "有効な状態であること" do
      expect(micropost).to be_valid
    end

    it "内容がなければ無効な状態であること" do
      micropost = build(:micropost, content: nil)
      micropost.valid?
      expect(micropost.errors[:content]).to include("を入力してください")
    end

    it "内容が140文字以内であること" do
      micropost = build(:micropost, content: "あ" * 141)
      micropost.valid?
      expect(micropost.errors[:content]).to include("は140文字以内で入力してください")
    end

    it "ユーザーIDがなければ無効な状態であること" do
      micropost = build(:micropost, user_id: nil)
      micropost.valid?
      expect(micropost.errors[:user_id]).to include("を入力してください")
    end
  end

  context "並び順" do
    it "最も最近の投稿が最初の投稿になっていること" do
      expect(micropost).to eq Micropost.first
    end
  end
end
