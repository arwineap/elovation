class ApiPlayerGamesController < ApiController
  def show
    @player = Player.find(params[:player_id])
    @game = Game.find(params[:id])
    @chart_data = @game.ratings
                      .where(player_id: @player.id)
                      .flat_map(&:history_events)
                      .map { |event| [event.created_at, event.value] }
    @json_data = Hash.new
    @json_data['player'] = Hash.new
    @json_data['player']['id'] = @player.id
    @json_data['player']['name'] = @player.name
    @json_data['chart_data'] = @chart_data
    @json_data['wins'] = 0
    @json_data['losses'] = 0
    @game.all_ratings.each { |x|
        @json_data['wins'] += @player.wins(@game, x.player)
        @json_data['losses'] += @player.results.losses.for_game(@game).against(x.player).size
    }
  end
end
