# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  crypted_password :string
#  email            :string           not null
#  salt             :string
#  username         :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_username  (username) UNIQUE
#
class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :likes_posts, through: :likes, source: :post
  # active_relationshipsクラスを見たいがないのでRelationshipクラスを明示的に見させる
  # follower_idがフォローする側のidでfollowed_idはフォローされる側のid
  # @user.active_relationshipsが使用できるようになった(ユーザーがフォローしたidの集合)
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy
  #@user.active_relationships.map(&:followed)

  # railsは:followedsのシンボルをfollowedの単数形と捉えrelationshipsのfollowed_idを使う
  # followingはfollowedのidの集合
  # しかし命名がuser.followedsとなり不適切なためuser.followingとする
  # その際にfollowingとは何かをsource: として明示している
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower                            
  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  scope :recent, ->(count) { order(created_at: :desc).limit(count) }
  def own?(object)
    id == object.user_id
  end
  
  # like_postsに対してpostを破壊的に追加する
  # https://docs.ruby-lang.org/ja/latest/method/Array/i/=3c=3c.html
  def like(post)
    likes_posts << post
  end

  def unlike(post)
    likes_posts.destroy(post)
  end

  # Like.where(user_id: id, post_id: post.id).exist?と同義のよう
  def like?(post)
    likes_posts.include?(post)
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    following.destroy(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def feed
    Post.where(user_id: following_ids << id)
  end
end
