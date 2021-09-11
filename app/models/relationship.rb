# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :integer
#  follower_id :integer
#
# Indexes
#
#  index_relationships_on_followed_id_and_follower_id  (followed_id,follower_id) UNIQUE
#
class Relationship < ApplicationRecord
  belongs_to :followed, class_name: 'User'
  belongs_to :follower, class_name: 'User'
  validates :followed_id, presence: true
  validates :follower_id, presence: true
  validates :follower_id, uniqueness: {scope: :followed_id}
end
