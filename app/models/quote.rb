class Quote < ApplicationRecord

  ApiKey = "PUDO6FISMN2FU948"

  def self.get(ticker, date)
    quote = find_most_recent(ticker, date)
    if quote.nil?
      Quote.fetch(ticker)
      quote = find_most_recent(ticker, date)
    end
    quote
  end

  def self.find_most_recent(ticker, date)
    Quote.where("ticker = ? and date <= ?", ticker, date).order(date: :desc).first
  end

  def self.fetch(ticker)

    # Fetch daily quotes from AlphaAdvantage
    url = "https://www.alphavantage.co/query"
    begin
      response = RestClient.get url,
                                :content_type => :json,
                                :params => {
                                  :function => "TIME_SERIES_DAILY_ADJUSTED",
                                  :symbol => ticker,
                                  :apikey => ApiKey}
      json = JSON.parse(response)
      ts_data = json["Time Series (Daily)"]

      unless ts_data.nil?
        ts_data.keys.each do |date|
          data = ts_data[date]

          q = Quote.new do |q|
            q.ticker = ticker
            q.date = date
            q.open = data["1. open"]
            q.high = data["2. high"]
            q.low = data["3. low"]
            q.close = data["4. close"]
            q.adjusted_close = data["5. adjusted close"]
            q.volume = data["6. volume"]
            q.dividend = data["7. dividend amount"]
            q.split_coefficient = data["8. split coefficient"]
          end
          q.save
        end
      else
        Quote.blacklist(ticker)
      end
    rescue RestClient::ServiceUnavailable
      # Log something here
      print "Service Unavailable: %s" % url
    end
  end

  # Create a quote with null values
  def self.blacklist(ticker)
    q = Quote.new do |q|
      q.ticker = ticker
      q.date = Date.today
    end
    q.save
  end
end
