$map = [["O", "O", "O", "O", "O"], ["O", "O", "O", "O", "O"], ["O", "O", "O", "O", "O"], ["O", "O", "O", "O", "O"], ["O", "O", "O", "O", "O"]]
$screen = [["O", "O", "O", "O", "O"], ["O", "O", "O", "O", "O"], ["O", "O", "O", "O", "O"], ["O", "O", "O", "O", "O"], ["O", "O", "O", "O", "O"], ["O", "O", "O", "O", "O"]]


def generate_map # builds a map
	3.times.collect{place_bomb}
	print_map
	$yi = 0
	$xi = 0
	while $yi <= 4 do
		if $map[$yi][$xi] != "X"
			count_around($xi, $yi)
			def buildx 
				while $xi <= 4 do
					puts "working: #{$xi+1}, #{$yi+1}"
					if $map[$yi][$xi] != "X"
						count_around($xi, $yi)
					end
					$xi += 1
					print_map
					puts "\n"
				end
				$xi = 0
			end
		end
		buildx
		$yi += 1
	end
end

def print_map # prints the map to terminal in a grid 
	puts [$map[0].join(' '), $map[1].join(' '), $map[2].join(' '), $map[3].join(' '), $map[4].join(' ')].join("\n")
end

def place_bomb # places bombs ("X") at random spots on the map
	x_coord = rand(5)
	y_coord = rand(5)
	$map[y_coord][x_coord] = "X"
	return $map
end

def count_around(x, y) # counts the number of Xs in adjacent positions (incl. diagonal) and changes all Os in the grid to that total
	mapnum = 0
	xi2 = -1
	while xi2 <= 1
		yi2 = -1
		while yi2 <= 1
			if (y+yi2 >= 0) && (y+yi2 < 5) && (x+xi2 >= 0) && (x+xi2 < 5) && ($map[y+yi2][x+xi2] == "X")
				mapnum += 1
			end
			yi2 += 1
		end
		xi2 += 1
	end
	puts mapnum
	if mapnum === 0
		mapnum = "-"
	end
	$map[y][x] = mapnum
end

generate_map
print_map
