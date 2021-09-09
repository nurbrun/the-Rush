class NflController < ApplicationController

  def rushing
    sort_params = params[:sort]
    dir_params = params[:dir]
    permitted_sorts = ["yds","td","lng","ASC","DESC"]
    sanitized_sort_params = permitted_sorts.include?(sort_params) ? sort_params : nil
    sanitized_dir_params = permitted_sorts.include?(dir_params) ? dir_params : "ASC"
    nfl_id = League.find_by_league_name("NFL")
    if sanitized_sort_params === nil
      @players = Player.where(:league_id => nfl_id)
    else
      @players = Player.where(:league_id => nfl_id).order("#{sanitized_sort_params} #{sanitized_dir_params}")
    end
    respond_to do |format|
      format.html
      format.csv { send_data @players.to_csv, filename: "theRush-#{Date.today}.csv" }
    end
  end

end
