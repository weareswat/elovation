class Game < ActiveRecord::Base
  has_many :ratings, :dependent => :destroy
  has_many :results, :dependent => :destroy

  validates :name, :presence => true

  def all_ratings
    ratings.order("value DESC")
  end

  def table_ratings
    Player.find_by_sql("
        select *, 
          total_points/total_games as avg
        from (
            select player_id,
                sum(points) as total_points,
                count(id) as total_games,
                sum(case when won then 1 else 0 end) as victories,
                sum(case when won then 0 else 1 end) as losses
            from result_infos
            group by result_infos.player_id
        ) as infos
        inner join players on players.id = infos.player_id
        inner join ratings on ratings.player_id = infos.player_id
        where ratings.game_id = #{self.id}
        order by ratings.value desc
    ")
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
