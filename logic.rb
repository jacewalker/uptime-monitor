require 'net/ping'
require 'logger'

query = ARGV[0]
interval = ARGV[1]
@cancelled = false
@threads = []

checks = []
checks += [{host: '1.1.1.1', interval: 2, user: 1, cancelled: false}]
checks += [{host: '8.8.8.8', interval: 4, user: 2, cancelled: true}]
checks += [{host: '10.2.2.1', interval: 6, user: 3, cancelled: false}]

# Checks is host is alive via ICMP
def up(host)
    begin
        p = Net::Ping::ICMP.new(host.to_s, nil, 0.1)
        status = p.ping?
        p.ping? ? status = true : status = false
      rescue Errno::EHOSTUNREACH, Errno::EHOSTDOWN
        return status = false
      end
end

# Calls up method at each interval
def uptime(host, time)
    while @cancelled == false do
        status = up(host)
        sleep time.to_i
        puts "#{host} is up: #{status}"
    end
end

## Work in progress
def new_check
  puts 'Pending work'
end

## Work in progress
def delete_check
  puts 'Pending work'
end

## Work in progress
def edit_check
  puts 'Pending work'
end

# Calls each check in the system and adds it to a thread array
checks.each do | check |
  if check[:cancelled]
    Logger.info 'Check is cancelled'
  else
    @threads << Thread.new { uptime(check[:host], check[:interval]) }
  end
end

# Begins all threads in thread array
@threads.each { |thr| thr.join }