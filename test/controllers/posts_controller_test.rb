require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "index lists published posts, newest first" do
    get root_path

    assert_response :success
    titles = css_select("section li a").map(&:text)
    assert_equal ["Trade Deadline Recap", "Week 1 Power Rankings"], titles
  end

  test "show renders the post's markdown" do
    get post_path(posts(:sent))

    assert_response :success
    assert_select "h2.post-headline", "Week 1 Power Rankings"
    assert_select ".post-body strong", "Team Alpha"
  end
end
