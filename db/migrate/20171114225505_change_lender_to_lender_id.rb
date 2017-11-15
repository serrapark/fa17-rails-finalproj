class ChangeLenderToLenderId < ActiveRecord::Migration[5.1]
  def change
  	rename_column :ious, :lender, :lender_id
  end
end
