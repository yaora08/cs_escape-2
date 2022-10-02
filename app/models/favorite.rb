class Favorite < ApplicationRecord
    belongs_to :user
    belongs_to :micropost
    default_scope -> { order(created_at: :desc) } 
    validates :user_id, presence: true
    validates :micropost_id, presence: true
end
