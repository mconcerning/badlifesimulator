extends Node #author(s): Ethan Scott


##Creates randomness seeds for lives. To access the random number generator, use r.ng.


var ng : RandomNumberGenerator = RandomNumberGenerator.new() ##The random number generator that determines each life's randomness. USE THIS ONLY FOR LIFE-SPECIFIC RANDOMISATION. Use the regular randi_range instead to ignore the seed. To access the seed, use global.rng.seed


func gardener(customSeed = false): ##Generates a new random seed at the beginning of each life; set customSeed to a specific seed as an integer to use it instead of the randomly-generated one.
	ng = RandomNumberGenerator.new()
	if customSeed is int:
		ng.seed = customSeed #if using custom seed, use custom seed
	else:
		#if not using custom seed, use random seed
		ng.seed = (randi() << 32) | randi() #no clue what this means i found it online
	print("seed is " + str(ng.seed))
