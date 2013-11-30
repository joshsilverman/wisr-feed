class PostsController < ApplicationController
  respond_to :json
  before_filter :authenticate_client!, only: [:create_or_update]

  skip_before_filter :verify_authenticity_token, :only => [:create_or_update]

  def index
    posts = Post.all
    json = posts.to_json
    render json: json
  end

  def create_or_update
    wisr_id, attrs = nil

    if params[:post]
      attrs = params[:post].permit(:text)
      wisr_id = params[:post][:id] 
    end

    new_post = Post.create_or_update wisr_id, attrs

    render nothing: true
  end
end
