class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true, uniqueness: {case_sensitive: false}

  def self.new_lookup(ticker_symbol)
    client = IEX::Api::Client.new(publishable_token: Rails.application.credentials.iex_client[:sandbox_api_publishable_token],
                                  secret_token: Rails.application.credentials.iex_client[:sandbox_api_secret_token],
                                  endpoint: 'https://sandbox.iexapis.com/v1')
    begin
      new(ticker: ticker_symbol.upcase, name: client.company(ticker_symbol.upcase).company_name, last_price: client.price(ticker_symbol.upcase))
    rescue => exception
      return nil
    end
  end

  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol.upcase).first
  end

end
