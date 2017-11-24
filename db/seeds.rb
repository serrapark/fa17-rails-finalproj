# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Make Users
%w(personA personB personC personD).each do |name|
  User.create email: name+"@test.com", password: 'password'
end

# Make Ious
Iou.create lender_id: User.all[0].id, debtor_id: User.all[1].id, amt: 5.00, description: "iou1"
Iou.create lender_id: User.all[1].id, debtor_id: User.all[2].id, amt: 10.00, description: "iou2"
Iou.create lender_id: User.all[2].id, debtor_id: User.all[3].id, amt: 3.00, description: "iou3"
Iou.create lender_id: User.all[3].id, debtor_id: User.all[0].id, amt: 4.00, description: "iou4"
Iou.create lender_id: User.all[0].id, debtor_id: User.all[2].id, amt: 20.00, description: "iou5"
Iou.create lender_id: User.all[2].id, debtor_id: User.all[0].id, amt: 5.00, description: "iou6"
Iou.create lender_id: User.all[1].id, debtor_id: User.all[3].id, amt: 1.00, description: "iou7"
Iou.create lender_id: User.all[3].id, debtor_id: User.all[1].id, amt: 2.00, description: "iou8"
