require_relative 'pots'

pots = Pots.new("challenge.txt")
pots.generate(20)
first_count = pots.count_plants

puts "# of counted plants (20 generations): #{first_count}"

# reset and try again, but with 50,000,000,000
pots = Pots.new("challenge.txt")
# A pattern emerged at generation 159. Every generation after
# simply shifts the filled pots over by one. This shit fucking
# pisses me off. I thought we needed to build a data structure
# or an algorithms to figure this out, but it was just a stupid
# calculation. Not challenging; waste of 6+ hours trying to
# solve. Do I really want to continue with this crap? 
# Shit like this brings my piss to a boil...
pots.generate(159)
score = pots.count_plants
final_score = (50_000_000_000 - 159) * pots.filled_pots + score
puts "# of counted plants (50,000,000,000 generations): #{final_score}"