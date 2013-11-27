class PostsController < ApplicationController
  respond_to :json

  def index
    posts = Post.all
    json = posts.to_json
    # render json: json
    render json: current_user.to_json
  end


end
