require 'test_helper'

class SeasonTest < ActiveSupport::TestCase
  test "current is the season with the latest start year" do
    assert_equal seasons(:this_season), Season.current
  end

  test "previous and next follow start year" do
    assert_equal seasons(:last_season), seasons(:this_season).previous
    assert_equal seasons(:this_season), seasons(:last_season).next
    assert_nil seasons(:last_season).previous
    assert_nil seasons(:this_season).next
  end

  test "requires a name and a unique start year" do
    season = Season.new(start_year: seasons(:this_season).start_year)

    assert_not season.valid?
    assert season.errors.added?(:name, :blank)
    assert season.errors.added?(:start_year, :taken, value: seasons(:this_season).start_year)
  end

  test "can't be deleted while it has posts" do
    season = seasons(:last_season)

    assert_not season.destroy
    assert Season.exists?(season.id)
  end
end
