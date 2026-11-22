require 'test_helper'

class SendPostsJobTest < ActiveJob::TestCase
  test "queues an email for each published, unsent post" do
    assert_enqueued_jobs 1, queue: "mailers" do
      SendPostsJob.perform_now
    end
  end
end
