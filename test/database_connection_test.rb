require 'test_helper'

class DatabaseConfigTest < ActiveSupport::TestCase
  test "database connection is active" do
    assert ActiveRecord::Base.connection.active?, "Database connection is not active"
  end

  test "users table exists" do
    assert ActiveRecord::Base.connection.table_exists?('users'), "Users table does not exist"
  end
end
