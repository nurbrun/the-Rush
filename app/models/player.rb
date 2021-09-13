require 'csv'
class Player < ApplicationRecord
  belongs_to :league

  def self.to_csv(players)
    columns_to_filter = ["created_at", "updated_at", "league_id", "id"]
    attributes = Player.column_names - ["created_at", "updated_at", "league_id", "id"] - columns_to_filter
    CSV.generate(headers: true) do |csv|
      csv << attributes
      players.each do |player|
        csv << attributes.map{ |attr| player.send(attr) }
      end
    end
  end

  def search_players
    if @player = Player.all.find{|player| player.name.include?(params[:search])}
      redirect_to player_path(@player)
    end
  end

end
