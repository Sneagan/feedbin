require 'test_helper'

class ThreaderTest < ActiveSupport::TestCase
  setup do
    user = users(:ben)
    @feed = user.feeds.first
    @parent_entry = @feed.entries.create!(threaded_entry)
  end

  test "should add thread" do
    entry_hash = threaded_entry(@parent_entry.thread_id)
    threader = Threader.new(entry_hash, @feed)
    assert(threader.thread)
    assert_equal(@parent_entry.reload.thread_id, entry_hash["thread_id"])
    assert_equal(@parent_entry.reload.thread.length, 1)
  end

  def threaded_entry(reply_to = nil)
    thread_id = Random.new().rand(10000)
    data = {
      "tweet" => {
        "id" => thread_id
      }
    }
    if reply_to
      data["tweet"]["in_reply_to_status_id"] = reply_to
    end
    {
      "thread_id" => thread_id,
      "public_id" => SecureRandom.hex,
      "content" => "<p>#{Faker::Lorem.paragraph}</p>",
      "data" => data
    }
  end

end
