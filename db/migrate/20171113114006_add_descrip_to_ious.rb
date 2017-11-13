class AddDescripToIous < ActiveRecord::Migration[5.1]
  def change
    add_column :ious, :description, :string
  end
end
