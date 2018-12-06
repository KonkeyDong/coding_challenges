require 'minitest/autorun'
require_relative '../checksum'

describe Checksum do
    describe '#calculate' do
        it 'should return 12' do
            checksum = Checksum.new('test_01.txt')
            assert_equal checksum.calculate, 12
        end
    end

    describe '#different_ids' do
        it 'should return "fgij"' do
            checksum = Checksum.new('test_02.txt')
            assert_equal checksum.different_ids, 'fgij'
        end
    end
end
