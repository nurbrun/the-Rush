if League.count === 0
  puts "No leagues found in database. NFL is required for this example."
  league = League.create!(league_name: "NFL")
  puts "Created #{league.league_name}"
end

if Player.count === 0
  puts "There are no players in the database"
  league = League.find_by_league_name("NFL")
  path = File.join(File.dirname(__FILE__), "./data/rushing.json")
  players = JSON.parse(File.read(path))
  players.each do |player|
    if player["Lng"].class == Integer
      lng = player["Lng"]
      lng_t = false
    else
      lng = player["Lng"].downcase.split("t")[0]
      lng_t = player["Lng"].downcase.include?("t") ? true : false
    end


    Player.create!(
       player: player["Player"],
       team: player["Team"],
       pos: player["Pos"],
       att: player["Att"],
       attg: player["Att/G"],
       yds: player["Yds"],
       avg: player["Avg"],
       ydsg: player["Yds/G"],
       td: player["TD"],
       lng: lng,
       lng_t: lng_t,
       first: player["1st"],
       first_percent: player["1st%"],
       twenty_plus: player["20+"],
       forty_plus: player["40+"],
       fum: player["FUM"],
       league_id: league.id
      )
  end
  puts "Players seeded: #{Player.count}"
end
