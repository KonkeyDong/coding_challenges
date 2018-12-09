require 'minitest/autorun'
require_relative '../repose'

describe Repose do
    let(:example_record_hash) {
        {
            timestamp: '1518-11-01 00:00',
            date: '1518-11-01',
            time: '00:00',
            minute: '00',
            status: 'Guard #10 begins shift'
        }
    }

    before do
        @repose = Repose.new('test_01.txt')
    end

    describe '#parse_record' do
        it 'should parse a record and return a hash' do
            assert_equal @repose.send(:parse_record, '[1518-11-01 00:00] Guard #10 begins shift'), example_record_hash
        end
    end

    describe '#parse_status' do
        it 'should return :handle_guard' do
            assert_equal @repose.send(:parse_status, 'guard'), :handle_guard
        end

        it 'should return :handle_sleep' do
            assert_equal @repose.send(:parse_status, 'asleep'), :handle_sleep
        end

        it 'should return :handle_waking_up' do
            assert_equal @repose.send(:parse_status, 'wakes'), :handle_waking_up
        end

        it 'should raise StandardError' do
            raised_exception = -> { raise StandardError.new }
            @repose.stub :parse_status, raised_exception do
                assert_raises(StandardError) { @repose.send(:parse_status, 'bologna') }
            end
        end
    end

    describe '#handle_guard' do
        it 'should return "#10" and set @guard_id' do
            assert_nil @repose.instance_variable_get("@guard_id")
            assert_equal @repose.send(:handle_guard, example_record_hash), "#10"
            assert_equal @repose.instance_variable_get("@guard_id"), "#10"
        end
    end

    describe '#handle_sleep' do
        it 'should return 0 and set @sleep_start' do
            assert_nil @repose.instance_variable_get("@sleep_start")
            assert_equal @repose.send(:handle_sleep, example_record_hash), 0
            assert_equal @repose.instance_variable_get("@sleep_start"), 0
        end
    end

    describe '#handle_waking_up' do
        it 'should return 20' do
            @repose.send(:handle_guard, example_record_hash)
            @repose.send(:handle_sleep, example_record_hash)

            assert_equal @repose.send(:handle_waking_up, example_record_hash.merge(minute: '25')), 25

            (0...25).each do |number|
                minute = @repose.send(:minute_str, number)
                assert_equal @repose.instance_variable_get("@records")["#10"][minute], 1
            end
        end
    end

    describe '#guard_code' do
        it 'should return 240' do
            @repose.scan
            assert_equal @repose.guard_code, 240
        end
    end

    describe '#who_is_sleeping_the_most' do
        it 'should return 240' do
            @repose.scan
            assert_equal @repose.who_is_sleeping_the_most, "#10"
        end
    end

    describe '#guard_frequent_minute_sleeping' do
        it 'should return 24' do
            @repose.scan
            assert_equal @repose.guard_frequent_minute_sleeping('#10'), '24'
        end
    end

    describe '#most_slept_minute' do
        it 'should return 4455' do
            @repose.scan
            assert_equal @repose.most_slept_minute, 4455
        end
    end
end
