class PostMailer < ApplicationMailer
  def new
    @post = params[:post].decorate
    @owner = params[:owner]
    mail(to: @owner.email, subject: @post.title)
  end
end
