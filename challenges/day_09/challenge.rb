require_relative 'game'

game = Game.new(468, 71010)
player, score = game.play
puts "Player: #{player}"
puts "Score: #{score}"

game = Game.new(468, 7101000)
player, score = game.play
puts "Player: #{player}"
puts "Score: #{score}"