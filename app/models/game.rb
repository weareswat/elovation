class Game < ActiveRecord::Base
  has_many :ratings, :dependent => :destroy
  has_many :results, :dependent => :destroy

  validates :name, :presence => true

  def all_ratings
    ratings.order("value DESC")
  end

  def as_json(options = {})
    {
      :name => name,
      :ratings => top_ratings.map(&:as_json),
      :results => recent_results.map(&:as_json)
    }
  end

  def players
    ratings.map(&:player)
  end

  def recent_results
    results.order("created_at DESC").limit(15)
  end

  def top_ratings
    ratings.order("value DESC").limit(15)
  end
end
