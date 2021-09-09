# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer
#  user_id    :integer
#
# Indexes
#
#  index_likes_on_post_id  (post_id)
#  index_likes_on_user_id  (user_id)
#
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # likeモデルにおいてuser_idはpost_idが同じであれば異なっていなければならないということ
  # post_idが異なれば問題はないというのがscopeの意味
  validates :user_id, uniqueness: { scope: :post_id }
end
