# Description
Commandline ruby applicaiton used to determine the milestone anniversary dates for a give data set

## Usage
Two arguments are required:
1) file name or path to file. Required
2) run date. Optional, will default to current date

example:
```
./anniversary.rb employee_data.csv 2017
```
or 
```
./anniversary.rb employee_data.csv
```

### CSV Format
Expected Input is a CSV with the following fields:
`employee_id, first_name, last_name, hire_date, supervisor_id`

### Date Format
Date must be formated according to ISO-8601 as `YYYY-MM-DD` otherwise current date will be used.


## Output
Application will output a JSON object listing supervisor ID and a list of upcoming milestones. Example output block from a different data file, assuming a run date of Oct 1, 2015:
```
{
  "supervisor_id": "0028356",
  "upcoming_milestones": [
    {
      "employee_id": "0018325",
      "anniversary_date": "2015-10-03"
    },
    {
      "employee_id": "0038576",
      "anniversary_date": "2015-10-05"
    },
    {
      "employee_id": "0038679",
      "anniversary_date": "2015-10-05"
    },
    {
      "employee_id": "0029385",
      "anniversary_date": "2015-10-17"
    },
    {
      "employee_id": "0066839",
      "anniversary_date": "2015-10-22"
    }
  ]
}
```