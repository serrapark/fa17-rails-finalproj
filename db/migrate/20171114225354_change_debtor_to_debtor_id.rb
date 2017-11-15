class ChangeDebtorToDebtorId < ActiveRecord::Migration[5.1]
  def change
  	rename_column :ious, :debtor, :debtor_id
  end
end
