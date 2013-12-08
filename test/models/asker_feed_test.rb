require 'test_helper'

describe AskerFeed, ".create_or_update" do
  it "returns a feed object" do
    attrs = {id: 2, 
             twi_name: "Govt101", 
             twi_screen_name: "Govt101", 
             twi_profile_img_url: "http://a0.twimg.com/profile_images/2695260776/7c92da624602bb709d4e63e98b5ec5ef_normal.png", 
             description: "Daily #government quiz questions! Think you know a lot about american government? Want to learn more? Tweet me your answers! [Like this? Try out @AP_ushistory]", 
             bg_image: "bg-govt101-fwk.jpg", 
             published: false}

    feed = AskerFeed.create_or_update 123, attrs

    feed.must_be_kind_of AskerFeed
  end

  it 'wont return a feed if wisr_id is nil' do
    attrs = {twi_name: 'twi'}
    post = AskerFeed.create_or_update nil, attrs

    post.must_be_nil
  end

  it 'wont overwrite existing feed' do
    feed = AskerFeed.create_or_update 123, {twi_name: 'hey'}
    feed = AskerFeed.create_or_update 124, {twi_name: 'hey'}

    AskerFeed.count.must_equal 2
    AskerFeed.first.wisr_id.must_equal 123
    AskerFeed.last.wisr_id.must_equal 124
  end

  it 'will update existing feed' do
    feed = AskerFeed.create_or_update 123, {twi_name: 'hey'}
    feed = AskerFeed.create_or_update 123, {twi_name: 'heyhey'}

    AskerFeed.count.must_equal 1
    AskerFeed.first.twi_name.must_equal 'heyhey'
  end
end

describe AskerFeed, "#save_dependent_post" do
  it "should accept a single post" do
    feed = AskerFeed.create
    params = ActionController::Parameters.new({wisr_id: 123, 
      question: 'postpost?'})

    AskerFeed.save_dependent_post feed, params

    feed.posts.count.must_equal 1
    feed.posts.first.question.must_equal 'postpost?'
  end

  it "returns nil if no post passed" do
    feed = AskerFeed.create
    params = nil

    AskerFeed.save_dependent_post(feed, params).must_equal nil
  end

  it "returns nil if no wisr_id passed" do
    feed = AskerFeed.create
    params = ActionController::Parameters.new({})

    AskerFeed.save_dependent_post(feed, params).must_equal nil
  end

  it "accepts expected attrs" do
    feed = AskerFeed.create
    params = ActionController::Parameters.new({wisr_id: 123, 
      question: 'postpost?',
      correct_answer: 'yep',
      false_answers: ['naw', 'maybe'],
      user_profile_image_urls: ['www.asdf.com', 'www.fdad.com']})

    attrs = params.slice(:question, 
      :correct_answer, 
      :false_answers,
      :user_profile_image_urls)
    AskerFeedPost.expects(:create_or_update).with(feed, 123, attrs)

    AskerFeed.save_dependent_post feed, params
  end
end