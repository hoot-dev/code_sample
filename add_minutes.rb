#!/usr/bin/env ruby

# Increment the provided time by the provided minutes.
#
# time      - A string in [H]H:MM {AM|PM} format
# increment - An integer
#
# Returns a string representing the altered time.
def add_minutes(time, increment)
  # parse time into array of hour, minutes and period
  begin
    hour, min, period = time.split(/[\s:]/)
  rescue
    raise "Incorrect format for time: #{time}.  Must be a string formatted as: [H]H:MM {AM|PM}"
  end

  # verify addition of minutes is possible
  if integer?(min) && integer?(increment)
    total_minutes = min.to_i + increment
    minutes = (min.to_i + increment) % 60

    if minutes < 10
      minutes = "0#{minutes}"
    end
  else
    raise "Minutes must be integers. Either #{time} or #{increment} is not valid."
  end

  # increment hour if minutes + increment > 60
  if integer?(hour)
    new_hour = hour.to_i + total_minutes / 60
    twelfth_hour = new_hour % 12
  else
    raise "Hour must be an integer."
  end
  
  #deal with am/pm
  if new_hour > 12
    if period == 'AM'
      period = 'PM'
    elsif period == 'PM'
      period = 'AM'
    else
      raise "Period {#period} must be AM or PM"
    end
  end

  "#{twelfth_hour}:#{minutes} #{tod}"
end

# Give credit where credit is due:
# http://stackoverflow.com/questions/1235863/test-if-a-string-is-basically-an-integer-in-quotes-using-ruby
def integer?(num)
  !!(num.to_s =~ /^[-+]?[0-9]+$/)
end


# This will suffice for unit tests given time constraints

# Happy path
# puts add_minutes('9:13 AM, 10')

# Hour flips over
# puts add_minutes('9:13 AM', 50)

# Failed regex
# puts add_minutes('this should not work', 80)

# Non-Integer minutes
# puts add_minutes('9:abc PM', 20)

# Non-Integer increment
# puts add_minutes('9:10 AM', 'seven')

# We can even turn back the clock!
# puts add_minutes('9:10 AM', -30)

# Additional concerns:
# What if hour or minutes provided are some object with no "to_s" method?
# AM/PM is naive.  If someone enters an increment in minutes > 12 hours and < 24 hours then it should not shift.
