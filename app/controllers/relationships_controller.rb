class RelationshipsController < ApplicationController
  before_action :require_login, only: %i[create destroy]
  # followする
  # followed_idにUserモデルでidが合致するユーザーを取得
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
  end

  # followを外す
  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
  end
end
