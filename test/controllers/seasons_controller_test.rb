require 'test_helper'

class SeasonsControllerTest < ActionDispatch::IntegrationTest
  test "shows a season's posts and links to the next season" do
    get season_path(seasons(:last_season))

    assert_response :success
    assert_select "h2.season-name", "2024–25"
    assert_equal ["Champion Crowned"], css_select("section li a").map(&:text)
    assert_select "a.season-nav-next[href=?]", season_path(seasons(:this_season)), text: "2025–26 →"
    assert_select "a.season-nav-previous", false
  end

  test "a season with no published posts says so" do
    season = Season.create!(name: "2026–27", start_year: 2026)

    get season_path(season)

    assert_select ".season-empty", "No posts yet this season."
  end
end
