class AskerFeedPost
  include Mongoid::Document
  embedded_in :asker_feed

  field :wisr_id, type: Integer
  field :created_at, type: Time
  field :question, type: String
  field :correct_answer, type: String
  field :false_answers, type: Array
  field :user_profile_image_urls, type: Array

  paginates_per 10

  def self.create_or_update asker_feed, wisr_id, attrs
    return nil if wisr_id.nil?
    return nil if asker_feed.nil?

    post = asker_feed.posts
      .where(wisr_id: wisr_id).first

    post ||= asker_feed.posts.new(wisr_id: wisr_id)
    post.update(attrs)

    post
  end
end
