class AskerFeed
  include Mongoid::Document
  embeds_many :posts, class_name: 'AskerFeedPost'

  field :wisr_id, type: Integer
  field :twi_name, type: String
  field :twi_screen_name, type: String
  field :twi_profile_img_url, type: String
  field :description, type: String
  field :bg_image, type: String
  field :published, type: Boolean

  def self.create_or_update wisr_id, attrs
    return nil if wisr_id.nil?

    feed = where(wisr_id: wisr_id).first
    feed ||= new(wisr_id: wisr_id)
    feed.update(attrs)

    feed
  end

  def self.save_dependent_posts feed, params
    posts_params = params[:posts]
    posts_params ||= [params[:post]]

    return if posts_params.nil?

    posts_params.each do |post_params|
      post_params = ActionController::Parameters.new post_params
      attrs = post_params.permit(:text)

      AskerFeedPost.create_or_update feed, post_params[:id], attrs
    end
  end
end