class PostMailer < ApplicationMailer
  def new
    @post = params[:post].decorate
    @owners = Owner.all
    mail(to: @owners.map(&:email), subject: "NBANHBL: #{@post.title}")
    @post.update_column(:sent_at, Time.current)
  end
end
