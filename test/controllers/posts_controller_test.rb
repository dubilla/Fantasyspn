require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "home lists the current season's published posts, newest first" do
    get root_path

    assert_response :success
    assert_select "h2.season-name", "2025–26"
    titles = css_select("section li a").map(&:text)
    assert_equal ["Trade Deadline Recap", "Week 1 Power Rankings"], titles
  end

  test "home links back to the previous season" do
    get root_path

    assert_select "a.season-nav-previous[href=?]", season_path(seasons(:last_season)), text: "← 2024–25"
    assert_select "a.season-nav-next", false
  end

  test "home says so when there are no seasons" do
    Post.delete_all
    Season.delete_all

    get root_path

    assert_response :success
    assert_select ".season-empty", "No posts yet."
  end

  test "show renders the post's markdown and its season" do
    get post_path(posts(:sent))

    assert_response :success
    assert_select "h2.post-headline", "Week 1 Power Rankings"
    assert_select ".post-body strong", "Team Alpha"
    assert_select ".post-season a[href=?]", season_path(seasons(:this_season)), text: "2025–26"
  end
end
