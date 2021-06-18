class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name
    "Anonymous"
  end

  def under_stock_limit?
    stocks.count < 10
  end

  def already_track_stock?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol.upcase)
    return false unless stock
    stocks.where(id: stock.id).exists?
  end

  def can_track_stock?(ticker_symbol)
    under_stock_limit? && !already_track_stock?(ticker_symbol)
  end

  def self.check_db(email)
    where(email: email.downcase).first
  end

end
