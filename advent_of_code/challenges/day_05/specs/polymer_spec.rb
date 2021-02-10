require 'minitest/autorun'
require_relative '../polymer'

describe Polymer do
    before do
        @polymer = Polymer.new('test_01.txt')
    end

    describe "#reacts?" do
        it 'should return false' do
            @polymer.instance_variable_set("@stack", ['x'])
            assert_equal @polymer.send(:reacts?, 'X'), true
        end

        it 'should return false' do
            @polymer.instance_variable_set("@stack", ['x'])
            assert_equal @polymer.send(:reacts?, 'x'), false
        end

        it 'should return false if nothing in stack' do
            assert_equal @polymer.send(:reacts?, 'x'), false
        end
    end

    describe '#size' do
        it 'should return 10' do
            @polymer.scan
            assert_equal @polymer.size, 10
        end
    end

    describe '#stack_operation' do
        it 'should set the stack to ["x"] and remove it' do
            @polymer.send(:stack_operation, 'x')
            assert_equal @polymer.instance_variable_get("@stack"), ['x']
            @polymer.send(:stack_operation, 'X')
            assert_equal @polymer.instance_variable_get("@stack"), []
        end
    end

    describe '#scan' do
        it 'should return 10' do
            @polymer.scan
            assert_equal @polymer.size, 10
        end
    end

    describe '#scan_without_polymer' do
        it 'should return 4' do
            assert_equal @polymer.scan_without_polymer, 4
        end
    end
end
