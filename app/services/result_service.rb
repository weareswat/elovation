class ResultService


  def self.create_31(game, params)
    players = []
    params[:result][:result_info].each do |data|
      player = Player.find(data[:player_id])
      players.push player 
    end

    result = game.results.build(
      :players => players
    )

    params[:result][:result_info].each do |data|
      result.result_infos.build(data) if data[:player_id].present?
    end

    sorted = result.result_infos.map{|info| { 
      :info => info, 
      :player_id => info.player_id, 
      :points => info.points, 
      :tie_breaker => info.tie_breaker
    }}
    sorted.sort do |a, b|
      if a[:tie_breaker].present? && b[:tie_breaker].present?
        b[:tie_breaker] <=> a[:tie_breaker]
      else
        b[:points] <=> a[:points]
      end
    end
    sorted.reverse!
    result.winner_id = sorted.first[:player_id]
    result.loser_id = sorted.last[:player_id]
    sorted.first[:info].won = true

    if result.valid?
      Result.transaction do
        RatingService.update(game, result.winner, result.loser)
        result.save!

        OpenStruct.new(
          :success? => true,
          :result => result
        )
      end
    else
      OpenStruct.new(
        :success? => false,
        :result => result
      )
    end
  end

  def self.create(game, params)
    players = []
    begin
      players.push Player.find(params[:winner_id])
      players.push Player.find(params[:loser_id])
    rescue ActiveRecord::RecordNotFound
    end

    result = game.results.build(
      :winner_id => params[:winner_id],
      :loser_id => params[:loser_id],
      :players => players
    )

    if result.valid?
      Result.transaction do
        RatingService.update(game, result.winner, result.loser)
        result.save!

        OpenStruct.new(
          :success? => true,
          :result => result
        )
      end
    else
      OpenStruct.new(
        :success? => false,
        :result => result
      )
    end
  end

  def self.destroy(result)
    return OpenStruct.new(:success? => false) unless result.most_recent?

    Result.transaction do
      [result.winner, result.loser].each do |player|
        player.rewind_rating!(result.game)
      end

      result.destroy

      OpenStruct.new(:success? => true)
    end
  end
end
