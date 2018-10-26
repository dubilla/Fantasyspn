class PostMailerPreview < ActionMailer::Preview
  def new
    PostMailer.with(post: Post.first, owner: Administrator.first).new
  end
end
