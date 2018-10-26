class SendUnsentPublishedPostsJob < ApplicationJob
  queue_as :default

  def perform
    Post.published.unsent.map do |p|
      PostMailer.with(post: p, owner: Administrator.first).new.deliver_later
    end
  end
end
