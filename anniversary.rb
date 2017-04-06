#!/usr/bin/ruby

require 'date'
require 'CSV'
require 'json'

inputs = ARGV
file = inputs[0]
date = inputs[1].nil? ? Time.now.strftime("%Y-%d-%m") : inputs[1]


## Error handling
### Invalid file
unless File.file?(file)
  puts 'File invalid. Enter full file path'
  exit
end

### Invalid date
y, m, d = date.split '-'
unless Date.valid_date? y.to_i, m.to_i, d.to_i
  puts 'Date invalid. Please enter as YYYY-MM-DD'
  exit
else
  date = Date.parse(date)
end

def employee_json(employee, milestones)
 {
    supervisor_id: employee[:id],
    upcoming_milestones: milestones
  }
end

employees = []
supervisors = []

CSV.foreach(file, headers: true) do |line|
  employees.push({
    id: line['employee_id'],
    first_name: line['first_name'],
    last_name: line['last_name'],
    hire_date: line['hire_date'],
    supervisor_id: line['supervisor_id']
  })
  supervisors.push(line['supervisor_id']) unless supervisors.include? line['supervisor_id']
end


employees.each do |employee|
  milestones = []
  if supervisors.include? employee[:id]
    milestones = ['test']
  end
  puts employee_json(employee, milestones)
end

# employees.each do |employee|
#   puts employees
# end
