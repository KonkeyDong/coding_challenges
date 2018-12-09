require 'byebug'
require_relative '../base'

class Repose < Base
    def initialize(file)
        super(file)
        @records = {}
        @guard_id = nil
        @sleep_start = nil
    end

    def scan
        file_handle = open
        file_handle.each_line do |line|
            line.chomp!()
            record = parse_record(line)
            method = parse_status(record[:status])
            self.send(method, record)
        end
        file_handle.close
    end

    def guard_code
        guard_id = who_is_sleeping_the_most
        minute = guard_frequent_minute_sleeping(guard_id)
        calculate_checksum(guard_id, minute)

        calculate_checksum(guard_id, minute)
    end

    def who_is_sleeping_the_most
        guard_id = @records.keys.max_by { |guard_id| @records[guard_id][:total_minutes] } 
    end

    def guard_frequent_minute_sleeping(guard_id)
        @records[guard_id].reject { |key, _| key == :total_minutes }
                          .keys
                          .max_by { |minute| @records[guard_id][minute] }
    end

    def most_slept_minute
        guard_id, minute_data = @records.keys.reduce({}) do |previous, guard_id| 
            minute = guard_frequent_minute_sleeping(guard_id)
            previous[guard_id] = {
                minute: minute,
                minute_tally: @records[guard_id][minute]
            }

            previous
        end.to_a
           .max_by { |element| element[1][:minute_tally].to_i }

        calculate_checksum(guard_id, minute_data[:minute])
    end

    private

    def calculate_checksum(guard_id, minute)
        guard_id[1..-1].to_i * minute.to_i
    end

    def parse_record(record)
        record.slice!(0)
        timestamp, status = record.split('] ')
        date, time = timestamp.split(' ')
        {
            timestamp: timestamp,
            date: date,
            time: time,
            minute: time.split(':')[1],
            status: status
        }
    end

    def parse_status(status)
        return :handle_guard if status =~ /guard/i
        return :handle_sleep if status =~ /asleep/i
        return :handle_waking_up if status =~ /wakes/i
        raise StandardError "Could not parse status #{status}"
    rescue StandardError => e
        STDERR.puts e.message
        exit 1
    end

    def handle_guard(record)
        record[:status] =~ /(#\d+)/i
        @sleep_start = nil
        @guard_id = $1 # first capture is stored in this magic variable
        @records[@guard_id] ||= { total_minutes: 0 }
        @guard_id
    end

    def handle_sleep(record)
        @sleep_start = record[:minute].to_i
    end

    def handle_waking_up(record)
        minute = record[:minute].to_i
        (@sleep_start...minute).each do |number|
            @records[@guard_id][minute_str(number)] ||= 0
            @records[@guard_id][minute_str(number)] += 1
        end

        @records[@guard_id][:total_minutes] += minute - @sleep_start
    end

    def minute_str(minute)
        minute.to_s.rjust(2, "0")
    end
end
