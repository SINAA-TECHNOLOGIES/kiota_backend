class AddCountryRefToProperties < ActiveRecord::Migration[7.1]
  def change
    add_reference :properties, :country, null: false, foreign_key: true
  end
end
