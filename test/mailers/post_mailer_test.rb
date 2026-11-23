require 'test_helper'

class PostMailerTest < ActionMailer::TestCase
  test "emails the post to every owner and marks it sent" do
    post = posts(:published)

    email = PostMailer.with(post: post).new

    assert_equal ["alice@example.com", "bob@example.com"].sort, email.to.sort
    assert_equal "NBANHBL: Trade Deadline Recap", email.subject
    assert_includes email.html_part.body.to_s, "Three trades went through."
    email.deliver_now
    assert_not_nil post.reload.sent_at
  end

  test "marks a post without a season as sent" do
    post = posts(:published)
    post.update_column(:season_id, nil)

    PostMailer.with(post: post).new.deliver_now

    assert_not_nil post.reload.sent_at
  end
end
