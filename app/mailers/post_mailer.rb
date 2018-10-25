class PostMailer < ApplicationMailer
  def new
    @post = params[:post]
    @owner = params[:owner]
    mail(to: @owner.email, subject: @post.title)
  end
end
