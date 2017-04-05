#!/usr/bin/ruby

require 'date'

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

puts "file: #{file}, date: #{date}"