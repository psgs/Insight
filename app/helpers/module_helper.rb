module ModuleHelper

  def self.get_ex(url, symbol)
    begin
      open(url) do |d|
        json = JSON.parse(d.read)
        json.each do |a|
          a.each do |k, v|
            if k == 'symbol' and v == symbol
              return true, a
            end
          end
        end
        return false, 'bity Error: Symbol not found in BitCoin API.'
      end
    rescue SocketError => e
      return false, 'bity Error: Could not connect to BitCoin Charts API.'
    end
  end

  def self.get_bitcoin
    body = JSON.parse(open('https://www.bitstamp.net/api/ticker/', {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read)
    print body
    return body['high']
  end

  def self.get_currency(code)
    Money::Bank::GoogleCurrency.ttl_in_seconds = 300
    Money.default_bank = Money::Bank::GoogleCurrency.new
    money = Money.new(1_00, code) # Amount is in cents
    money.exchange_to(:AUD)
  end

  def self.get_news(year, month, day)
    uri = URI.encode('http://en.wikipedia.org/w/api.php?format=json&action=query&titles=Portal:Current_events/' + year + '_' + month + '_' + day + '&prop=revisions&rvprop=content')
    body = Net::HTTP.get(URI.parse(uri))
    text = body.match(/<!-- All news items below this line -->(.*)<!-- All news items above this line -->/m)[1].strip
    text_two = text.gsub('[[', '')
    text_three = text_two.gsub(']]', '')
    text_four = text_three.gsub('\n**', ':<br>')
    text_five = text_four.gsub('\n;', '<h3>')
    return text_five.gsub('\n*', '</h3>')
  end
end