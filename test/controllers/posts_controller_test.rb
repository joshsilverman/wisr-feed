require 'test_helper'

describe PostsController, '#create_or_update' do
  it "returns status 403 if not authorized" do
    post :create_or_update
    
    response.status.must_equal 403
  end

  it 'returns status 403 if auth token passed as user' do
    user = create :user, :with_auth_token
    token = user.authentication_token

    post :create_or_update, auth_token: token
    
    response.status.must_equal 403
  end

  it 'returns status 200 if auth token passed as client' do
    client = create :client, :with_auth_token
    params = {
      auth_token: client.authentication_token,
      post: {
        id: 123,
        text: 'I am a post'
      }
    }

    post :create_or_update, params
    
    response.status.must_equal 200
  end

  it 'creates a new post with the given post data' do
    client = create :client, :with_auth_token
    token = client.authentication_token

    params = {
      auth_token: token,
      post: {
        id: 123,
        text: 'I am a post'
      }
    }

    post :create_or_update, params

    Post.count.must_equal 1
    Post.last.text.must_equal 'I am a post'
    Post.last.wisr_id.must_equal 123
  end

  it 'returns 400 if authorized but notpost data' do
    client = create :client, :with_auth_token
    token = client.authentication_token

    params = {
      auth_token: token
    }

    repsonse = post :create_or_update, params

    response.status.must_equal 400
  end

  it 'creates a new post with wisr_id when given string id' do
    client = create :client, :with_auth_token
    token = client.authentication_token

    params = {
      auth_token: token,
      post: {id: '123'}
    }

    post :create_or_update, params

    Post.last.wisr_id.must_equal 123
  end
end
