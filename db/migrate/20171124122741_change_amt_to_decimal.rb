class ChangeAmtToDecimal < ActiveRecord::Migration[5.1]
  def change
  	remove_column :ious, :amt
  	add_column :ious, :amt, :decimal, :precision => 8, :scale => 2

  	remove_column :completeds, :amt
  	add_column :completeds, :amt, :decimal, :precision => 8, :scale => 2
  end
end
