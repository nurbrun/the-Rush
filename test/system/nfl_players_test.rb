require 'application_system_test_case'

class NflPlayersTest < ApplicationSystemTestCase
  def setup
    @default_dir = "DESC"
    @toggled_dir = "ASC"
    @pagination_value = 50
  end
  test 'visit players page' do
    visit players_url
    assert_selector 'form#player-form'
    assert_selector 'table#players-table'
    assert_selector 'a#csv-download'
  end
  test 'display all players' do
    visit players_url
    sort_results = []
    all_player_fixtures = Player.all.reverse.map{|player| player.player}
    paginated_query = all_player_fixtures.first(@pagination_value)
    page_results = all('td.player').count
    all('td.player').each do |td|
      sort_results << td.text
    end
    assert_equal paginated_query, sort_results, "All players are displayed"
    find('a#csv-download').click
    sleep 1
    validate_csv_match("","","", all_player_fixtures)
  end
  test 'filter table/csv by players' do 
    search_term = 'Joe'
    sort_results = []
    visit players_url
    puts players_url
    fill_in 'player', with: search_term
    click_button 'player-filter'
    all('td.player').each do |td|
      sort_results << td.text
      assert_text(search_term)
    end
    find('a#csv-download').click
    sleep 1
    validate_csv_match("","DESC", search_term, sort_results)
  end
  test 'filter and sort table/csv by players' do 
    search_term = 'Joe'
    sort_results = []
    visit players_url
    puts players_url
    fill_in 'player', with: search_term
    click_button 'player-filter'
    find('a#yds-sort').click
    sleep 1
    sort_results = []
    all('td.player').each do |td|
      sort_results << td.text
      assert_text(search_term)
    end
    find('a#csv-download').click
    sleep 1
    validate_csv_match("yds","DESC", search_term, sort_results)
  end
  test 'sort table/csv by yds' do
    sort_results = []
    visit players_url
    find('a#yds-sort').click
    sleep 1
    sorted_fixtures_by_yds = Player.all.order(:yds).reverse
    paginated_query = sorted_fixtures_by_yds.first(@pagination_value).map{|player| player.yds}
    yds_players_result = sorted_fixtures_by_yds.map{|player| player.player}
    all('td.yds').each do |td|
      sort_results << td.text.to_i 
    end
    assert_equal paginated_query, sort_results, "Array sorted"
    find('a#csv-download').click
    sleep 1
    validate_csv_match("yds","DESC", "", yds_players_result)
  end
  test 'sort table/csv by td' do
    sort_results = []    
    visit players_url
    find('a#td-sort').click
    sleep 1
    sorted_fixtures_by_td = Player.all.order(:td).reverse
    paginated_query = sorted_fixtures_by_td.first(@pagination_value).map{|player| player.td}
    td_players_result = sorted_fixtures_by_td.map{|player| player.player}
    all('td.td').each do |td|
      sort_results << td.text.to_i 
    end
    assert_equal paginated_query, sort_results, "Array sorted"
    find('a#csv-download').click
    sleep 1
    validate_csv_match("td","DESC", "", td_players_result)
  end
  test 'sort table/csv by lng' do
    sort_results = []
    visit players_url
    find('a#lng-sort').click
    sleep 1
    sorted_fixtures_by_lng = Player.all.order(:lng).reverse
    paginated_query = sorted_fixtures_by_lng.first(@pagination_value).map{|player| player.lng}
    lng_players_result = sorted_fixtures_by_lng.map{|player| player.player}
    all('td.lng').each do |td|
      sort_results << td.text.to_i 
    end
    assert_equal paginated_query, sort_results, "Array sorted"
    find('a#csv-download').click
    sleep 1
    validate_csv_match("lng","DESC", "", lng_players_result)
  end
  test 'all sort directions are descending by default' do
    visit players_url
    all('a.sort-link').each do |link|
      sort_dir = link["href"].split("?")[1].split("&")[0].split("=")[1]
      assert_equal @default_dir, sort_dir
    end
  end
  test 'only yds link sort direction toggles when active' do
    active_sort = "yds"
    inactive_sorts = ["td","lng"]
    visit "#{players_url}?dir=#{@default_dir}&sort=#{active_sort}"
    test_toggles(active_sort, inactive_sorts)
  end
  test 'only td link sort direction toggles when active' do
    active_sort = "td"
    inactive_sorts = ["yds","lng"]
    visit "#{players_url}?dir=#{@default_dir}&sort=#{active_sort}"
    test_toggles(active_sort, inactive_sorts)
  end
  test 'only lng link sort direction toggles when active' do
    active_sort = "lng"
    inactive_sorts = ["yds","td"]
    visit "#{players_url}?dir=#{@default_dir}&sort=#{active_sort}"
    test_toggles(active_sort, inactive_sorts)
  end
  test 'cannot sort by non permitted searches' do
    sort_results = []
    non_permitted_sort = "player"
    visit "#{players_url}?dir=#{@default_dir}&sort=#{non_permitted_sort}"
    all('td.player').each do |td|
      sort_results << td.text 
    end
    sorted_player_fixtures = Player.all.order(:player).reverse.map{|player| player.player}
    assert_not_equal sorted_player_fixtures, sort_results
  end
  test 'cannot filter by non permitted search' do
    sort_results = []
    non_permitted_filter = "td"
    non_permitted_value = 0
    visit "#{players_url}?#{non_permitted_filter}=#{non_permitted_value}"
    all('td.player').each do |td|
      sort_results << td.text 
    end
    sorted_player_fixtures = Player.all.where(non_permitted_filter.to_sym => non_permitted_value)
    assert_not_equal sorted_player_fixtures, sort_results
  end
end