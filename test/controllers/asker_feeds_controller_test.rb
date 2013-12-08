require 'test_helper'

describe AskerFeedsController, '#show' do
  it "renders an empty array when no asker found" do
    response = get :show, id: 10

    response.body.must_equal 'null'
  end

  it "renders hash with asker if asker_feed exists" do
    feed = AskerFeed.create twi_name: 'Goose', wisr_id: 123
    response = get :show, id: feed.wisr_id
    
    returned_json = ActiveSupport::JSON.decode(response.body)
    returned_json['twi_name'].must_equal 'Goose'
  end

  it "renders hash with asker if asker_feed exists" do
    feed = AskerFeed.create twi_name: 'Goose', wisr_id: 123
    post = feed.posts.create question: 'yolo?'
    response = get :show, id: feed.wisr_id
    
    returned_json = ActiveSupport::JSON.decode(response.body)
    returned_json['posts'].first['question'].must_equal 'yolo?'
  end
end

describe AskerFeedsController, '#update' do
  it "returns status 403 if not authorized" do
    post :update
    
    response.status.must_equal 403
  end

  it 'returns status 403 if auth token passed as user' do
    user = create :user, :with_auth_token
    token = user.authentication_token

    post :update, auth_token: token
    
    response.status.must_equal 403
  end

  it 'returns status 200 if auth token passed as client' do
    client = create :client, :with_auth_token
    params = {
      auth_token: client.authentication_token,
      asker_feed: {id: 123, twi_name: 'BioBud'}
    }

    post :update, params
    
    response.status.must_equal 200
  end

  it 'creates a new asker_feed if it doesnt exist' do
    client = create :client, :with_auth_token
    token = client.authentication_token

    params = {
      auth_token: token,
      asker_feed: {
        wisr_id: 123,
        twi_name: 'BioBud'
      }
    }

    post :update, params

    AskerFeed.count.must_equal 1
    AskerFeed.first.twi_name.must_equal 'BioBud'
  end

  it 'creates a post if included in asker obj' do
    client = create :client, :with_auth_token
    token = client.authentication_token

    params = {
      auth_token: token,
      asker_feed: {wisr_id: 123, 
                   twi_name: 'BioBud', 
                   post: {question: 'Whatup?', wisr_id: 777}
                  }
    }

    post :update, params

    AskerFeed.first.posts.last.question.must_equal 'Whatup?'
    AskerFeed.first.posts.last.wisr_id.must_equal 777
  end
end
