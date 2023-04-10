class UsersController < ApplicationController
  def index
    @posts = current_user.posts
    @comments = current_user.comments
  end
end
