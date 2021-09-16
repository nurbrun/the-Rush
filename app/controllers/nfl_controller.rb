class NflController < ApplicationController
  def rushing
    nfl_id = League.find_by_league_name("NFL")
    permitted_sorts = ["yds","td","lng","ASC","DESC"]
    sort_params = player_params[:sort]
    dir_params = player_params[:dir]
    count_params = player_params[:count]
    csv_params = player_params[:csv]
    pagination_value = 50
    player_search = nil
    sanitized_sort_params = permitted_sorts.include?(sort_params) ? sort_params.to_sym : nil
    sanitized_dir_params = permitted_sorts.include?(dir_params) ? dir_params : "DESC"
    sanitized_count_params = count_params ? count_params.to_i : 50
    sanitized_csv_params = csv_params ? csv_params : 0
    # query 1: filter by player if params exist
    if player_params[:player]
      player = player_params[:player]
      player_search = Player.where(:league_id => nfl_id).where("LOWER(player) like ?", "%#{player.strip.downcase}%")
      @players = player_search ? player_search : Player.where(:league_id => nfl_id)
    else 
      @players = Player.where(:league_id => nfl_id)
    end
    # query 2: sort by column if params exist
    if sanitized_dir_params != nil
      if sanitized_dir_params === "DESC"
        @players = @players.order(sanitized_sort_params).reverse
      else
        @players = @players.order(sanitized_sort_params)
      end
    end
    # query 3: limit results to paginiation_value, unless .csv request
    if sanitized_csv_params === 0
      raw_player_count = @players.count
      @players = @players.first(sanitized_count_params).last(pagination_value)
      last_page = 0
      next_page = pagination_value * 2
      if request.fullpath === "/"
        # use default pagination values
        @last_page_url = "?&count=#{last_page}"
        @next_page_url = "?&count=#{next_page}" 
      elsif count_params
        # current pagination active, increase/decrease link params for next load
        new_path_array = []
        request.fullpath.split("&").map{ |path| 
          if path.include? "count"
            last_page = count_params.to_i - pagination_value
            next_page = count_params.to_i + pagination_value
          else
            new_path_array << path
          end
        }
        new_base_path = new_path_array.join('&')
        @last_page_url = "#{new_base_path}&count=#{last_page}"
        @next_page_url = "#{new_base_path}&count=#{next_page}"  
      else
        # params are present, but pagination is inactive, use default pagination values
        @last_page_url = "#{request.fullpath}&count=#{last_page}"
        @next_page_url = "#{request.fullpath}&count=#{next_page}"  
      end
      @hide_last = last_page < 1 ? true : false
      @hide_next = next_page > (raw_player_count+pagination_value) ? true : false
    end
    respond_to do |format|
      format.html 
      format.csv { send_data Player.to_csv(@players), filename: "theRush-#{Date.today}#{sanitized_sort_params ? "-#{sanitized_sort_params}-#{sanitized_dir_params.downcase}" : ""}#{player_params[:player].empty? ? "" :  "-#{player_params[:player]}" }.csv" }
    end
  end
  private
  def player_params
    params.permit(:player, :count, :csv, :dir, :sort)
  end
end