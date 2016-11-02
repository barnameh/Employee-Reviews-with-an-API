require "./test_helper"

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'test.sqlite3'
)
ActiveRecord::Migration.verbose = false

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def setup
    Employee.delete_all
  end

  def app
    App
  end

  def test_classes_exist
    assert Employee
  end

  def test_declares_its_function
    response = get "/"
    assert response.ok?
    assert_equal "I can find, create, and update emaployee data", response.body
  end

  def test_get_the_list_of_employees
    xavier = Employee.create!(name: "Xavier", email: "ProfX@marvel.com", phone: "911", salary: 70000.00)
    dan = Employee.create!(name: "Dan", email: "d@mail.com", phone: "914-555-5555", salary: 50000.00)
    yvonne = Employee.create!(name: "Yvonne", email: "Yvonne@urFired.com", phone: "919-123-4567", salary: 40000.00)

    response = get "/find/all/employees"
    assert response.ok?
    employees =  JSON.parse(response.body)

    assert_equal xavier.name, employees[0]["name"]
    assert_equal dan.name, employees[1]["name"]
    assert_equal yvonne.name, employees[2]["name"]
  end

  def test_find_employee_with_name
    Employee.create!(name: "Xavier", email: "ProfX@marvel.com", phone: "911", salary: 70000.00)
    dan = Employee.create!(name: "Dan", email: "d@mail.com", phone: "914-555-5555", salary: 50000.00)
    Employee.create!(name: "Yvonne", email: "Yvonne@urFired.com", phone: "919-123-4567", salary: 40000.00)

    response = get "/find/employee?name=Dan"
    assert response.ok?

    employee =  JSON.parse(response.body)
    assert_equal dan.name, employee["name"]
    assert_equal dan.email, employee["email"]
  end

  def test_delete_employee_with_name
    Employee.create!(name: "Xavier", email: "ProfX@marvel.com", phone: "911", salary: 70000.00)
    dan = Employee.create!(name: "Dan", email: "d@mail.com", phone: "914-555-5555", salary: 50000.00)
    Employee.create!(name: "Yvonne", email: "Yvonne@urFired.com", phone: "919-123-4567", salary: 40000.00)

    response = delete "/delete/employee?name=Dan"
    assert response.ok?

    employee =  JSON.parse(response.body)
    assert_equal dan.name, employee["name"]
    refute Employee.find_by(name: "Dan")
  end

  def test_it_can_create_an_employee
    hash = { name: "Dan", email: "dan@gmail.com", phone: "914-555-5555", salary: "50000.0" }
    response = post("/create/employee", hash.to_json, { "CONTENT_TYPE" => "application/json" })
    assert response.ok?

    dan = Employee.find_by(name: "Dan")
    employee =  JSON.parse(response.body)
    assert_equal employee["name"], dan.name
  end

  def test_it_can_update_an_employee
    Employee.create!(name: "Dan", email: "d@mail.com", phone: "914-555-5555", salary: 50000.00)
    update_data = { email: "danger@gmail.com", phone: "914-444-5555", salary: "55000.0" }

    response = patch("/update/employee?name=Dan", update_data.to_json, { "CONTENT_TYPE" => "application/json" })
    assert response.ok?

    dan = Employee.find_by(name: "Dan")
    employee =  JSON.parse(response.body)
    assert_equal "danger@gmail.com", dan.email
    assert_equal "danger@gmail.com", employee["email"]
  end
end
