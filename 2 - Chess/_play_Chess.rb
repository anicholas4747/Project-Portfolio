require_relative "game.rb"
system "clear"
puts "LET'S PLAY CHESS!!\n"

puts "Select a mode:"
puts "Player vs Player (pvp) or Player vs  Computer (pvc):"
mode = gets.chomp.downcase
valid_mode = false
while !valid_mode
    if mode == "pvp" || mode == "pvc"
        valid_mode = true
    else
        puts "That's not a valid mode!"
        sleep 0.5
        system "clear"
        puts "Select a mode:"
        puts "Player vs Player (pvp) or Player vs  Computer (pvc):"
        mode = gets.chomp.downcase
    end
end

b = Board.new
disp = Display.new(b)
system "clear"
puts "\n\n"

if mode == "pvp"
    puts "Mode: Player vs Player"
    sleep 2
    p1 = HumanPlayer.new(:W,disp)
    p2 = HumanPlayer.new(:B,disp)
elsif mode == "pvc"
    puts "Mode: Player vs Computer"
    pck = (1..10).to_a.sample
    if pck.odd?
        puts "The computer will go first"
        p1 = ComputerPlayer.new(:W,b,disp)
        p2 = HumanPlayer.new(:B,disp)
    else
        puts "The player will go first"
        p1 = HumanPlayer.new(:W,disp)
        p2 = ComputerPlayer.new(:B,b,disp)
    end
    sleep 3.5
end

game = Game.new(b,disp,p1,p2)

game.play