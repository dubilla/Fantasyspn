require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "requires a season" do
    post = Post.new(title: "No season")

    assert_not post.valid?
    assert post.errors.added?(:season, :blank)
  end
end
