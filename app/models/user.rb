class User
  include Mongoid::Document
  field :wisr_id, type: Integer
  field :authentication_token, type: String
  field :client, type: Boolean

  devise :token_authenticatable

  def self.serialize_from_session user_id_array, expiry = nil
    return nil unless user_id_array.is_a? Array
    return nil unless user_id_array.first.is_a? Integer
    user_id = user_id_array.first

    user = User.where(wisr_id: user_id).first
    user ||= User.create(wisr_id: user_id) if user_id
  end

  def create_auth_token
    reset_authentication_token!

    authentication_token
  end

  def is_client?
    client
  end
end
