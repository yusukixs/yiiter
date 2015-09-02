require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "factory girl" do
    user = FactoryGirl.create(:user)
    assert_equal "Yamada Taro", user.full_name
  end
end
