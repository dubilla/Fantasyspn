class PostMailer < ApplicationMailer
  def new
    @post = params[:post].decorate
    @owners = Owner.all
    mail(to: @owners.map(&:email), subject: @post.title)
    @post.update_attributes(sent_at: DateTime.now)
  end
end
