require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  test "vote must have a user" do
    u1 = User.first
    u2 = User.last
    p = Post.new(:user => u1, :data => "post from u")
    p.save

    v = Vote.new(:post => p)
    assert ! v.valid?

    v.user = u2
    assert v.valid?
  end

  test "vote must have a post" do
    u1 = User.first
    u2 = User.last
    p = Post.new(:user => u1, :data => "post from u")
    p.save

    v = Vote.new(:user => u2)
    assert ! v.valid?

    v.post = p
    assert v.valid?
  end

  test "cant vote on own post" do
    # Make two users.
    u1 = User.first
    u2 = User.last

    # User 1 creates a post.
    p = Post.new(:user => u1, :data => "post from u1")
    p.save

    # User 1 should not be able to vote the post.
    vfail = Vote.new(:user => u1, :post => p)
    assert ! vfail.valid?

    # User 2 should be able to vote the post.
    vpass = Vote.new(:user => u2, :post => p)
    assert vpass.valid?
  end

  test "can only vote once" do
    u1 = User.first
    u2 = User.last

    p = Post.new(:user => u1, :data => "post from u1")
    p.save

    vpass = Vote.new(:user => u2, :post => p)
    assert vpass.valid?
    vpass.save

    vfail = Vote.new(:user => u2, :post => p)
    assert ! vfail.valid?
  end
end
