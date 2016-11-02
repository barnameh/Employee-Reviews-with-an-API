require './migrations.rb'
require './department.rb'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'development.sqlite3'
)

d = Employee.create!(name: "Doug")

e = Employee.create!(name: "Elanor")

t = Department.create!(name: "Telecom")

t.employees = [d, e]

t.save!
