class ResultsController < ApplicationController
  before_filter :_find_game

  def create
    response = ResultService.create(@game, params[:result])

    if response.success?
      redirect_to game_path(@game)
    else
      @result = response.result
      render :new
    end
  end

  def create_31
    response = ResultService.create_31(@game, params)

    if response.success?
      redirect_to game_path(@game)
    else
      @result = response.result
      render :new_31
    end
  end

  def destroy
    result = @game.results.find_by_id(params[:id])

    response = ResultService.destroy(result)

    redirect_to :back
  end

  def new
    @result = Result.new
  end

  def new_31
    @result = Result.new
    @result.result_infos.push(ResultInfo.new)
    @result.result_infos.push(ResultInfo.new)
  end

  def _find_game
    @game = Game.find(params[:game_id])
  end
end
