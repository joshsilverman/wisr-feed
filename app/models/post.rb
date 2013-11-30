class Post
  include Mongoid::Document
  field :text, type: String
  field :wisr_id, type: Integer

  def self.create_or_update wisr_id, attrs
    return nil if wisr_id.nil?

    post = Post.where(wisr_id: wisr_id).first
    post ||= Post.new(wisr_id: wisr_id)
    post.update(attrs)

    post
  end
end
