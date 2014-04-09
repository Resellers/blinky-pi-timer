require 'pi_piper'
require 'timers'
require 'blinky_cloud/broadcaster'

broadcaster = BlinkyCloud::Broadcaster.new

timers = Timers.new

puts "Press the switch to get started"

PiPiper.watch :pin => 17, :invert => true do |pin|
  puts "Pin changed from #{pin.last_value} to #{pin.value}"
  broadcaster.broadcast! 'sx'
  if pin.value == 1
    begin
      timers.first.cancel
    rescue
    end
    puts "Starting timer"
    timers.after(Integer(ARGV[0] || 15 * 60)) {
      broadcaster.broadcast! 'sc'
      puts "Time's up!"
    }
  end
end

loop do
  timers.wait
end

