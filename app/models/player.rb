require 'csv'
class Player < ApplicationRecord
  belongs_to :league

  def self.to_csv
    columns_to_filter = ["created_at", "updated_at", "league_id", "id"]
    attributes = Player.column_names - ["created_at", "updated_at", "league_id", "id"] - columns_to_filter
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end
end
