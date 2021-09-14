class NflController < ApplicationController
  def rushing
    nfl_id = League.find_by_league_name("NFL")
    permitted_sorts = ["yds","td","lng","ASC","DESC"]
    sort_params = params[:sort]
    dir_params = params[:dir]
    sanitized_sort_params = permitted_sorts.include?(sort_params) ? sort_params.to_sym : nil
    sanitized_dir_params = permitted_sorts.include?(dir_params) ? dir_params : "DESC"
    player_search = nil
    if player_params[:player]
      player_search = Player.where(:league_id => nfl_id).where("LOWER(player) like ?", "%#{player_params[:player].strip.downcase}%")
      @players = player_search ? player_search : Player.where(:league_id => nfl_id)
    else 
      @players = Player.where(:league_id => nfl_id)
    end
    if sanitized_sort_params != nil
      if sanitized_dir_params === "DESC"
        @players = @players.order(sanitized_sort_params).reverse
      else
        @players = @players.order(sanitized_sort_params)
      end
    end
    respond_to do |format|
      format.html
      format.csv { send_data Player.to_csv(@players), filename: "theRush-#{Date.today}#{sanitized_sort_params ? "-#{sanitized_sort_params}-#{sanitized_dir_params.downcase}" : ""}#{player_params[:player].empty? ? "" :  "-#{player_params[:player]}" }.csv" }
    end
  end
  private
  def player_params
    params.permit(:player)
  end
end