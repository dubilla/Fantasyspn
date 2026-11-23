Trestle.resource(:seasons) do
  menu do
    item :seasons, icon: "fa fa-calendar"
  end

  collection do
    Season.newest_first
  end

  table do
    column :name, link: true
    column :start_year, align: :center
    column :posts, align: :center do |season|
      link_to season.posts.count, trestle.posts_admin_index_path(season_id: season.id)
    end
    actions
  end

  form do |season|
    text_field :name, help: "e.g. 2025–26"
    number_field :start_year, help: "Used to order seasons; the latest is the current season"
  end

  params do |params|
    params.require(:season).permit(:name, :start_year)
  end
end
