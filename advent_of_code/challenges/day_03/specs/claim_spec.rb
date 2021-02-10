require 'minitest/autorun'
require_relative '../claim'

describe Claim do
    let(:example_hash) {
        {
            id: '#1',
            start_position: {
                x: 1,
                y: 3
            },
            dimensions: {
                x: 4,
                y: 4
            }
        }
    }

    before do
        @claim = Claim.new('test_01.txt')
    end

    describe '#parse_claim' do
        

        it 'should return a similar hash' do
            assert_equal @claim.send(:parse_claim, '#1 @ 1,3: 4x4'), example_hash
        end
    end

    describe '#add_claim' do
        it 'should add the claim to the @claims field' do
            @claim.send(:add_claim, example_hash)
            assert_equal @claim.instance_variable_get("@claims"), { '#1' => example_hash.reject { |key, _| key == :id } }
        end
    end

    describe '#add_fabric' do
        it 'lajlkdjf' do
            @claim.send(:add_fabric, example_hash)
            
            # I don't see a point of checking every value in the square right here;
            # I just want to check if the corners have a value.
            # Assume that the square is filled.
            assert_equal @claim.instance_variable_get("@fabric")["1,3"], 1
            assert_equal @claim.instance_variable_get("@fabric")["4,3"], 1
            assert_equal @claim.instance_variable_get("@fabric")["1,6"], 1
            assert_equal @claim.instance_variable_get("@fabric")["4,6"], 1
        end
    end

    describe '#find_overlap' do
        it 'should return 4' do
            @claim.scan
            assert_equal @claim.find_overlap, 4
        end
    end

    describe '#id_of_no_overlap' do
        it 'should return #3' do
            @claim.scan
            assert_equal @claim.id_of_no_overlap, '#3'
        end
    end
end
