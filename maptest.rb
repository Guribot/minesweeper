$map = []
$screen = []

def print_map # prints the map/answer key (for debug)
	puts [$map[0].join(' '), $map[1].join(' '), $map[2].join(' '), $map[3].join(' '), $map[4].join(' ')].join("\n")
end

def print_screen # prints the player screen (map as the player can see it)
	puts [$screen[0].join(' '), $screen[1].join(' '), $screen[2].join(' '), $screen[3].join(' '), $screen[4].join(' ')].join("\n")
end

def generate_map # builds a map with certain number of randomly placed bombs
	cont = true
	while cont
		puts "Choose board size between 4 and 20!\n(Board is always square)"
		input = $stdin.gets.to_i
		if input <= 3 || input > 20
			puts "Input must be a single number between 4 and 20"
		elsif input >= 4 && input <= 20
			puts "Generating size #{input} x #{input} map . . ."
			$mapsize = input
			cont = false
		else
			puts "Error"
			exit(0)
		end
	end

	$map = ([(["O"] * $mapsize)]) * $mapsize
	$screen = ([(["O"] * $mapsize)]) * $mapsize
	print_map

	$bombnum = $mapsize - 1
	$bombnum.times.collect{place_bomb}
	$yi = 0
	$xi = 0

	while $yi <= 4 do
		while $xi <= 4 do
			if $map[$yi][$xi] != "*"
				count_around($xi,$yi)
			end
			$xi += 1
		end
		$xi = 0
		$yi += 1
	end

end

def print_map # prints the map to terminal in a grid 
	$map.each do |map|
		puts map.join(' ')
	end
end


def place_bomb # places bombs ("*") at random spots on the map
	x_coord = rand($mapsize)
	y_coord = rand($mapsize)
	puts x_coord
	puts y_coord
	$map[y_coord][x_coord] = "*"
	print_map
	return $map
end

def count_around(x, y) # counts the number of Xs in adjacent positions (incl. diagonal) and changes all Os in the grid to that total
	mapnum = 0
	xi2 = -1
	while xi2 <= 1
		yi2 = -1
		while yi2 <= 1
			if (y+yi2 >= 0) && (y+yi2 < $mapsize) && (x+xi2 >= 0) && (x+xi2 < $mapsize) && ($map[y+yi2][x+xi2] == "*")
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

def open_space(x, y) # reveals spaces around guessed "-" cell, needs to be fixed to continue on to subsequent "-" cells
	xi3 = -1
	while xi3 <= 1
		yi3 = -1 
		while yi3 <= 1
			if (y+yi3 >= 0) && (y+yi3 < $mapsize) && (x+xi3 >= 0) && (x+xi3 < $mapsize) && ($map[y+yi3][x+xi3] == "-")
				$screen[y+yi3][x+xi3] = $map[y+yi3][x+xi3]
				$dasharray.push([(y+yi3), (x+xi3)])
			elsif (y+yi3 >= 0) && (y+yi3 < $mapsize) && (x+xi3 >= 0) && (x+xi3 < $mapsize)
				$screen[y+yi3][x+xi3] = $map[y+yi3][x+xi3]
			end
			yi3 += 1
		end
		xi3 += 1
	end
end

generate_map
puts("Map: ")
print_map
puts("Screen: ")
print_screen