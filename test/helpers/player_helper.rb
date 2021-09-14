module PlayerTestHelper
private

  def test_toggles(active_sort, inactive_sorts)
    expected_href = "#{players_url}?dir=#{@toggled_dir}&sort=#{active_sort}"
    inactive_sorts.each do |inactive_sort|
      expected_inactive_href = "#{players_url}?dir=#{@default_dir}&sort=#{inactive_sort}"
      generated_inactive_href = find("a##{inactive_sort}-sort")["href"] 
      assert_equal expected_inactive_href, generated_inactive_href
    end
    generated_href = find("a##{active_sort}-sort")["href"]
    assert_equal expected_href, generated_href
  end

  def validate_csv_match(test_sort, test_dir, test_filter, sort_results)
    downloaded_csv = CSV.parse(File.read(download(test_sort, test_dir, test_filter)), headers: true)
    csv_players = downloaded_csv.by_col["player"]
    assert_equal csv_players, sort_results
  end

end