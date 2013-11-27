class User
  include Mongoid::Document
  field :wisr_id, type: Integer

  def self.serialize_from_session user_id_array, expiry = nil
    return nil unless user_id_array.is_a? Array
    return nil unless user_id_array.first.is_a? Integer
    user_id = user_id_array.first

    user = User.where(wisr_id: user_id).first
    user ||= User.create(wisr_id: user_id) if user_id
  end
end
