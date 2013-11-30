class AskerFeedPost
  include Mongoid::Document
  embedded_in :asker_feed

  field :text, type: String
  field :wisr_id, type: Integer

  def self.create_or_update asker_feed, wisr_id, attrs
    return nil if wisr_id.nil?
    return nil if asker_feed.nil?

    post = asker_feed.posts.where(wisr_id: wisr_id).first
    post ||= asker_feed.posts.new(wisr_id: wisr_id)
    post.update(attrs)

    post
  end
end
