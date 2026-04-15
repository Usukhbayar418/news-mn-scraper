require "httparty"
require "nokogiri"
require "json"

class NewsMnNokogiriScraper
  BASE_URL = "https://news.mn"

  def initialize
    @headers = {
      "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    }
  end

  def scrape
    puts "news.mn-с мэдээ татаж байна (Nokogiri)..."

    response = HTTParty.get(BASE_URL, headers: @headers)

    if response.code != 200
      puts "Алдаа: #{response.code}"
      return []
    end

    doc = Nokogiri::HTML(response.body)
    articles = []

    doc.css("h2.entry-title a, h3.entry-title a").each do |link|
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

    articles.uniq { |a| a[:link] }
  end

  def save(articles)
    File.write("nokogiri-news.json", JSON.pretty_generate(articles))
    puts "Нийт #{articles.length} мэдээг nokogiri-news.json файлд хадгаллаа!"
  end
end

scraper = NewsMnNokogiriScraper.new
articles = scraper.scrape
scraper.save(articles)