class RatingInfo << ActiveRecord::Base
  belongs_to :player
  belongs_to :rating
end
