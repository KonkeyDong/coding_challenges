require 'minitest/autorun'
require 'byebug'
require_relative '../point'

describe Point do
    let(:sample_point) {
        {
            position: { x: 0, y: 0 },
            velocity: { x: 1, y: -2 }
        }
    }

    describe "#initialize" do
        it "should set the point's initial position and velocity" do
            point = Point.new(sample_point)
            assert_equal point.position, sample_point[:position]
            assert_equal point.velocity, sample_point[:velocity]
        end
    end

    describe "#move_point and #revert_point" do
        it "should adjust the position coordinates" do
            point = Point.new(sample_point)
            
            point.move_point
            assert_equal point.position, { x: 1, y: -2 }

            point.revert_point
            assert_equal point.position, { x: 0, y: 0 }
        end
    end
end