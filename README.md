# News.mn Scraper (Ruby)

A Ruby web scraping project that collects news articles from [news.mn](https://news.mn), one of Mongolia's leading news websites. This project demonstrates three different scraping approaches using Ruby.

## Features

- Three different scraping techniques in one project
- Collects news titles, links, and timestamps
- Removes duplicate articles automatically
- Saves results to JSON files
- Pagination support for collecting more articles

## Scraping Approaches

### 1. HTTParty + Nokogiri (Static Scraper)
Fetches the homepage HTML and parses it using Nokogiri — Ruby's most popular HTML parsing library. Simple and lightweight approach for statically rendered content.

**Result:** 4 articles from the homepage

### 2. WordPress REST API
News.mn is built on WordPress, which exposes a built-in REST API at `/wp-json/wp/v2/posts`. By calling this endpoint directly, we can fetch clean, structured JSON data without any HTML parsing.

**Result:** 100 articles across 5 pages

### 3. HTTParty + Nokogiri + Pagination
An improved version of the first approach that iterates through multiple pages (`/page/2`, `/page/3`, etc.) to collect more articles.

**Result:** 68 articles across 5 pages

## Tech Stack

- **Runtime:** Ruby 3.2.0
- **HTTP Client:** HTTParty
- **HTML Parser:** Nokogiri
- **Data Storage:** JSON files

## Getting Started

### Prerequisites

- Ruby 3.2.0 or higher
- Bundler

### Installation

1. Clone the repository

```bash
git clone https://github.com/Usukhbayar418/news-mn-scraper.git
cd news-mn-scraper
```

2. Install dependencies

```bash
gem install httparty nokogiri
```

### Usage

Run the Nokogiri scraper:
```bash
ruby scraper1_nokogiri.rb
```

Run the WordPress API scraper:
```bash
ruby scraper2_api.rb
```

Run the pagination scraper:
```bash
ruby scraper3_pagination.rb
```

## Output

Each scraper saves results to a JSON file:

- `scraper1_nokogiri.rb` → `nokogiri-news.json`
- `scraper2_api.rb` → `api-news.json`
- `scraper3_pagination.rb` → `pagination-news.json`

Example output:

```json
{
  "id": 2861185,
  "title": "Монгол хэл, бичгийн шалгалтын сэдвүүдийг нээлттэй зарладаг болно",
  "link": "https://news.mn/r/2861185/",
  "date": "2026-04-16T00:30:00",
  "scraped_at": "2026-04-16 00:43:50 +0800"
}
```

## Comparison

| Approach | Articles | Speed | Complexity |
|---|---|---|---|
| Nokogiri (homepage) | 4 | Fast | Simple |
| WordPress REST API | 100 | Fast | Simple |
| Nokogiri + Pagination | 68 | Medium | Medium |

## Key Learnings

- HTML parsing with Nokogiri and CSS selectors
- Discovering and using hidden REST API endpoints
- Pagination handling for collecting more data
- Ruby HTTP requests with HTTParty
- Difference between static and API-based scraping

## License

MIT