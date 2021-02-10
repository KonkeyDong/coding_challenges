require 'minitest/autorun'
require_relative '../frequency'

describe Frequency do
    # Programmer's notes: Maybe use StringIO to mock out files instead of making 8 .txt files...?
    # Another day.
    describe '#find_result' do
        it 'should return 3' do
            frequency = Frequency.new('part_01/test_01.txt')
            assert_equal frequency.find_result, 3
        end

        it 'should return 3' do
            frequency = Frequency.new('part_01/test_02.txt')
            assert_equal frequency.find_result, 3
        end

        it 'should return 0' do
            frequency = Frequency.new('part_01/test_03.txt')
            assert_equal frequency.find_result, 0
        end

        it 'should return -6' do
            frequency = Frequency.new('part_01/test_04.txt')
            assert_equal frequency.find_result, -6
        end
    end

    describe '#find_first_duplication' do
        it 'should return 0' do
            frequency = Frequency.new('part_02/test_01.txt')
            assert_equal frequency.find_first_duplication, 0
        end

        it 'should return 10' do
            frequency = Frequency.new('part_02/test_02.txt')
            assert_equal frequency.find_first_duplication, 10
        end

        it 'should return 5' do
            frequency = Frequency.new('part_02/test_03.txt')
            assert_equal frequency.find_first_duplication, 5
        end

        it 'should return 14' do
            frequency = Frequency.new('part_02/test_04.txt')
            assert_equal frequency.find_first_duplication, 14
        end
    end
end
