require 'test_helper'

describe Post, ".create_or_update" do
  it "returns a post" do
    attrs = {text: 'hey'}
    post = Post.create_or_update 123, attrs

    post.must_be_kind_of Post
  end

  it 'wont return a post if wisr_id is nil' do
    attrs = {text: 'hey'}
    post = Post.create_or_update nil, attrs

    post.must_be_nil
  end

  it 'wont overwrite existing post' do
    post = Post.create_or_update 123, {text: 'hey'}
    post = Post.create_or_update 124, {text: 'hey'}

    Post.count.must_equal 2
    Post.first.wisr_id.must_equal 123
    Post.last.wisr_id.must_equal 124
  end

  it 'will update existing post' do
    post = Post.create_or_update 123, {text: 'hey'}
    post = Post.create_or_update 123, {text: 'heyhey'}

    Post.count.must_equal 1
    Post.first.text.must_equal 'heyhey'
  end
end
