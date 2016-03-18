$prompt = "> "
$dasharray = []

def print_map # prints the map/answer key (for debug)
	puts [$map[0].join(' '), $map[1].join(' '), $map[2].join(' '), $map[3].join(' '), $map[4].join(' ')].join("\n")
end

def print_screen # prints the player screen (map as the player can see it)
	puts [$screen[0].join(' '), $screen[1].join(' '), $screen[2].join(' '), $screen[3].join(' '), $screen[4].join(' ')].join("\n")
end

def generate_map # builds a map with certain number of randomly placed bombs
	puts "Generating map . . ."
	$map = [["O", "O", "O", "O", "O"], ["O", "O", "O", "O", "O"], ["O", "O", "O", "O", "O"], ["O", "O", "O", "O", "O"], ["O", "O", "O", "O", "O"]]
	$screen = [["O", "O", "O", "O", "O"], ["O", "O", "O", "O", "O"], ["O", "O", "O", "O", "O"], ["O", "O", "O", "O", "O"], ["O", "O", "O", "O", "O"]]
	$bombnum = 4
	$bombnum.times.collect{place_bomb}
	$yi = 0
	$xi = 0
	while $yi <= 4 do
		buildx
		$yi += 1
	end
end

def buildx # part of generate_map, this can be put in the script but for some reason i made it a function
	while $xi <= 4 do
		if $map[$yi][$xi] != "*"
			count_around($xi, $yi)
		end
		$xi += 1
	end
	$xi = 0
end

def print_map # prints the map to terminal in a grid 
	puts [$map[0].join(' '), $map[1].join(' '), $map[2].join(' '), $map[3].join(' '), $map[4].join(' ')].join("\n")
end

def place_bomb # places bombs ("*") at random spots on the map
	x_coord = rand(5)
	y_coord = rand(5)
	$map[y_coord][x_coord] = "*"
	return $map
end

def count_around(x, y) # counts the number of Xs in adjacent positions (incl. diagonal) and changes all Os in the grid to that total
	mapnum = 0
	xi2 = -1
	while xi2 <= 1
		yi2 = -1
		while yi2 <= 1
			if (y+yi2 >= 0) && (y+yi2 < 5) && (x+xi2 >= 0) && (x+xi2 < 5) && ($map[y+yi2][x+xi2] == "*")
				mapnum += 1
			end
			yi2 += 1
		end
		xi2 += 1
	end
	if mapnum === 0
		mapnum = "-"
	end
	$map[y][x] = mapnum
end

def open_space(x, y)
	xi3 = -1
	while xi3 <= 1
		yi3 = -1 
		while yi3 <= 1
			if (y+yi3 >= 0) && (y+yi3 < 5) && (x+xi3 >= 0) && (x+xi3 < 5) && ($map[y+yi3][x+xi3] == "-")
				$screen[y+yi3][x+xi3] = $map[y+yi3][x+xi3]
				$dasharray.push([(y+yi3), (x+xi3)])
			elsif (y+yi3 >= 0) && (y+yi3 < 5) && (x+xi3 >= 0) && (x+xi3 < 5)
				$screen[y+yi3][x+xi3] = $map[y+yi3][x+xi3]
			end
			yi3 += 1
		end
		xi3 += 1
	end
end

def play_game
	$gameover = false
	puts "
To play, enter the coordinates you'd like to guess.
You might explode.
(Note: the map is read from the top left corner, over then down - so the top left corner would be 1, 1 and the top right would be 1, 5)
	"
	$flagsleft = $bombnum
	while ($screen.join.include?"O") && ($gameover == false) do
		turn
	end
	if (($screen.join.include?"O") == false) && ($gameover == false)
		victory
	end
end

def turn
	print_screen
	puts "To guess coordinates, type \"X, Y\"\nTo place a flag over a suspected bomb, type \"b X, Y\"\nTo remove an existing bomb, type \"r X, Y\"\nFlags remaining: #{$flagsleft}"
	print $prompt
	input = $stdin.gets.chomp.delete(',').split(' ')
	if input[0].upcase == "B" 
		isbomb, $x_guess, $y_guess = input.map(&:to_i)
		$x_guess = $x_guess.to_i - 1
		$y_guess = 5 - $y_guess.to_i
		flag_bomb
	elsif input[0].upcase == "R" 
		isbomb, $x_guess, $y_guess = input.map(&:to_i)
		$x_guess = $x_guess.to_i - 1
		$y_guess = 5 - $y_guess.to_i
		remove_flag
	else 
		$x_guess, $y_guess = input.map(&:to_i)
		$x_guess = $x_guess.to_i - 1
		$y_guess = 5 - $y_guess.to_i
		if $map[$y_guess][$x_guess] != "*" 
			safe_turn
		elsif $map[$y_guess][$x_guess] == "*"
			game_over
		end
	end
end

def safe_turn
	puts "Whew!"
	$screen[$y_guess][$x_guess] = $map[$y_guess][$x_guess]
	if $map[$y_guess][$x_guess] == "-"
		open_space($x_guess, $y_guess)
	end
	if $dasharray != []
		checkagain = $dasharray.shift
		open_space(checkagain[1], checkagain[0])
	end
	$x_guess = nil
	$y_guess = nil
end

def remove_flag
	if $screen[$y_guess][$x_guess] == "!"
		puts "Removing flag!"
		$screen[$y_guess][$x_guess] = "O"
		$x_guess = nil
		$y_guess = nil
		$flagsleft += 1
	else
		puts "There is no flag at that location."
		$x_guess = nil
		$y_guess = nil
	end
end

def flag_bomb
	if $flagsleft > 0
		puts "Potential bomb flagged!"
		$screen[$y_guess][$x_guess] = "!"
		$x_guess = nil
		$y_guess = nil
		$flagsleft -= 1
	elsif $flagsleft === 0
		puts "No flags remaining! Remove an existing flag\n(note: All bombs must be flagged to win. There are enough flags for every bomb.)"
		$x_guess = nil
		$y_guess = nil
	end
end

def game_over
	$gameover = true
	$x_guess = nil
	$y_guess = nil
	print_map
	puts "BOOM!!"
	puts "Play again? Y/N"
	input = $stdin.gets.chomp
	if (input.upcase == "Y") || (input.upcase == "YES")
		start_game
	else 
		puts "Ok bye!!"
	end
end

def victory
	$x_guess = nil
	$y_guess = nil
	print_map
	puts "
Congratulations!!!
The world is a little bit safer thanks to you!!
Play again? Y/N
	"
	input = $stdin.gets.chomp
	if (input.upcase == "Y") || (input.upcase == "YES") || (input.upcase == "PLAY")
		start_game
	else 
		puts "Ok bye!!"
	end
end

def program_start
	puts "Welcome to Minesweeper! Type \"play\" to begin. Type anything else to exit."
	input = $stdin.gets.chomp
	if input.upcase == "PLAY"
		start_game
	elsif 
		puts "Ok bye!"
	end
end

def start_game
	generate_map
	# print_map
	puts "\n"
	play_game
end

program_start