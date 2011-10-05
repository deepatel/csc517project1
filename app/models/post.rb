class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  has_many :votes

  # Validation
  # Author of the post is required.
  validates :user_id, :presence => true

  # The post must contain some data.
  validates :data, :presence => true

  # Make sure that if this is supposed to be a reply that the post being replied
  # to is actually valid.
  validate :post_id_must_be_valid
  def post_id_must_be_valid
    if ! post_id.nil? and ! Post.find(post_id)
      errors.add(:base, "The post you want to reply to is invalid.")
    end
  end

  # Ensure that if this is a reply, it is not for a reply.
  validate :reply_cannot_be_to_a_reply
  def reply_cannot_be_to_a_reply
    if ! post_id.nil? and ! Post.find(post_id).post_id.nil?
      errors.add(:base, "You cannot reply to a reply, only to the original post.")
    end
  end

  def replies
    Post.where('post_id = ?', id).order('created_at')
  end

  def self.not_replies
    where('post_id IS NULL').order('created_at DESC')
  end

  def self.search(searchtype, searchquery)
    if searchtype == "user"
      joins("JOIN users ON user_id=users.id").where('name like ?', "%#{searchquery}%")
    elsif searchtype == "content"
      postids = []
      where('data like ?', "%#{searchquery}%").each do |p|
        if p.post_id != nil
          postids.push p.post_id
        else
          postids.push p.id
        end
      end
      where(:id => postids)
    end
  end

  def self.top
    where('post_id IS NULL')
  end

  def score_me(max_today)
    current_time = Time.new
    current_min = current_time.to_i/60
    current_date = current_time.localtime.to_date()

    if (self.created_at.localtime.to_date()!= current_date)  then
      self.score_total = self.votes.size

    else
      temp = 80 - (current_min - self.created_at.to_i/60)
      score_create = [temp,0].max

      temp2 = 80 - (current_min - self.updated_at.to_i/60)
      score_modify = ([temp2,0].max)/2

      if (max_today > 0 )
        score_votes = self.votes.size * 40 / max_today
      else
        score_votes = self.votes.size
      end

      self.score_total = score_create + score_modify + score_votes
    end

  end

end
