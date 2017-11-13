class AddDescripToCompleteds < ActiveRecord::Migration[5.1]
  def change
    add_column :completeds, :description, :string
  end
end
