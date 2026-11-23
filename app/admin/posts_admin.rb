Trestle.resource(:posts) do
  menu do
    item :posts, icon: "fa fa-file-text-o"
  end

  collection do |params|
    posts = Post.includes(:season).order(published_at: :desc)
    case params[:season_id]
    when nil, "" then posts
    when "none" then posts.where(season_id: nil)
    else posts.where(season_id: params[:season_id])
    end
  end

  build_instance do |attrs|
    Post.new({ season: Season.current }.merge(attrs))
  end

  table do
    column :title, link: true
    column :season do |post|
      link_to post.season.name, trestle.posts_admin_index_path(season_id: post.season_id) if post.season
    end
    column :updated_at, header: "Last Updated", align: :center
    column :published_at
    actions
  end

  form do |post|
    tab :post do
      text_field :title
      collection_select :season_id, Season.newest_first, :id, :name, include_blank: post.season_id.nil?
      datetime_field :published_at
      editor :content
      form_group :image do
        concat image_tag(Rails.application.routes.url_helpers.rails_blob_path(instance.header_image, only_path: true)) if instance.header_image.attached?
        raw_file_field :header_image
      end
    end
  end

  params do |params|
    params.require(:post).permit(:title, :season_id, :published_at, :content, :header_image)
  end
end
