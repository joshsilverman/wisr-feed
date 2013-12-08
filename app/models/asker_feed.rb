class AskerFeed
  include Mongoid::Document
  embeds_many :posts, class_name: 'AskerFeedPost', order: :created_at.desc

  field :wisr_id, type: Integer # corresponds to publication
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

  def self.save_dependent_post feed, params
    return if params.nil?
    attrs = params.slice(:question, 
      :created_at,
      :correct_answer,
      :false_answers,
      :user_profile_image_urls).permit!
    AskerFeedPost.create_or_update feed, params[:wisr_id], attrs
  end
end