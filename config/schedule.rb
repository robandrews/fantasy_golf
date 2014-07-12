# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "../log/cron.log"
#

every 1.minute do
  rake "cron:fa"
end

every :wednesday, :at => '9:00pm' do
  rake "cron:reminder"
end