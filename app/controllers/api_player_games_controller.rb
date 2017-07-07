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
    @json_data['all_ratings'] = @game.all_ratings
  end
end
