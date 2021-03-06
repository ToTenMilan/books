#---
# Excerpted from "Ruby Performance Optimization",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/adrpo for more book information.
#---
require 'date'
require 'benchmark'

date = "2014-05-23"
time = Benchmark.realtime do
  100000.times do
    Date.parse(date)
  end
end
puts Date.parse(date)
puts "%.3f" % time


# to speed up, tell explicitly what format to use
time = Benchmark.realtime do
  100000.times do
    Date.strptime(date, '%Y-%m-%d')
  end
end
puts Date.strptime(date, '%Y-%m-%d')
puts "%.3f" % time


# avoid string parsing is even faster
time = Benchmark.realtime do
  100000.times do
    Date.civil(date[0,4].to_i, date[5,2].to_i, date[8,2].to_i)
  end
end
puts Date.civil(date[0,4].to_i, date[5,2].to_i, date[8,2].to_i)
puts "%.3f" % time
