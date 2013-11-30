class AskerFeedsController < ApplicationController
  respond_to :json
  before_filter :authenticate_client!, except: [:show]

  skip_before_filter :verify_authenticity_token, :only => [:update]

  def show
    feed = AskerFeed.where(id: params[:id]).first

    render json: feed.to_json
  end

  def update
    wisr_id, attrs = nil

    if params[:user]
      attrs = params[:user].permit(:twi_name)
      wisr_id = params[:user][:id] 
      feed = AskerFeed.create_or_update wisr_id, attrs

      AskerFeed.save_dependent_posts feed, params

      render nothing: true
    else
      render nothing: true, status: 400
    end
  end
end
