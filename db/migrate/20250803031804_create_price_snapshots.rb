class CreatePriceSnapshots < ActiveRecord::Migration[8.0]
  def change
    create_table :price_snapshots do |t|
      t.references :currency, null: false, foreign_key: true
      t.decimal :last
      t.decimal :bid
      t.decimal :ask
      t.datetime :captured_at

      t.timestamps
    end
  end
end
