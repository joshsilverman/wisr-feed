require 'test_helper'

describe AskerFeedPost, ".create_or_update" do
  it "returns a post" do
    feed = AskerFeed.create
    attrs = {question: 'hey'}
    post = AskerFeedPost.create_or_update feed, 123, attrs

    post.must_be_kind_of AskerFeedPost
  end

  it 'wont return a post if wisr_publication_id is nil' do
    attrs = {question: 'hey'}
    post = AskerFeedPost.create_or_update AskerFeed.new, nil, attrs

    post.must_be_nil
  end

  it 'wont overwrite existing post' do
    feed = AskerFeed.create
    post = AskerFeedPost.create_or_update feed, 123, {question: 'hey'}
    post = AskerFeedPost.create_or_update feed, 124, {question: 'hey'}

    posts = feed.posts
    posts.count.must_equal 2
    posts.first.wisr_id.must_equal 123
    posts.last.wisr_id.must_equal 124
  end

  it 'will update existing post' do
    feed = AskerFeed.create
    post = AskerFeedPost.create_or_update feed, 123, {question: 'hey?'}
    post = AskerFeedPost.create_or_update feed, 123, {question: 'heyhey?'}

    posts = feed.posts
    posts.count.must_equal 1
    posts.first.question.must_equal 'heyhey?'
  end

  it 'has necessary fields' do
    feed = AskerFeed.create
    attrs = {created_at: 1.day.ago,
             question: 'How?',
             correct_answer: 'because',
             false_answers: ['cuz', 'just cuz'],
             user_profile_image_urls: ['me.com/me.jpg', 'him.com/him.png']
            }
    post = AskerFeedPost.create_or_update feed, 123, attrs

    attrs.each do |attr_name, attr_val|
      post.send(attr_name).must_equal attr_val
    end
  end
end
