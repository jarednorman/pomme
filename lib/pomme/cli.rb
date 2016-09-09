module Pomme
  class Cli < Thor
    desc "start [TASK]", "Start a task with a name."
    def start(task)
      dump = Marshal.dump({ start: Time.now, name: task })
      File.open(pomme_path, 'w') do |f|
        f.write(dump)
      end
    end

    desc "status", "Print the current pomme status."
    def status
      print_status(load_task)
    end

    desc "poll", "Print the status every second."
    def poll
      loop do
        task = load_task
        30.times do
          print_status(task)
          sleep 1
        end
      end
    end

    private

    def twenty_five_minutes
      25 * 60
    end

    def pomme_path
      File.expand_path("~/.pomme")
    end

    def load_task
      Marshal.load(File.read(pomme_path))
    end

    def print_status(task)
      seconds_since_start = (Time.now - task[:start]).to_i
      if seconds_since_start < twenty_five_minutes
        percentage = ((seconds_since_start / twenty_five_minutes.to_f) * 100).to_i
        puts "#{task[:name]} (#{percentage}%)"
      else
        seconds_breaking = seconds_since_start - twenty_five_minutes
        puts "Break: #{Time.at(seconds_breaking).utc.strftime("%H:%M:%S")}"
      end
    end
  end
end
