#!/usr/bin/ruby

require 'date'
require 'CSV'
require 'json'

inputs = ARGV
file = inputs[0]
run_date = inputs[1].nil? ? Time.now.strftime("%Y-%d-%m") : inputs[1]


## Error handling
### Invalid file
unless File.file?(file)
  puts 'File invalid. Enter full file path'
  exit
end

### Invalid date
y, m, d = run_date.split '-'
unless Date.valid_date? y.to_i, m.to_i, d.to_i
  puts 'Date invalid. Please enter as YYYY-MM-DD'
  exit
else
  run_date = Date.parse run_date
end

def employee_json(employee_id, milestones = [])
 {
    supervisor_id: employee_id,
    upcoming_milestones: milestones
  }
end

def milestones(subordinates, run_date)
  upcoming_milestones = []
  subordinates.each do |employee|
    count = 0
    upcoming_date = employee[:hire_date]
    while count < 5 do
      upcoming_date = upcoming_date.next_year 5
      if upcoming_date > run_date
        upcoming_milestones.push(
          {
            employee_id: employee[:id],
            anniversary_date: upcoming_date
          }
        )
        count += 1 
      end
    end
  end
  upcoming_milestones.sort { |a,b| a[:anniversary_date] <=> b[:anniversary_date] }.slice(0,5)
end

employees = []
supervisors = []

date_error = false

CSV.foreach(file, headers: true) do |line|
  begin
    employees.push({
      id: line['employee_id'],
      hire_date: Date.strptime(line['hire_date'], '%Y-%m-%d'),
      supervisor_id: line['supervisor_id']
    })
    supervisors.push(line['supervisor_id']) unless supervisors.include? line['supervisor_id']
  rescue ArgumentError => e
    date_error = true
    puts "#{e} for #{line['employee_id']}"
  end
  
end

unless date_error
  results = []
  employees.group_by { |e| e[:supervisor_id] }.each do |sub|
    results.push employee_json(sub[0], milestones(sub[1], run_date))
  end

  employees.each do |employee|
    unless supervisors.include? employee[:id]
      results.push employee_json(employee[:id])
    end
  end
  puts JSON.pretty_generate(results)
end

