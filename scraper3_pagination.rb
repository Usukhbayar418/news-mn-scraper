require "httparty"
require "nokogiri"
require "json"

class NewsMnPaginationScraper
  BASE_URL = "https://news.mn"

  def initialize
    @headers = {
      "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    }
  end

  def scrape_page(page = 1)
    url = page == 1 ? BASE_URL : "#{BASE_URL}/page/#{page}"
    puts "#{page}-р хуудас татаж байна: #{url}"

    response = HTTParty.get(url, headers: @headers)
    return [] if response.code != 200

    doc = Nokogiri::HTML(response.body)
    articles = []

    doc.css(".entry-title a").each do |link|
      title = link.text.strip
      href = link["href"]

      next if title.empty?
      next if href.nil?
      next if title.length < 10

      articles << {
        title: title,
        link: href.start_with?("http") ? href : "#{BASE_URL}#{href}",
        scraped_at: Time.now.to_s
      }
    end

    articles
  end

  def scrape(pages = 5)
    all_articles = []

    (1..pages).each do |page|
      articles = scrape_page(page)
      break if articles.empty?
      all_articles.concat(articles)
      sleep(1)
    end

    all_articles.uniq { |a| a[:link] }
  end

  def save(articles)
    File.write("pagination-news.json", JSON.pretty_generate(articles))
    puts "\nНийт #{articles.length} мэдээг pagination-news.json файлд хадгаллаа!"
  end
end

scraper = NewsMnPaginationScraper.new
articles = scraper.scrape(5)
scraper.save(articles)