class PostsController < ApplicationController
  respond_to :json
  before_filter :authenticate_client!, only: [:create_or_update]

  def index
    posts = Post.all
    json = posts.to_json
    render json: json
  end

  def create_or_update
    render nothing: true
  end
end
