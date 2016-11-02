require_relative "dependencies"

class App < Sinatra::Base
  get "/" do
    "I can find, create, and update emaployee data"
  end

  get "/find/all/employees" do
    employees = Employee.all
    employees.to_json
  end

  get "/find/employee" do
    name = params["name"]
    employee = Employee.find_by(name: name)
    employee.to_json
  end

  delete "/delete/employee" do
    name = params["name"]
    employee = Employee.find_by(name: name)
    employee.destroy
    employee.to_json
  end

  post "/create/employee" do
    employee_data = JSON.parse(request.body.read)
    employee = Employee.create!(employee_data)
    employee.to_json
  end

  patch "/update/employee" do
    name = params["name"]
    employee = Employee.find_by(name: name)
    employee_data = JSON.parse(request.body.read)
    employee.update(employee_data)
    employee.to_json
  end

  run! if app_file == $PROGRAM_NAME
end
