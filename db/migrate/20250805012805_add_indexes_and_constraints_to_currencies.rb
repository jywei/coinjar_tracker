class AddIndexesAndConstraintsToCurrencies < ActiveRecord::Migration[8.0]
  def change
    # Add null constraints
    change_column_null :currencies, :name, false
    change_column_null :currencies, :symbol, false
    
    # Add unique indexes
    add_index :currencies, :name, unique: true
    add_index :currencies, :symbol, unique: true
  end
end
