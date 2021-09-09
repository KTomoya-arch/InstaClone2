class LikesController < ApplicationController
  before_action :require_login, only: %i[create destroy]

  def create
    @post = Post.find(params[:post_id])
    #Userモデルに定義したlikeメソッドでlike_postsに@postを追加する
    #ユーザーがいいねした投稿データ群にいいねした投稿を追加する
    current_user.like(@post)
  end

  def destroy
    @post = Like.find(params[:id]).post
    current_user.unlike(@post)
  end
end
