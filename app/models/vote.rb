class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  # Validation
  # Both the user and post are required to make a vote.
  validates :user_id, :presence => true
  validates :post_id, :presence => true

  # A user cannot vote on the same post more than once.
  validates :user_id, :uniqueness => { :scope => :post_id }

  # The person casting the vote cannot be the author of the post.
  validate :voter_cant_be_author
  def voter_cant_be_author
    tpost = Post.find(post_id)
    if tpost.user_id == user_id
      errmsg = "You can't vote on your own "
      errmsg += tpost.post_id ? "reply." : "post."
      errors.add(:base, errmsg)
    end
  end

  def self.has_voted?(userid)
    return where('user_id = ?', userid).count[0] > 0 ? true : false
  end

end
