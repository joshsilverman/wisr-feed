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
end
