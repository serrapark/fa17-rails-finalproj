class Completed < ApplicationRecord
	belongs_to :lender, class_name: "User", foreign_key: "lender_id"#, optional: false
	belongs_to :debtor, class_name: "User", foreign_key: "debtor_id"#, optional: false
end
