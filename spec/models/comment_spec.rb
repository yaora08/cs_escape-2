require 'rails_helper'

RSpec.describe "投稿", type: :model do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let!(:micropost) { create(:micropost, user: user) }
end
