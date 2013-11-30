require 'test_helper'

describe AskerFeedPost, ".create_or_update" do
  it "returns a post" do
    feed = AskerFeed.create
    attrs = {text: 'hey'}
    post = AskerFeedPost.create_or_update feed, 123, attrs

    post.must_be_kind_of AskerFeedPost
  end

  it 'wont return a post if wisr_id is nil' do
    attrs = {text: 'hey'}
    post = AskerFeedPost.create_or_update AskerFeed.new, nil, attrs

    post.must_be_nil
  end

  it 'wont overwrite existing post' do
    feed = AskerFeed.create
    post = AskerFeedPost.create_or_update feed, 123, {text: 'hey'}
    post = AskerFeedPost.create_or_update feed, 124, {text: 'hey'}

    posts = feed.posts
    posts.count.must_equal 2
    posts.first.wisr_id.must_equal 123
    posts.last.wisr_id.must_equal 124
  end

  it 'will update existing post' do
    feed = AskerFeed.create
    post = AskerFeedPost.create_or_update feed, 123, {text: 'hey'}
    post = AskerFeedPost.create_or_update feed, 123, {text: 'heyhey'}

    posts = feed.posts
    posts.count.must_equal 1
    posts.first.text.must_equal 'heyhey'
  end
end
