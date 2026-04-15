require "httparty"
require "json"

class NewsMnApiScraper
  BASE_URL = "https://news.mn/wp-json/wp/v2/posts"

  def initialize
    @headers = {
      "User-Agent" => "Mozilla/5.0"
    }
  end

  def scrape(pages = 5)
    puts "news.mn WordPress API-с мэдээ татаж байна..."
    all_articles = []

    (1..pages).each do |page|
      puts "#{page}-р хуудас татаж байна..."
      
      response = HTTParty.get(
        "#{BASE_URL}?per_page=20&page=#{page}",
        headers: @headers
      )

      break if response.code != 200

      posts = JSON.parse(response.body)
      break if posts.empty?

      posts.each do |post|
        all_articles << {
          id: post["id"],
          title: post["title"]["rendered"],
          link: post["link"],
          date: post["date"],
          scraped_at: Time.now.to_s
        }
      end

      sleep(1)
    end

    all_articles
  end

  def save(articles)
    File.write("api-news.json", JSON.pretty_generate(articles))
    puts "\nНийт #{articles.length} мэдээг api-news.json файлд хадгаллаа!"
  end
end

scraper = NewsMnApiScraper.new
articles = scraper.scrape(5)
scraper.save(articles)