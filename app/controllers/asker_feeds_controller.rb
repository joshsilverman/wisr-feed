class AskerFeedsController < ApplicationController
  respond_to :json
  before_filter :authenticate_client!, except: [:show]

  skip_before_filter :verify_authenticity_token, :only => [:update]

  def show
    feed = AskerFeed.where(wisr_id: params[:id]).first
    feed_hash = feed.try :attributes

    if feed
      page_number = params[:page] || 1
      feed_hash[:posts] = feed.posts.page(page_number).per(10)
    end

    render json: feed_hash.to_json
  end

  def update
    wisr_id, attrs = nil

    if params[:asker_feed]

      attrs = params[:asker_feed].permit(:twi_name)
      wisr_id = params[:asker_feed][:wisr_id]
      feed = AskerFeed.create_or_update wisr_id, attrs
      
      AskerFeed.save_dependent_post feed, params[:asker_feed][:post]

      render nothing: true
    else
      render nothing: true, status: 400
    end
  end
end
