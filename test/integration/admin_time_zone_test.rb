require 'test_helper'

class AdminTimeZoneTest < ActionDispatch::IntegrationTest
  setup do
    @day = Date.new(Date.current.year + 1, 1, 10)
    post "/admin/login", params: { email: "commish@example.com", password: "password" }
  end

  test "publish time is read in the browser's time zone" do
    cookies["time_zone"] = "America/Los_Angeles"
    create_post_at "#{@day}T21:00"

    assert_equal Time.utc(@day.year, 1, 11, 5), Post.find_by!(title: "Sunday recap").published_at
  end

  test "publish time falls back to Eastern without a browser time zone" do
    create_post_at "#{@day}T21:00"

    assert_equal Time.utc(@day.year, 1, 11, 2), Post.find_by!(title: "Sunday recap").published_at
  end

  test "an unknown time zone falls back to Eastern" do
    cookies["time_zone"] = "Mars/Olympus_Mons"
    create_post_at "#{@day}T21:00"

    assert_equal Time.utc(@day.year, 1, 11, 2), Post.find_by!(title: "Sunday recap").published_at
  end

  test "edit form shows the publish time in the browser's time zone" do
    posts(:draft).update!(published_at: Time.utc(@day.year, 1, 11, 5))
    cookies["time_zone"] = "America/Los_Angeles"
    get "/admin/posts/#{posts(:draft).id}/edit"

    assert_select "input[name='post[published_at]'][value=?]", "#{@day}T21:00:00"
    assert_includes response.body, "Times are in America/Los Angeles (PST)"
  end

  test "a form keeps the zone it was shown in when the browser zone differs" do
    posts(:draft).update!(published_at: Time.utc(@day.year, 1, 11, 5))
    get "/admin/posts/#{posts(:draft).id}/edit"
    shown = css_select("input[name='post[published_at]']").first["value"]
    zone = css_select("input[name='time_zone']").first["value"]

    cookies["time_zone"] = "America/Los_Angeles"
    patch "/admin/posts/#{posts(:draft).id}", params: { time_zone: zone, post: { published_at: shown } }

    assert_equal Time.utc(@day.year, 1, 11, 5), posts(:draft).reload.published_at
  end

  test "summer times use daylight saving offsets" do
    cookies["time_zone"] = "America/Los_Angeles"
    create_post_at "#{@day.change(month: 7)}T21:00"

    assert_equal Time.utc(@day.year, 7, 11, 4), Post.find_by!(title: "Sunday recap").published_at
  end

  test "the browser time zone does not leak past the request" do
    cookies["time_zone"] = "Asia/Tokyo"
    get "/admin/posts"

    assert_equal Time.zone_default, Time.zone
  end

  private

  def create_post_at(published_at)
    post "/admin/posts", params: { post: { title: "Sunday recap", season_id: seasons(:last_season).id, published_at: published_at, content: "Hi" } }
  end
end
