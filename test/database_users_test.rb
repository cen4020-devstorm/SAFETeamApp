require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "at least one user exists in the database" do
    assert User.exists?, "No users found in the database"
  end
end
