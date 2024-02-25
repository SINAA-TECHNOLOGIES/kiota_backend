class RemoveCountryIdFromProperties < ActiveRecord::Migration[7.1]
  def change
    remove_column :properties, :country_id, :integer
  end
end
