module DownloadTestHelper
  PATH = Rails.root.join('tmp/downloads')
private
  def downloads
    Dir[PATH.join('*')]
  end

  def download(test_sort, test_dir, test_filter)
    path = "theRush-#{Date.today}#{test_sort.empty? ? "" : "-#{test_sort}-#{test_dir.downcase}"}#{test_filter.empty? ? "" :  "-#{test_filter}" }.csv"
    download_url = ""
    downloads.each do |download|
      if download.include? path
        download_url = download
      end
    end
    download_url
  end

  def clear_downloads
    FileUtils.rm_f(downloads)
  end
end