class CreateUserStocks < ActiveRecord::Migration[6.0]
  def change
    create_table :user_stocks do |t|
      t.resources :user, null: false, foreign_key: true
      t.resources :stock, null: false, foreign_key: true

      t.timestamps
    end
  end
end
