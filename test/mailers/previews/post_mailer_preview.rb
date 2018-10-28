class PostMailerPreview < ActionMailer::Preview
  def new
    PostMailer.with(post: Post.first).new
  end
end
