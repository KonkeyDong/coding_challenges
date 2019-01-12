require 'minitest/autorun'
require_relative '../game'

describe Game do
    describe "testing methods" do
        before do
            @game = Game.new(9, 25)
        end

        describe "#multiple_of_23?" do
            it "should return false if zero (special case)" do
                assert_equal @game.send(:multiple_of_23?, 0), false
            end

            it "should return false" do
                (1..22).each do |i|
                    assert_equal @game.send(:multiple_of_23?, i), false
                end
            end

            it "should return true" do
                [23, 46].each do |i|
                    assert_equal @game.send(:multiple_of_23?, i), true
                end
            end
        end

        describe "#player_offset" do
            it "should return 0" do
                [1, 10, 19, 28].each do |i|
                    assert_equal @game.send(:player_offset, i), 1
                end
            end

            it "should return 1" do
                [5, 14, 23, 32].each do |i|
                    assert_equal @game.send(:player_offset, i), 5
                end
            end
        end
    end

    describe "#play" do
        it "should return player 5 with score of 32" do
            player, score = play_helper(9, 25)
            assert_equal player, 5
            assert_equal score, 32
        end

        it "should equal 8317" do
            player, score = play_helper(10, 1618)
            assert_equal score, 8317
        end

        it "should equal 146373" do
            player, score = play_helper(13, 7999)
            assert_equal score, 146373
        end

        it "should equal 2764" do
            player, score = play_helper(17, 1104)
            assert_equal score, 2764
        end

        it "should equal 54718" do
            player, score = play_helper(21, 6111)
            assert_equal score, 54718
        end

        it "should equal 37305" do
            player, score = play_helper(30, 5807)
            assert_equal score, 37305
        end

        def play_helper(number_of_players, last_marble_value)
            game = Game.new(number_of_players, last_marble_value)
            game.play
        end
    end
end
