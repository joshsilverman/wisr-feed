require 'test_helper'

describe User, "#serialize_from_session" do
  it "returns nil if user_id nil" do
    serialized_user = User.serialize_from_session nil
    serialized_user.must_equal nil
  end

  it "returns user if givin valid user_id" do
    user = User.create wisr_id: 123

    serialized_user = User.serialize_from_session [user.wisr_id]
    serialized_user.must_equal user
  end

  it "returns a user if givin new user_id" do
    serialized_user = User.serialize_from_session [456]
    serialized_user.must_be_kind_of User
  end

  it "wont error if given second argument" do
    serialized_user = User.serialize_from_session [456], :arg
  end

  it "returns nil if givin user_id without array" do
    serialized_user = User.serialize_from_session 1
    serialized_user.must_equal nil
  end
end