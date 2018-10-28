class PostMailerPreview < ActionMailer::Preview
  def new
    PostMailer.with(post: Post.first, owners: [Administrator.first, Administrator.last]).new
  end
end
