class PostMailer < ApplicationMailer
  def new
    @post = params[:post].decorate
    @owners = params[:owners]
    mail(to: @owners.map(&:email), subject: @post.title)
  end
end
