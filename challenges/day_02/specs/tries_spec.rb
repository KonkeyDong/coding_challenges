require 'minitest/autorun'
require_relative '../tries'

describe Tries do
    before do
        Tries.clear
    end

    let(:root) { {"a"=>{"b"=>{"c"=>{"d"=>"abcd"}}}} }
    let(:cache) { {"abcd"=>true} }

    describe '#add' do
        it 'should add a value to the root and cache; should avoid duplicate values' do
            assert_equal Tries.add('abcd'), true
            assert_equal Tries.instance_variable_get("@root"), root
            assert_equal Tries.instance_variable_get("@cache"), cache
            assert_equal Tries.add('abcd'), 'abcd'
        end
    end

    describe '#clear' do
        it 'should reset the @root and @cache back to {}' do
            Tries.add('abcd')
            assert_equal Tries.instance_variable_get("@root"), root
            assert_equal Tries.instance_variable_get("@cache"), cache
            Tries.clear
            assert_equal Tries.instance_variable_get("@root"), {}
            assert_equal Tries.instance_variable_get("@cache"), {}
        end
    end

    describe '#find' do
        it 'should return true (one bad char)' do
            Tries.add('abcd')
            assert_equal Tries.find('axcd'), 'acd'
        end

        it 'should return false (more than one bad char)' do
            Tries.add('abcd')
            assert_equal Tries.find('dcba'), false
        end
    end

    describe '#string_union' do
        it 'should return the union between two strings' do
            assert_equal Tries.send(:string_union, 'abcd', 'axcd'), 'acd'
            assert_equal Tries.send(:string_union, 'abcdzzz', 'axcd'), 'acd'
            assert_equal Tries.send(:string_union, 'abcd', ''), ''
        end
    end

    describe '#all_but_last_char' do
        it 'should return the string, minus the last char' do
            assert_equal Tries.send(:all_but_last_char, 'abcdefg'), 'abcdef'
            assert_nil Tries.send(:all_but_last_char, '')
        end
    end

    describe '#no_other_bad_characters?' do
        it 'should return a string' do
            Tries.add('abcd')
            assert_equal Tries.send(:no_other_bad_characters?, %w(b c d), {'b' => {'c' => {'d' => 'abcd'}}}), 'abcd'
        end

        it 'should return false' do
            Tries.add('abcd')
            assert_equal Tries.send(:no_other_bad_characters?, %w(x x x), {'b' => {'c' => {'d' => 'abcd'}}}), false
        end
    end

    describe '#find' do
        it 'should return false if nothing was added!' do
            assert_equal Tries.find('bologna'), false
        end

        it 'should return the string if that string was already added' do
            Tries.add('abcd')
            assert_equal Tries.find('abcd'), 'abcd'
        end

        it 'should return a string union of strings with a difference of one character' do
            Tries.add('abcd')
            assert_equal Tries.find('axcd'), 'acd'
        end

        it 'should return false if there are two or more different characters' do
            Tries.add('abcd')
            assert_equal Tries.find('abxx'), false
        end
    end
end
