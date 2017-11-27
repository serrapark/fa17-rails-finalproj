class Completed < ApplicationRecord
	validates :description, presence: true
    validates :amt, presence: true
    validates :lender_id, presence: true
    validates :debtor_id, presence: true
    belongs_to :lender, class_name: "User", foreign_key: "lender_id", optional: false
    belongs_to :debtor, class_name: "User", foreign_key: "debtor_id", optional: false
end
