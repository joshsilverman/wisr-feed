class PostsController < ApplicationController
  respond_to :json

  def index
    posts = Post.all
    json = posts.to_json
    render json: json
  end


end
