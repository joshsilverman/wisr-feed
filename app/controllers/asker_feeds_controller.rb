class AskerFeedsController < ApplicationController
  respond_to :json
  before_filter :authenticate_client!, except: [:show]

  # skip_before_filter :verify_authenticity_token, :only => [:update]

  def show
    feed = AskerFeed.where(id: params[:id]).first

    render json: feed.to_json
  end

  def update
    wisr_id, attrs = nil

    if params[:asker]
      attrs = params[:asker].permit(:twi_name)
      wisr_id = params[:asker][:id] 
      feed = AskerFeed.create_or_update wisr_id, attrs

      save_dependent_posts feed, params

      render nothing: true
    else
      render nothing: true, status: 400
    end
  end

  private

  def save_dependent_posts feed, params
    return if params[:posts].nil?

    params[:posts].each do |post_params|
      post_params = ActionController::Parameters.new post_params
      attrs = post_params.permit(:text)

      AskerFeedPost.create_or_update feed, post_params[:id], attrs
    end
  end
end
