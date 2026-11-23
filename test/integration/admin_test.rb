require 'test_helper'

class AdminTest < ActionDispatch::IntegrationTest
  test "admin requires sign in" do
    get "/admin/posts"

    assert_redirected_to "/admin/login"
  end

  test "commissioner signs in and sees posts" do
    sign_in
    get "/admin/posts"

    assert_response :success
    assert_includes response.body, "Trade Deadline Recap"
  end

  test "wrong password is rejected" do
    post "/admin/login", params: { email: "commish@example.com", password: "nope" }
    get "/admin/posts"

    assert_redirected_to "/admin/login"
  end

  test "posts can be filtered by season" do
    sign_in
    get "/admin/posts", params: { season_id: seasons(:last_season).id }

    assert_response :success
    assert_includes response.body, "Champion Crowned"
    assert_not_includes response.body, "Trade Deadline Recap"
    assert_select "ul.nav-pills li.active a", "2024–25"
  end

  test "sorting keeps the season filter" do
    sign_in
    get "/admin/posts", params: { season_id: seasons(:last_season).id }

    assert_select "th a[href*=?]", "season_id=#{seasons(:last_season).id}"
  end

  test "posts without a season get their own filter" do
    posts(:draft).update_column(:season_id, nil)
    sign_in
    get "/admin/posts", params: { season_id: "none" }

    assert_includes response.body, "Half-written draft"
    assert_not_includes response.body, "Trade Deadline Recap"
    assert_select "ul.nav-pills li.active a", "No season"
  end

  test "new post defaults to the current season" do
    sign_in
    get "/admin/posts/new"

    assert_response :success
    assert_select "select[name='post[season_id]'] option[selected]", "2025–26"
  end

  test "commissioner creates a post in a season" do
    sign_in

    assert_difference -> { seasons(:last_season).posts.count } do
      post "/admin/posts", params: { post: { title: "Late recap", season_id: seasons(:last_season).id, content: "Hi" } }
    end
  end

  test "commissioner adds a season" do
    sign_in

    assert_difference -> { Season.count } do
      post "/admin/seasons", params: { season: { name: "2026–27", start_year: 2026 } }
    end
    assert_equal "2026–27", Season.current.name
  end

  private

  def sign_in
    post "/admin/login", params: { email: "commish@example.com", password: "password" }
    follow_redirect!
  end
end
