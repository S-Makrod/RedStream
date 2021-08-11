#####################################################################
#
# CSCB58 Summer 2021 Assembly Final Project
# University of Toronto, Scarborough
#
# STUDENT INFO REDACTED FOR PRIVACY
#
# Bitmap Display Configuration:
# - Unit width in pixels: 4 (update this as needed)
# - Unit height in pixels: 4 (update this as needed)
# - Display width in pixels: 512 (update this as needed)
# - Display height in pixels: 256 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 3 
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features)
# 1. Scoring System
# 2. Pick Ups
# 3. Increase in Difficulty as Game Progesses
# 4. Smooth Graphics
# 5. Welcome Screen
# 6. Press i to Head Directly to Game Over, Press o to Head Back to Welcome Screen
# 7. Collisions Show in Place of Contact (e.g Asteroid Explosions Show in the Area that was Hit)
#
# Link to video demonstration for final submission:
# - https://youtu.be/Jp5c-WC-QCs
#
# Are you OK with us sharing the video with people outside course staff?
# - yes 
# - https://github.com/S-Makrod/RedStream
#
# Any additional information that the TA needs to know:
# - N/A
#####################################################################

.eqv shipUp 	       -2048		#Ship can move 4 blocks up each time
.eqv shipDown 	 	2048		#Ship can move 4 blocks down each time
.eqv shipLeft 	  	 -16		#Ship can move 4 blocks left each time
.eqv shipRight 	   	  16		#Ship can move 4 blocks right each time

.eqv shipLength 	5632		#The length of the ship
.eqv shipWidth  	  28		#The width of the ship

.eqv asteroidMove 	  -4		#Asteroid can move 1 block left each time
.eqv pointsMove 	  -4		#Bonus points can move 1 block left each time
.eqv lifeMove 	  	  -4		#Life can move 1 block left each time

.eqv topRight	  0x100081FC		#Top right of screen
.eqv topLeft	  0x10008000		#Top left of screen
.eqv bottomLeft   0x1000FC00		#Bottome left of screen
.eqv bottomRight  0x1000FFFC		#Bottom right of screen

.eqv asteroidRight	  0x100081E8	#Place where asteroids spawn on left side of screen
.eqv BonusPointsRight 	  0x100081EC	#Place where bonus points spawn on left side of screen
.eqv lifeRight		  0x100081E0	#Place where life spawn on left side of screen

.eqv shipTop 	  0x100097FC		#The boundry where the ship cannot pass when moving up

.eqv gameOverPos  0x1000A8A0		#Position of printing out the game over message on game over screen

.eqv defaultX	  0x100081FC		#Default x pos of asteroids, life, and bonus points when not being used

.eqv healthBar	  	0x10008390	#Position of the Health Bar
.eqv healthBarContents        1084	#Where the actual contents of the health bar start, note this is refrenced from healthBar
.eqv defaultHealth               5	#The default health of the ship, each collision will decrement by one

.eqv score 	  0x10008204		#Where the score is outputted
.eqv scoreUpdateCycle      5		#The score is updated every 5 cycles

.eqv digitOne 	  92			#Location to print out the most significant digit of the score
.eqv digitTwo 	  108			#Location to print out the second most significant digit of the score
.eqv digitThree	  124			#Location to print out the third most significant digit of the score
.eqv digitFour 	  140			#Location to print out the second least significant digit of the score
.eqv digitFive 	  156			#Location to print out the least significant digit of the score

.eqv pointsEasy     -200		#Points spawn every two hundred points in easy mode
.eqv pointsHard     -400		#Points spawn every four hundred points in hard mode
.eqv pointsEasyScore 500		#If under this value bonus points spawn more often

.eqv lifeEasy     -500			#Lifes spawn every five hundred points in easy mode
.eqv lifeHard     -1000			#Lifes spawn every thousand points in hard mode
.eqv lifeEasyScore 1500			#If the score is under this value life spawn more often

.eqv easyFrameRate      10		#Frame is buffered by 10ms in easy mode
.eqv hardFrameRate       5		#Frame is buffered by 5ms in hard mode
.eqv extraHardFrameRate  2		#Frame is buffered by 2ms in extra hard mode

.eqv hardMode      2000			#If the score is over two thousand the frame rate speeds up
.eqv extraHardMode 5000			#If the score is over five thousand the frame rate speeds up

.eqv welcome 0x1000BCAC			#Location to print out the welcome message in the welcome screen

.eqv bannerBottomEnd	  0x100091FC	#Where the top banner ends when the game is being played

.eqv spawnRange       11		#This is the spawn range so an asteroid appears from 0-10 cycles after the last asteroid
.eqv minSpawnInterval 10 		#To add a min valuse so the final range for asteroid spawn is 10-20 cycles
.eqv spawnControl      1		#To make sure that asteroids spawn at most once per cycle

.eqv spawnLocationRange       50	#The rows where an asteroid can spawn
.eqv minSpawnLocationInterval  9	#The min row the asteroid can spawn, final range is 9-58

.eqv gameBuffer 10			#Used to give the user time to prepare before asteroids start spawning

.eqv nextDown 512			#This is the amount needed to be added to get to the next pixel down 

.eqv asteroidOutlineSize 32		#This is the size of the asteroid outline array
.eqv shipOutlineSize     22		#This is the size of the ship outline array
.eqv lifeOutlineSize 	 36		#This is the size of the life outline array
.eqv pointsOutlineSize   13		#This is the size of the points outline array

.eqv collisionDelay 100			#Delay when there is a collision
.eqv letterDelay    500			#Delay when a letter is drawn

.eqv healthBarSize  5			#Size of the health bar

.eqv lifeSpawnLocation 48		#This is the range of rows for the life spawn

.eqv pointsAdded 50			#This is the points to be added on collision with bonus points

#The following are used when calculating the score
.eqv tenThousand          10000
.eqv negativeTenThousand -10000
.eqv thousand              1000
.eqv negativeThousand     -1000
.eqv hundred                100
.eqv negativeHundred       -100
.eqv ten                     10
.eqv negativeTen            -10

#The following are used for collision checks
#Note that front and back refer to either the front or back of the ship
#One, Two, ... refer to the row relative to the top left
.eqv frontOne	    16
.eqv frontTwo	   532
.eqv frontThree   1048
.eqv frontFour    1564
.eqv frontFive    2080
.eqv frontSix     2592
.eqv frontSeven   3104
.eqv frontEight   3616
.eqv frontNine    4124
.eqv frontTen     4632
.eqv frontEleven  5140
.eqv bottomOne	   516
.eqv bottomTwo	  1028
.eqv bottomThree  1540
.eqv bottomFour   2048
.eqv bottomFive   2556
.eqv bottomSix    3068
.eqv bottomSeven  3584
.eqv bottomEight  4100
.eqv bottomNine   4612
.eqv bottomTen    5124
.eqv bottomEleven 5640
.eqv shipBottomRight   5648

#The following define corners relative to the top left of the asteroid
.eqv bottomLeftAsteroid    2560
.eqv bottomRightAsteroid   2580
.eqv topRightAsteroid        20

#The following define corners relative to the top left of the life
.eqv topRightLife        20
.eqv bottomLeftLife    3072
.eqv bottomRightLife   3104
.eqv bottomBoundryLife 3092

#The following define corners relative to the top left of the points
.eqv topRightPoints        16
.eqv bottomRightPoints   2068
.eqv bottomLeftPoints    2048
.eqv bottomBoundryPoints 2068

.data
shipPos: .word 0x1000B800		#Ship starting pos
asteroids: .word 0x100081FC:101		#Array of asteroids preset with the defaultX value
life: .word 0x100081FC:1		#Life pointer preset with the defaultX value
points: .word 0x100081FC:1		#Bonus points pointer preset with the defaultX value

#This is the outline of the ship relative to where it is on the screen, we use this for collision detection
shipOutline: .word 12, 520, 528, 1032, 1044, 1544, 1560, 2052, 2076, 2560, 2588, 3072, 3100, 3588, 3612, 4104, 4120, 4616, 4628, 5128, 5136, 5644

#This is the outline of an asteroid relative to where it is on the screen, we use this for collision detection
asteroidOutline: .word 4, 8, 12, 16, 512, 516, 520, 524, 528, 532, 1024, 1028, 1032, 1036, 1040, 1044, 1536, 1540, 1544, 1548, 1552, 1556, 2048, 2052, 2056, 2060, 2064, 2068, 2564, 2568, 2572, 2576

#This is the outline of a life relative to where it is on the screen, we use this for collision detection
lifeOutline: .word 8, 12, 20, 24, 516, 520, 524, 528, 532, 536, 540, 1024, 1028, 1032, 1036, 1040, 1044, 1048, 1052, 1056, 1540, 1544, 1548, 1552, 1556, 1560, 1564, 2056, 2060, 2064, 2068, 2072, 2572, 2576, 2580, 3088

#This is the outline of a bonus point icon relative to where it is on the screen, we use this for collision detection
pointsOutline: .word 8, 516, 520, 524, 1024, 1028, 1032, 1036, 1040, 1540, 1544, 1548, 2056

.text
#Note that from this point on I refer to groups of lables and code blocks as functions this does not mean that they are funtions as in C,
#Java or any other programming language but that I consider these lables and code blocks to work together to accomplish a specific task for the 
#whole program. A brief description of this task is placed before the code begins.

############################## Main FUNCTION ############################## 
#This is where the main game loop runs, it has all the logic for the game to run and uses the other funtions to 
#accomplish this task

Main:	
	jal Welcome		#Print the welcome screen
	
WelcomeLoop:
	li $t9, 0xffff0000	#Check if key pressed
	lw $t7, 0($t9)
	
	bne $t7, 1, WelcomeLoop
	lw $t7, 4($t9) 		
	j WelcomeEnd		#If any key was pressed go to the WelcomeEnd, the game starts

WelcomeEnd:	
	jal ClearScreen		#Clear the welcome screen

	jal DrawBanner		#Draw the top banner for the game
	
	lw $t0, shipPos		#Will use $t0 to store the position of the ship for the game
	addi $t2, $zero, 0	#Will use $t2 as a counter to regulate spawining
	
	li $v0, 42		#Random number to determine when to spawn
	li $a0, 0
	li $a1, spawnRange
	syscall
	
	addi $a0, $a0, minSpawnInterval
	
	addi $t3, $a0, 0		#Will use $t3 to randomize spawning
	addi $t5, $zero, defaultHealth	#Will use $t5 to store health of the ship 
	addi $t6, $zero, 0 		#Score of the ship
	addi $t8, $zero, 0		#Counter for when score increases
	
GameLoop:				#Start of the actual game
	addi $sp, $sp, -4		
	sw $t1, 0($sp)
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	addi $sp, $sp, -4
	sw $t5, 0($sp)
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	
	jal CollisionCheck	#Check for possible collision with asteroid
	
	lw $t5, 0($sp) 		#Load the updated lives after checking for collision
	addi $sp, $sp, 4
	lw $t0, 0($sp) 		
	addi $sp, $sp, 4
	lw $t1, 0($sp) 		
	addi $sp, $sp, 4
	
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	addi $sp, $sp, -4
	sw $t5, 0($sp)
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	
	jal LifeCollisionCheck	#Check for possible collision with life icon
	
	lw $t5, 0($sp) 		#Load the updated lives after checking for collision
	addi $sp, $sp, 4
	lw $t0, 0($sp) 		
	addi $sp, $sp, 4
	lw $t1, 0($sp) 		
	addi $sp, $sp, 4

	addi $sp, $sp, -4
	sw $t1, 0($sp)
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	addi $sp, $sp, -4
	sw $t6, 0($sp)
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	
	jal BonusPointsCollisionCheck	#Check for possible collision with bonus points icon
	
	lw $t6, 0($sp) 		#Load the updated points after checking for collision
	addi $sp, $sp, 4
	lw $t0, 0($sp) 		
	addi $sp, $sp, 4
	lw $t1, 0($sp) 		
	addi $sp, $sp, 4
		
	li $t9, 0xffff0000	#Check if key pressed
	lw $t7, 0($t9)
	
	bne $t7, 1, KeyCheckEnd
	lw $t7, 4($t9) 		#Get the key pressed value
	
	addi $t1, $zero, 0	#Store the movement of the ship
	
Up:
	bne $t7, 0x77, Down 			# ASCII code of 'w' is 0x77
	ble $t0, shipTop, ExecuteReDraw 	#If the ship is on the top boundry stop it from going up
	addi $t1, $zero, shipUp 		#Store up movement
	j ExecuteReDraw				
	
Down:
	bne $t7, 0x73, Left 			# ASCII code of 's' is 0x73 
	addi $t4, $t0, shipLength	
	bge $t4, bottomLeft, ExecuteReDraw 	#If the length passes the bottom boundry then stop the ship from moving more down
	addi $t1, $zero, shipDown 		#Store down movement
	j ExecuteReDraw
	
Left:
	bne $t7, 0x61, Right 			# ASCII code of 'a' is 0x41
	
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	
	jal CheckIfLeftEdge			#Checks if the asteroid is at the left side of the screen if so we will not move left
	
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	beq $s0, $zero, ExecuteReDraw
	
	addi $t1, $zero, shipLeft		#Store left movement
	j ExecuteReDraw
		
Right:
	bne $t7, 0x64, Restart 			# ASCII code of 'd' is 0x44
	
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	
	jal CheckIfRightEdge			#Checks if the asteroid is at the right side of the screen if so we will not move right
	
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	beq $s0, $zero, ExecuteReDraw
	
	addi $t1, $zero, shipRight		#Store right movement
	j ExecuteReDraw
	
Restart:
	bne $t7, 0x70, Beginning 		# ASCII code of 'p' is 0x70
	
	addi $t5, $zero, 5			#Reset lives to 5
	addi $t6, $zero, 0			#Reset Score to 0
	
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	
	jal ClearShip				#Clear the ship
	lw $t0, shipPos				#Reset ship position to default position
	
	jal Reset				#Remove all asteroids and any lives or bonus point icons on the screen
		
	j WelcomeEnd				#Restart from right after the welcome screen
	
Beginning:
	bne $t7, 0x6F, Over			#ASCII code of 'o' is 0x6F
	
	addi $t5, $zero, 5			#Reset lives to 5
	addi $t6, $zero, 0			#Reset Score to 0
	
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	
	jal ClearShip				#Clear the ship
	lw $t0, shipPos
	
	jal Reset				#Remove all asteroids and any lives or bonus point icons on the screen
		
	jal ClearScreen				#Clear the screen
	
	j Main					#Go to top of program
	
Over:
	bne $t7, 0x69, KeyCheckEnd		#ASCII code of 'i' is 0x69
	
	addi $t5, $zero, gameOverPos 
	addi $sp, $sp, -4
	sw $t5, 0($sp)
	
	j GameOver				#Go to GameOver

ExecuteReDraw:
	addi $sp, $sp, -4			
	sw $t0, 0($sp)
	jal ClearShip			#Clearing the ship for redraw
	add $t0, $t0, $t1
	
KeyCheckEnd:	
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	
	jal DrawShip			#Draw ship
	
	addi $t8, $t8, 1
	
	addi $sp, $sp, -4
	sw $t5, 0($sp)
	jal Health			#Draw the health bar
	
	bgt $t5, $zero, GameContinue	#If lives are zero game is over otherwise continue
	
	addi $t5, $zero, gameOverPos 
	addi $sp, $sp, -4
	sw $t5, 0($sp)
	
	j GameOver			#Go to GameOver
	
GameContinue:
	bne $t8, scoreUpdateCycle, SkipScoreUpdate	#Check if score should increase
	addi $t6, $t6, 1				#Increment score
	
	addi $s6, $zero, 1
	
	addi $t8, $zero, score
	addi $sp, $sp, -4
	sw $t8, 0($sp)
	
	addi $sp, $sp, -4
	sw $t6, 0($sp)
	
	jal Score					#Update score
	
	addi $t8, $zero, 0				#Reset to zero

SkipScoreUpdate:	
	bne $s6, spawnControl, GameLoopEnd		#Check if should spawn
	addi $s6, $zero, 0				#Set to zero
	
	addi $t2, $t2, 1				#Increment counter for spawining
	
	addi $sp, $sp, -4
	sw $t6, 0($sp)
		
	jal IsLifeMultiple				#Check if it is time to spawn a life
	
	lw $s7, 0($sp) 		
	addi $sp, $sp, 4
	
	bne $s7, 1, SkipLifeSpawn
	
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	addi $sp, $sp, -4
	sw $t2, 0($sp)
		
	jal SpawnLife					#Spawn the life
	
	lw $t2, 0($sp) 		
	addi $sp, $sp, 4
	lw $t1, 0($sp) 		
	addi $sp, $sp, 4
	
SkipLifeSpawn:	
	addi $sp, $sp, -4
	sw $t6, 0($sp)
		
	jal IsBonusPointsMultiple			#Check if it is time to spawn a bonus point icon
	
	lw $s7, 0($sp) 		
	addi $sp, $sp, 4
	
	bne $s7, 1, SkipBonusPointsSpawn
	
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	addi $sp, $sp, -4
	sw $t2, 0($sp)
		
	jal SpawnBonusPoints				#Spawn the bonus points
	
	lw $t2, 0($sp) 		
	addi $sp, $sp, 4
	lw $t1, 0($sp) 		
	addi $sp, $sp, 4

SkipBonusPointsSpawn:
	ble $t6, gameBuffer, GameLoopEnd		#Give user time to prepare for the game to start
	
	jal ClearAsteroids	#Clear the asteroids 
	
	jal MoveAsteroids	#Move the asteroids left
	
	jal DrawAsteroids	#Draw the asteroids 
	
	jal MoveLife		#Move the life left
		
	jal MoveBonusPoints	#Move the bonus points left
			
	blt $t2, $t3, GameLoopEnd	#If the spawining counter does not match the number to determine when to spawn go to end of loop	
	addi $t2, $zero, 0		#Set counter to zero
	
	li $v0, 42			#Generate new random numbe to keep spawining randomized
	li $a0, 0
	li $a1, spawnRange
	syscall
	
	addi $a0, $a0, minSpawnInterval
	addi $t3, $a0, 0
		
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	addi $sp, $sp, -4
	sw $t2, 0($sp)
		
	jal SpawnAsteroid		#Spawn the asteroid
	
	lw $t2, 0($sp) 		
	addi $sp, $sp, 4
	lw $t1, 0($sp) 		
	addi $sp, $sp, 4

GameLoopEnd:
	bgt $t6, hardMode, HardMode		#If over hardMode then game is in hard mode
	
	li $v0, 32
	li $a0, easyFrameRate 		# Wait easyFrameRate milliseconds before next loop
	syscall	
	j GameLoop
	
HardMode:
	bgt $t6, extraHardMode, ExtraHardMode
	li $v0, 32
	li $a0, hardFrameRate 		# Wait hardFrameRate milliseconds before next loop
	syscall	
	j GameLoop
	
ExtraHardMode:	
	li $v0, 32
	li $a0, extraHardFrameRate 		# Wait extraHardFrameRate milliseconds before next loop
	syscall	
	j GameLoop

############################## DrawShip FUNCTION ############################## 
#This function draws the ship by taking in a position

DrawShip: 
	lw $a0, 0($sp) 		# $a0 stores the base address for display
	addi $sp, $sp, 4

	li $a1, 0xFFFFFF  	# $a1 stores the white colour code
	li $a2, 0xa4161a  	# $a2 stores the red colour code
	
	#Note each "group" of units represents one row in the Bitmap Display, groups are separated by spaces
	
	sw $a2, 12($a0)		#Red outline of the top wing
	sw $a2, 528($a0)	
	sw $a2, 1044($a0)	
	sw $a2, 1560($a0)
	
	sw $a2, 520($a0)	#Red outline for the left side of the top wing
	sw $a2, 1032($a0)	
	sw $a2, 1544($a0)	
	
	sw $a1, 524($a0)	#White portion of the top wing
	sw $a1, 1036($a0)	
	sw $a1, 1548($a0)	
	
	sw $a1, 1040($a0)	#White portion of the top wing
	sw $a1, 1552($a0)	
	
	sw $a1, 1556($a0)	#White portion of the top wing
	
	sw $a2, 2052($a0)	#Body outline in red
	sw $a2, 2056($a0)	
	sw $a2, 2060($a0)	
	sw $a2, 2064($a0)	
	sw $a2, 2068($a0)	
	sw $a1, 2072($a0)	#White portion of the body
	
	sw $a1, 2564($a0)	#White protion of the body
	sw $a1, 2568($a0)	
	sw $a1, 2572($a0)	
	sw $a1, 2576($a0)	
	sw $a1, 2580($a0)	
	sw $a1, 2584($a0)	
	
	sw $a1, 3076($a0)	#White portion of the body
	sw $a1, 3080($a0)	
	sw $a1, 3084($a0)	
	sw $a1, 3088($a0)	
	sw $a1, 3092($a0)	
	sw $a1, 3096($a0)	

	sw $a2, 2560($a0)	#White portion of the body
	sw $a2, 3072($a0)	

	sw $a2, 3588($a0)	#Body outline in red
	sw $a2, 3592($a0)	
	sw $a2, 3596($a0)	
	sw $a2, 3600($a0)	
	sw $a2, 3604($a0)	
	sw $a1, 3608($a0)	
	
	sw $a2, 4104($a0)	#Bottom wing red left portion
	sw $a2, 4616($a0)	
	sw $a2, 5128($a0)	
	
	sw $a1, 4108($a0)	#Bottom wing white portion
	sw $a1, 4620($a0)	
	sw $a1, 5132($a0)	

	sw $a1, 4112($a0)	#Bottom wing white portion
	sw $a1, 4624($a0)	
	
	sw $a1, 4116($a0)	#Bottom wing white portion

	sw $a2, 5644($a0)	#Bottom wing red outline 
	sw $a2, 5136($a0)	
	sw $a2, 4628($a0)	
	sw $a2, 4120($a0)	
	
	sw $a2, 3612($a0)	#Head portion in red
	sw $a2, 3100($a0)	
	sw $a2, 2588($a0)	
	sw $a2, 2076($a0)		
	
	jr $ra

############################## ClearShip FUNCTION ############################## 
#This function clears the ship by taking in a position

ClearShip:
	lw $a0, 0($sp) 		# $a0 stores the base address for display
	addi $sp, $sp, 4

	li $a1, 0x000000  	# $a2 stores the black colour code
	
	#Note each "group" of units represents one row in the Bitmap Display, groups are separated by spaces
	#Note that everything is being turned to black so it is erased
	
	sw $a1, 12($a0)		#Erase the Red outline of the top wing
	sw $a1, 528($a0)	
	sw $a1, 1044($a0)	
	sw $a1, 1560($a0)
	
	sw $a1, 520($a0)	#Erase the Red outline for the left side of the top wing
	sw $a1, 1032($a0)	
	sw $a1, 1544($a0)	
	
	sw $a1, 524($a0)	#Erase the White portion of the top wing
	sw $a1, 1036($a0)	
	sw $a1, 1548($a0)	
	
	sw $a1, 1040($a0)	#Erase the White portion of the top wing
	sw $a1, 1552($a0)	
	
	sw $a1, 1556($a0)	#Erase the White portion of the top wing
	
	sw $a1, 2052($a0)	#Erase the Body outline in red
	sw $a1, 2056($a0)	
	sw $a1, 2060($a0)	
	sw $a1, 2064($a0)	
	sw $a1, 2068($a0)	
	sw $a1, 2072($a0)	#Erase the White portion of the body
	
	sw $a1, 2564($a0)	#Erase the White protion of the body
	sw $a1, 2568($a0)	
	sw $a1, 2572($a0)	
	sw $a1, 2576($a0)	
	sw $a1, 2580($a0)	
	sw $a1, 2584($a0)	
	
	sw $a1, 3076($a0)	#Erase the White portion of the body
	sw $a1, 3080($a0)	
	sw $a1, 3084($a0)	
	sw $a1, 3088($a0)	
	sw $a1, 3092($a0)	
	sw $a1, 3096($a0)	

	sw $a1, 2560($a0)	#Erase the White portion of the body
	sw $a1, 3072($a0)	

	sw $a1, 3588($a0)	#Erase the Body outline in red
	sw $a1, 3592($a0)	
	sw $a1, 3596($a0)	
	sw $a1, 3600($a0)	
	sw $a1, 3604($a0)	
	sw $a1, 3608($a0)	
	
	sw $a1, 4104($a0)	#Erase the Bottom wing red left portion
	sw $a1, 4616($a0)	
	sw $a1, 5128($a0)	
	
	sw $a1, 4108($a0)	#Erase the Bottom wing white portion
	sw $a1, 4620($a0)	
	sw $a1, 5132($a0)	

	sw $a1, 4112($a0)	#Erase the Bottom wing white portion
	sw $a1, 4624($a0)	
	
	sw $a1, 4116($a0)	#Erase the Bottom wing white portion

	sw $a1, 5644($a0)	#Erase the Bottom wing red outline 
	sw $a1, 5136($a0)	
	sw $a1, 4628($a0)	
	sw $a1, 4120($a0)	
	
	sw $a1, 3612($a0)	#Erase the Head portion in red
	sw $a1, 3100($a0)	
	sw $a1, 2588($a0)	
	sw $a1, 2076($a0)		
	
	jr $ra

############################## DrawAsteroid FUNCTION ############################## 
#This function draws an asteroid by taking in a position

DrawAsteroid:
	lw $a0, 0($sp) 		# $a0 stores the base address for asteroid
	addi $sp, $sp, 4
	
	li $a1, 0x848884  	# $a1 stores the light grey colour code
	li $a2, 0x71797E  	# $a2 stores the dark grey colour code
	
	#Note each "group" of units represents one row in the Bitmap Display, groups are separated by spaces
	
	sw $a2, 4($a0)		#Top dark grey
	sw $a2, 8($a0)	
	sw $a2, 12($a0)	
	sw $a2, 16($a0)
	
	sw $a2, 512($a0)	#Left dark grey	
	sw $a2, 1024($a0)	
	sw $a2, 1536($a0)	
	sw $a2, 2048($a0)
	
	sw $a1, 516($a0)	#Light grey interior
	sw $a1, 520($a0)	
	sw $a1, 524($a0)	
	sw $a1, 528($a0)
	
	sw $a1, 1028($a0)	#Light grey interior
	sw $a1, 1032($a0)	
	sw $a1, 1036($a0)	
	sw $a1, 1040($a0)
	
	sw $a1, 1540($a0)	#Light grey interior
	sw $a1, 1544($a0)	
	sw $a1, 1548($a0)	
	sw $a1, 1552($a0)
	
	sw $a1, 2052($a0)	#Light grey interior
	sw $a1, 2056($a0)	
	sw $a1, 2060($a0)	
	sw $a1, 2064($a0)
	
	sw $a2, 532($a0)	#Right dark grey
	sw $a2, 1044($a0)	
	sw $a2, 1556($a0)	
	sw $a2, 2068($a0)
	
	sw $a2, 2564($a0)	#Bottom dark grey
	sw $a2, 2568($a0)	
	sw $a2, 2572($a0)	
	sw $a2, 2576($a0)
	
	jr $ra

############################## ClearAsteroid FUNCTION ############################## 
#This function clears an asteroid by taking in a position

ClearAsteroid:
	lw $a0, 0($sp) 		# $a0 stores the base address for asteroid
	addi $sp, $sp, 4

	li $a1, 0x000000  	# $a1 stores the black colour code
	
	#Note each "group" of units represents one row in the Bitmap Display, groups are separated by spaces
	
	sw $a1, 0($a0)		#Erase the top
	sw $a1, 4($a0)		
	sw $a1, 8($a0)	
	sw $a1, 12($a0)	
	sw $a1, 16($a0)
	sw $a1, 20($a0)
	
	sw $a1, 512($a0)	#Erase the left
	sw $a1, 1024($a0)	
	sw $a1, 1536($a0)	
	sw $a1, 2048($a0)
	
	sw $a1, 516($a0)	#Erase the light grey interior
	sw $a1, 520($a0)	
	sw $a1, 524($a0)	
	sw $a1, 528($a0)
	
	sw $a1, 1028($a0)	#Erase the light grey interior
	sw $a1, 1032($a0)	
	sw $a1, 1036($a0)	
	sw $a1, 1040($a0)
	
	sw $a1, 1540($a0)	#Erase the light grey interior
	sw $a1, 1544($a0)	
	sw $a1, 1548($a0)	
	sw $a1, 1552($a0)
	
	sw $a1, 2052($a0)	#Erase the light grey interior
	sw $a1, 2056($a0)	
	sw $a1, 2060($a0)	
	sw $a1, 2064($a0)
	
	sw $a1, 532($a0)	#Erase the left
	sw $a1, 1044($a0)	
	sw $a1, 1556($a0)	
	sw $a1, 2068($a0)
	
	sw $a1, 2560($a0)	#Erase the bottom
	sw $a1, 2564($a0)	
	sw $a1, 2568($a0)	
	sw $a1, 2572($a0)	
	sw $a1, 2576($a0)
	sw $a1, 2580($a0)
	
	jr $ra
	
############################## AsteroidExplode FUNCTION ############################## 
#This function makes the asteroid explode drawing at a specific position
	
AsteroidExplode:
	lw $a0, 0($sp) 		# $a0 stores the base address for asteroid
	addi $sp, $sp, 4
	
	li $a1, 0xE25822  	# $a1 stores the red colour code
	li $a2, 0xF1BC31  	# $a2 stores the orange colour code
	li $a3, 0xF6F052	# $a3 stores the yellow colour code
	li $s0, 0x000000	# $a3 stores the black colour code
	
	#Note each "group" of units represents one row in the Bitmap Display, groups are separated by spaces
	#This function erases some portions of an already drawn asteroid and draws an explosion overtop of the rest
	
	sw $a1, 0($a0)		
	sw $a3, 4($a0)		
	sw $s0, 8($a0)	
	sw $s0, 12($a0)	
	sw $a3, 16($a0)
	
	sw $a3, 512($a0)	
	sw $s0, 1024($a0)	
	sw $s0, 1536($a0)	
	sw $a2, 2048($a0)
	sw $a1, 2560($a0)	
	
	sw $a3, 516($a0)	
	sw $a2, 520($a0)	
	sw $a1, 524($a0)	
	sw $a2, 528($a0)
	
	sw $a3, 1028($a0)	
	sw $a3, 1032($a0)	
	sw $a2, 1036($a0)	
	sw $a3, 1040($a0)
	
	sw $a3, 1540($a0)	
	sw $a2, 1544($a0)	
	sw $a3, 1548($a0)	
	sw $a2, 1552($a0)
	
	sw $a2, 2052($a0)	
	sw $a1, 2056($a0)	
	sw $a2, 2060($a0)	
	sw $a2, 2064($a0)
	
	sw $a1, 20($a0)
	sw $a2, 532($a0)	
	sw $s0, 1044($a0)	
	sw $s0, 1556($a0)	
	sw $a1, 2068($a0)	
	
	sw $a3, 2564($a0)	
	sw $s0, 2568($a0)	
	sw $s0, 2572($a0)	
	sw $a1, 2576($a0)
	sw $a2, 2580($a0)
	
	jr $ra

############################## SpawnAsteroid FUNCTION ############################## 
#This function spawns an asteroid

SpawnAsteroid:
	addi $sp, $sp, -4			#Loads $ra to stack to keep for jumping back later
	sw $ra, 0($sp)
			
	li $v0, 42
	li $a0, 0
	li $a1, spawnLocationRange
	syscall
	
	addi $a2, $zero, 512
	addi $a0, $a0, minSpawnLocationInterval
	mult $a2, $a0
	mflo $a2
	addi $a2, $a2, asteroidRight		#Calculate postion to spawn
	
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	
	jal AddToAsteroids			#Add to asteroid array
	
	lw $a2, 0($sp)
	addi $sp, $sp, 4
	
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	
	jal DrawAsteroid			#Draw the asteroid

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra	

############################## AddToAsteroids FUNCTION ############################## 
#This function adds an asteroid to the asteroid array

AddToAsteroids:
	lw $a0, 0($sp) 		
	addi $sp, $sp, 4
	
	la $a1, asteroids		#Load the array
	addi $a2, $zero, defaultX	#Load the default value
	
AddLoop:
	lw $a3, 0($a1)
	bne $a3, $a2, AddLoopIncrement 	#If the asteroid at that position does not have default value then go to next asteroid
	
	sw $a0, 0($a1)			#If default value then place new asteroid in spot and break
	jr $ra
	
AddLoopIncrement:
	addi $a1, $a1, 4		#Increment loop
	j AddLoop
	
############################## ClearMoveAsteroid FUNCTION ############################## 
#This function clears an asteroid that is moving, it takes in a postion
#This is done to minimize fickering and make the graphics clearer

ClearMoveAsteroid:
	lw $a0, 0($sp) 		# $a0 stores the base address for asteroid
	addi $sp, $sp, 4

	li $a1, 0x000000  	# $a1 stores the black colour code
	li $a2, 0x71797E  	# $a2 stores the dark grey colour code
	
	#Note each "group" of units represents one row in the Bitmap Display, groups are separated by spaces
	#We clear the back dark grey position and the portion of the bottom and top
	sw $a1, 16($a0)
	sw $a1, 20($a0)
	
	sw $a1, 532($a0)	
	sw $a1, 1044($a0)	
	sw $a1, 1556($a0)	
	sw $a1, 2068($a0)
		
	sw $a1, 2576($a0)
	sw $a1, 2580($a0)
	
	sw $a2, 528($a0)	#Turn the last light grey area to dark grey
	sw $a2, 1040($a0)
	sw $a2, 1552($a0)
	sw $a2, 2064($a0)
	
	jr $ra

############################## ClearAsteroids FUNCTION ############################## 
#This function clears the asteroids
	
ClearAsteroids:
	la $a0, asteroids		#Load the asteroid array
	addi $a1, $zero, defaultX	#Load the default value
	addi $a2, $zero, 0
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
AsteroidsClearLoop: 
	beq $a2, 100, AsteroidsClearLoopExit	#If loop through all 100 then done
	addi $a2, $a2, 1
	
	lw $a3, 0($a0)
	beq $a3, $a1, AsteroidsClearLoopEnd	#If default value then do not clear
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	
	jal ClearMoveAsteroid		#Clear the asteroid it is moving at this point
	
	lw $a3, 0($sp)
	addi $sp, $sp, 4
	lw $a2, 0($sp)
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
AsteroidsClearLoopEnd:
	addi $a0, $a0, 4		#Next asteroid
	j AsteroidsClearLoop
	
AsteroidsClearLoopExit:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
############################## DrawMoveAsteroid FUNCTION ############################## 
#This function draws an asteroid that is moving
#This is done to fix flickering

DrawMoveAsteroid:
	lw $a0, 0($sp) 		# $a0 stores the base address for asteroid
	addi $sp, $sp, 4

	li $a1, 0x848884  	# $a1 stores the light grey colour code
	li $a2, 0x71797E  	# $a2 stores the dark grey colour code
	
	#Note each "group" of units represents one row in the Bitmap Display, groups are separated by spaces
	#We draw the front again and add a little to the top and bottom
	sw $a2, 4($a0)
	
	sw $a2, 512($a0)
	sw $a2, 1024($a0)
	sw $a2, 1536($a0)
	sw $a2, 2048($a0)
	
	sw $a2, 2564($a0)
	
	sw $a1, 516($a0)
	sw $a1, 1028($a0)
	sw $a1, 1540($a0)
	sw $a1, 2052($a0)
	
	jr $ra
	
############################## DrawAsteroids FUNCTION ############################## 
#This function draws the asteroids that are moving
	
DrawAsteroids:
	la $a0, asteroids		#Load the asteroid array
	addi $a1, $zero, defaultX	#Load the default value
	addi $a2, $zero, 0
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
DrawLoop: 
	beq $a2, 100, DrawLoopExit	#If loop through all 100 then done
	addi $a2, $a2, 1
	
	lw $a3, 0($a0)
	beq $a3, $a1, DrawLoopEnd	#If default value then do not move
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	
	jal DrawMoveAsteroid		#Draw the asteroid, it is moving at this point
	
	lw $a3, 0($sp)
	addi $sp, $sp, 4
	lw $a2, 0($sp)
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	
	jal CheckIfLeftEdge		#Checks if the asteroid is at the left side of the screen if it is then we will clear it fully
	
	lw $a3, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	lw $a2, 0($sp)
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	bne $s0, $zero, DrawLoopEnd

Remove:					#If the asteroid reached the end of the screen it is removed
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	
	jal RemoveFromAsteroids		#Remove from the asteroid array
	
	lw $a3, 0($sp)
	addi $sp, $sp, 4
	lw $a2, 0($sp)
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	
	jal ClearAsteroid		#Clear the asteroid fully
	
	lw $a3, 0($sp)
	addi $sp, $sp, 4
	lw $a2, 0($sp)
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
DrawLoopEnd:
	addi $a0, $a0, 4		#Next asteroid
	j DrawLoop
	
DrawLoopExit:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
############################## MoveAsteroids FUNCTION ############################## 
#This function moves the asteroids
	
MoveAsteroids:
	la $a0, asteroids		#Load the asteroid array
	addi $a1, $zero, defaultX	#Load the default value
	addi $a2, $zero, 0
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
MoveLoop: 
	beq $a2, 100, MoveLoopExit	#If loop through all 100 then done
	addi $a2, $a2, 1
	
	lw $a3, 0($a0)
	beq $a3, $a1, MoveLoopEnd	#If default value then do not move
	
	addi $a3, $a3, asteroidMove	#Move the asteroid
	sw $a3, 0($a0)
	
MoveLoopEnd:
	addi $a0, $a0, 4		#Next asteroid
	j MoveLoop
	
MoveLoopExit:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
############################## Reset FUNCTION ############################## 
#This function resets the asteroids and the life or bonus points if there are any
	
Reset:
	addi $a1, $zero, 0		
	la $a2, asteroids		#Load the asteroids
	addi $a3, $zero, defaultX	#Load the default value
	
	addi $sp, $sp, -4
	sw $ra, 0($sp) 

ResetLoop:
	beq $a1, 100, ResetExit		#If reset all 100 then done
	addi $a1, $a1, 1
	
	lw  $a0, 0($a2)
	beq $a0, $a3, ResetLoopEnd	#If default then skip
	
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal ClearAsteroid		#Clear the asteroid fully
	
	lw $a3, 0($sp)
	addi $sp, $sp, 4
	lw $a2, 0($sp)
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	
	sw $a3, 0($a2)			#Place default value in that position in the array
	
ResetLoopEnd:
	addi $a2, $a2, 4		#Next asteroid
	j ResetLoop
	
ResetExit:
	la $a0, life			#Load the life
	lw $a2, 0($a0)			#Load the positon

	addi $sp, $sp, -4
	sw $a2, 0($sp)
	
	jal ClearLife			#Clear the life
	
	la $a0, life
	addi $a1, $zero, defaultX	#Place the default value where the life pointer is pointing
	sw $a1, 0($a0)
	
	la $a0, points			#Load the bonus points
	
	lw $a2, 0($a0)

	addi $sp, $sp, -4
	sw $a2, 0($sp)
	
	jal ClearBonusPoints		#Clear the bonus points
	
	la $a0, points
	addi $a1, $zero, defaultX		
	sw $a1, 0($a0)			#Place the default value where the bonus points pointer is pointing
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
############################## RemoveFromAsteroids FUNCTION ############################## 
#This function removes an asteroid from the asteroid array 
		
RemoveFromAsteroids:
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	
	la $a1, asteroids		#Load asteroids array
	addi $a2, $zero, defaultX	#Load default value
	
RemoveAsteroidsLoop:
	lw $a3, 0($a1)
	
	bne $a3, $a0, RemoveAsteroidsLoopEnd	#Check if it is the asteroid we are looking for if not skip
	
	sw $a2, 0($a1)				#If it is then set to default value and break
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
RemoveAsteroidsLoopEnd:
	addi $a1, $a1, 4			#Increment loop
	j RemoveAsteroidsLoop
	
############################## CheckIfLeftEdge FUNCTION ############################## 
#This function checks if the asteroid is at the edge of the screen by taking in a position
#Returns zero if on edge and one if not
	
CheckIfLeftEdge:
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	addi $a1, $zero, topLeft		#Load the topLeft of the screen
	addi $a2, $zero, 1
	
CheckLeftLoop:	
	bgt $a1, $a0, CheckLeftExit		#If the pixel we chck is greater than the position then we break
	bne $a1, $a0, CheckLeftEnd		#If it is on the edge then continue
	addi $a2, $zero, 0			#Return zero to show that it is on the edge
	j CheckLeftExit
	
CheckLeftEnd:
	addi $a1, $a1, nextDown			#Increment loop, note that we go to the next pixel down
	j CheckLeftLoop
	
CheckLeftExit:	
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jr $ra
	
############################## CheckIfRightEdge FUNCTION ############################## 
#This function checks if the asteroid is at the edge of the screen, takes in ship position
#Returns zero to show that it is or one if it is not
	
CheckIfRightEdge:
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	addi $a0, $a0, shipWidth		#Load the width of the ship, we need to check if the from is at the edge but the top left is default
	addi $a1, $zero, topRight		#Load the top right
	addi $a2, $zero, 1
	addi $a3, $zero, bottomRight
	
CheckRightLoop:	
	beq $a1,$a3 , CheckRightExit		#If it is not on the edge exit
	bne $a1, $a0, CheckRightEnd		#If it is on the edge then continue
	addi $a2, $zero, 0			#Return zero to show that it is on the edge
	j CheckRightExit
	
CheckRightEnd:
	addi $a1, $a1, nextDown			#Increment loop
	j CheckRightLoop
	
CheckRightExit:	
	addi $a0, $a0, -28
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jr $ra
	
############################## CollisionCheck FUNCTION ############################## 
#This function checks if there is a possible collision between the ship and an asteroid
#It takes in the ship position and health and returns the updated health

CollisionCheck:
	lw $a0, 0($sp)		#shippos
	addi $sp, $sp, 4
	lw $a1, 0($sp)		#health
	addi $sp, $sp, 4
	
	addi $sp, $sp, -4	
	sw $ra, 0($sp)
	
	la $a2, asteroids	#Load the asteroid array
	
	addi $a3, $zero, 0
	
CollisionCheckLoop:
	beq $a3, 100, CollisionCheckExit		#If all 100 checked then done
	addi $a3, $a3, 1
	
	lw $t0, 0($a2)
	beq $t0, defaultX, CollisionCheckLoopEnd	#If default value then quit
	
	#Note that we want to make collision detection as tight as possible to stop unneccessary checking so I made a shape around
	#the ship, this shape is like a boundry and if anything crosses that boundry then that is checked
	#In every check we have a top value that value is relative to the ship we are defining a boundry 
	#The bottom value is defining the position relative to the object we are checking 
	#Refer to top check one and top check one p2 for an example
	#We use this idea for all of the collision detection
	
	addi $t1, $t0, bottomRightAsteroid
	blt $t1, $a0, CollisionCheckLoopEnd
	
TopCheckOne:	
	addi $t1, $a0, frontOne			#No bottom value this is the boundry for the tip of the wing if this boundry
	bgt $t0, $t1, TopCheckOnePTwo		#Is crossed we check for collision
	
	j TopCheckTwo
	
TopCheckOnePTwo:
	addi $t1, $a0, bottomOne			#This is the top value it is the boundry
	addi $s4, $t0, topRightAsteroid			#This is the bottom value it defines boundry of the object if the two cross we check
	blt $s4, $t1, CollisionCheckLoopEnd 

TopCheckTwo:
	addi $t1, $a0, frontTwo
	bgt $t0, $t1, TopCheckTwoPTwo
	
	j TopCheckThree
	
TopCheckTwoPTwo:
	addi $t1, $a0, bottomTwo
	addi $s4, $t0, topRightAsteroid
	blt $s4, $t1, CollisionCheckLoopEnd  
	
TopCheckThree:
	addi $t1, $a0, frontThree
	bgt $t0, $t1, TopCheckThreePTwo
	
	j TopCheckFour
	
TopCheckThreePTwo:
	addi $t1, $a0, bottomThree
	addi $s4, $t0, topRightAsteroid
	blt $s4, $t1, CollisionCheckLoopEnd
	
TopCheckFour:
	addi $t1, $a0, frontFour
	bgt $t0, $t1, TopCheckFourPTwo
	
	j TopCheckFive
	
TopCheckFourPTwo:
	addi $t1, $a0, bottomFour
	addi $s4, $t0, topRightAsteroid
	blt $s4, $t1, CollisionCheckLoopEnd
	
TopCheckFive:
	addi $t1, $a0, frontFive
	bgt $t0, $t1, TopCheckFivePTwo
	
	j TopCheckSix
	
TopCheckFivePTwo:
	addi $t1, $a0, bottomFive
	addi $s4, $t0, topRightAsteroid
	blt $s4, $t1, CollisionCheckLoopEnd 
	
TopCheckSix:
	addi $t1, $a0, frontSix
	bgt $t0, $t1, TopCheckSixPTwo
	
	j TopCheckSeven
	
TopCheckSixPTwo:
	addi $t1, $a0, bottomSix
	addi $s4, $t0, topRightAsteroid
	blt $s4, $t1, CollisionCheckLoopEnd
	
TopCheckSeven:
	addi $t1, $a0, frontSeven
	bgt $t0, $t1, TopCheckSevenPTwo
	
	j TopCheckEight
	
TopCheckSevenPTwo:
	addi $t1, $a0, bottomSeven
	addi $s4, $t0, topRightAsteroid
	blt $s4, $t1, CollisionCheckLoopEnd
	
TopCheckEight:
	addi $t1, $a0, frontEight
	bgt $t0, $t1, TopCheckEightPTwo
	
	j TopCheckNine
	
TopCheckEightPTwo:
	addi $t1, $a0, bottomEight
	addi $s4, $t0, topRightAsteroid
	blt $s4, $t1, CollisionCheckLoopEnd
	
TopCheckNine:
	addi $t1, $a0, frontNine
	bgt $t0, $t1, TopCheckNinePTwo
	
	j TopCheckTen
	
TopCheckNinePTwo:
	addi $t1, $a0, bottomNine
	addi $s4, $t0, topRightAsteroid
	blt $s4, $t1, CollisionCheckLoopEnd
	
TopCheckTen:
	addi $t1, $a0, frontTen
	bgt $t0, $t1, TopCheckTenPTwo
	
	j TopCheckEleven
	
TopCheckTenPTwo:
	addi $t1, $a0, bottomTen
	addi $s4, $t0, topRightAsteroid
	blt $s4, $t1, CollisionCheckLoopEnd 
	
TopCheckEleven:
	addi $t1, $a0, frontEleven
	bgt $t0, $t1, TopCheckElevenPTwo
	
	j BottomCheckOne
	
TopCheckElevenPTwo:
	addi $t1, $a0, bottomEleven
	addi $s4, $t0, topRightAsteroid
	blt $s4, $t1, CollisionCheckLoopEnd
	
BottomCheckOne:	
	addi $t1, $a0, frontOne
	addi $s4, $t0, bottomLeftAsteroid
	bgt $s4, $t1, BottomCheckOnePTwo
	
	j BottomCheckTwo
	
BottomCheckOnePTwo:
	addi $t1, $a0, bottomOne	
	addi $s4, $t0, bottomRightAsteroid
	blt $s4, $t1, CollisionCheckLoopEnd 

BottomCheckTwo:
	addi $t1, $a0, frontTwo	
	addi $s4, $t0, bottomLeftAsteroid
	bgt $s4, $t1, BottomCheckTwoPTwo
	
	j BottomCheckThree
	
BottomCheckTwoPTwo:
	addi $t1, $a0, bottomTwo	
	addi $s4, $t0, bottomRightAsteroid
	blt $s4, $t1, CollisionCheckLoopEnd 
	
BottomCheckThree:
	addi $t1, $a0, frontThree	
	addi $s4, $t0, bottomLeftAsteroid
	bgt $s4, $t1, BottomCheckThreePTwo
	
	j BottomCheckFour
	
BottomCheckThreePTwo:
	addi $t1, $a0, bottomThree	
	addi $s4, $t0, bottomRightAsteroid
	blt $s4, $t1, CollisionCheckLoopEnd
	
BottomCheckFour:
	addi $t1, $a0, frontFour	
	addi $s4, $t0, bottomLeftAsteroid
	bgt $s4, $t1, BottomCheckFourPTwo
	
	j BottomCheckFive
	
BottomCheckFourPTwo:
	addi $t1, $a0, bottomFour	
	addi $s4, $t0, bottomRightAsteroid
	blt $s4, $t1, CollisionCheckLoopEnd 
	
BottomCheckFive:
	addi $t1, $a0, frontFive	
	addi $s4, $t0, bottomLeftAsteroid
	bgt $s4, $t1, BottomCheckFivePTwo
	
	j BottomCheckSix
	
BottomCheckFivePTwo:
	addi $t1, $a0, bottomFive	
	addi $s4, $t0, bottomRightAsteroid
	blt $s4, $t1, CollisionCheckLoopEnd 
	
BottomCheckSix:
	addi $t1, $a0, frontSix	
	addi $s4, $t0, bottomLeftAsteroid
	bgt $s4, $t1, BottomCheckSixPTwo
	
	j BottomCheckSeven
	
BottomCheckSixPTwo:
	addi $t1, $a0, bottomSix
	addi $s4, $t0, bottomRightAsteroid
	blt $s4, $t1, CollisionCheckLoopEnd 
	
BottomCheckSeven:
	addi $t1, $a0, frontSeven
	addi $s4, $t0, bottomLeftAsteroid
	bgt $s4, $t1, BottomCheckSevenPTwo
	
	j BottomCheckEight
	
BottomCheckSevenPTwo:
	addi $t1, $a0, bottomSeven
	addi $s4, $t0, bottomRightAsteroid
	blt $s4, $t1, CollisionCheckLoopEnd 
	
BottomCheckEight:
	addi $t1, $a0, frontEight
	addi $s4, $t0, bottomLeftAsteroid
	bgt $s4, $t1, BottomCheckEightPTwo
	
	j BottomCheckNine
	
BottomCheckEightPTwo:
	addi $t1, $a0, bottomEight
	addi $s4, $t0, bottomRightAsteroid
	blt $s4, $t1, CollisionCheckLoopEnd 
	
BottomCheckNine:
	addi $t1, $a0, frontNine
	addi $s4, $t0, bottomLeftAsteroid
	bgt $s4, $t1, BottomCheckNinePTwo
	
	j BottomCheckTen
	
BottomCheckNinePTwo:
	addi $t1, $a0, bottomNine
	addi $s4, $t0, bottomRightAsteroid
	blt $s4, $t1, CollisionCheckLoopEnd 
	
BottomCheckTen:
	addi $t1, $a0, frontTen
	addi $s4, $t0, bottomLeftAsteroid
	bgt $s4, $t1, BottomCheckTenPTwo
	
	j BottomCheckEleven
	
BottomCheckTenPTwo:
	addi $t1, $a0, bottomTen
	addi $s4, $t0, bottomRightAsteroid
	blt $s4, $t1, CollisionCheckLoopEnd 
	
BottomCheckEleven:
	addi $t1, $a0, frontEleven
	addi $s4, $t0, bottomLeftAsteroid
	bgt $s4, $t1, BottomCheckElevenPTwo
	
	j CheckTwelve
	
BottomCheckElevenPTwo:
	addi $t1, $a0, bottomEleven
	addi $s4, $t0, bottomRightAsteroid
	blt $s4, $t1, CollisionCheckLoopEnd 

CheckTwelve:
	addi $t1, $a0, shipBottomRight   
	bgt $t0, $t1, CollisionCheckLoopEnd
	
	addi $sp, $sp, -4	#At this point the boundry was crossed
	sw $a3, 0($sp)
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal CheckOverlap	#Check to see if there is overlap
	
	lw $t1, 0($sp)		#Either 0, -1 for collision check if -1 break 
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a2, 0($sp)
	addi $sp, $sp, 4
	lw $a3, 0($sp)
	addi $sp, $sp, 4
	
	bne $t1, -1, CollisionCheckLoopEnd
	add $a1, $a1, $t1
	j CollisionCheckExit

CollisionCheckLoopEnd:
	addi $a2, $a2, 4	#Next asteroid
	j CollisionCheckLoop
	
CollisionCheckExit:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	
	jr $ra

############################## CheckOverlap FUNCTION ############################## 
#This function checks if the asteroid is overlapping with the ship returns zero if collision -1 if not
#It takes in the ship position and the asteroid position

CheckOverlap:
	lw $a0, 0($sp)			#shippos
	addi $sp, $sp, 4
	lw $a1, 0($sp)			#asteroid position
	addi $sp, $sp, 4
	
	addi $a2, $zero, 0
	addi $a3, $zero, 0
	
	la $t0, shipOutline		#The shipOutline to check for collision
	la $t1, asteroidOutline		#The asteroidOutline to check for collision
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
#We compare the pixels one by one, if they are equal then there is a collision
AsteroidPixelLoop:			
	beq $a2, asteroidOutlineSize, CheckOverlapExit		
	addi $a2, $a2, 1
	lw $s0, 0($t1)
	
	add $s2, $a1, $s0
	addi $a3, $zero, 0
	
ShipPixelLoop:
	beq $a3, shipOutlineSize, AsteroidPixelLoopEnd
	addi $a3, $a3, 1
	lw $s1, 0($t0)
	
	add $s3, $a0, $s1
	
	bne $s3, $s2, ShipPixelLoopEnd		#If not equal then go to next pixel
	
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	
	jal AsteroidExplode			#If the same draw explode
	
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	lw $a2, 0($sp)
	addi $sp, $sp, 4
	lw $a3, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	li $v0, 32
	li $a0, collisionDelay	 		# Wait 50 milliseconds 
	syscall
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	
	jal ClearAsteroid			#Clear the asteroid
	
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	
	jal RemoveFromAsteroids			#Remove from the asteroid array and break
	addi $s0, $zero, -1
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	
	jr $ra
	
ShipPixelLoopEnd:
	addi $t0, $t0, 4			#Next ship pixel
	j ShipPixelLoop

AsteroidPixelLoopEnd:
	addi $t1, $t1, 4			#Next asteroid pixel
	j AsteroidPixelLoop
	
CheckOverlapExit:
	lw $ra, 0($sp)				#No collision at this point
	addi $sp, $sp, 4
	
	addi $sp, $sp, -4
	sw $zero, 0($sp)
	
	jr $ra

############################## Health FUNCTION ############################## 
#This function displays the health of the ship it takes in the health 

Health:
	lw $s0, 0($sp)		#Health
	addi $sp, $sp, 4
	
	la $a0, healthBar

	li $a1, 0xFFFFFF	#White
	li $a2, 0xE5383B	#Red
	li $a3, 0x32A852	#Green
	
	#Note each "group" of units represents one row in the Bitmap Display, groups are separated by spaces
	
	sw $a1, 0($a0)		#The letter H
	sw $a1, 4($a0)
	
	sw $a1, 512($a0)
	sw $a1, 516($a0)
	
	sw $a1, 1024($a0)
	sw $a1, 1028($a0)
	
	sw $a1, 1536($a0)
	sw $a1, 1540($a0)
	
	sw $a1, 2048($a0)
	sw $a1, 2052($a0)
	
	sw $a1, 2560($a0)
	sw $a1, 2564($a0)
	
	sw $a1, 1032($a0)
	sw $a1, 1036($a0)
	
	sw $a1, 1544($a0)
	sw $a1, 1548($a0)
	
	sw $a1, 16($a0)
	sw $a1, 20($a0)
	
	sw $a1, 528($a0)
	sw $a1, 532($a0)
	
	sw $a1, 1040($a0)
	sw $a1, 1044($a0)
	
	sw $a1, 1552($a0)
	sw $a1, 1556($a0)
	
	sw $a1, 2064($a0)
	sw $a1, 2068($a0)
	
	sw $a1, 2576($a0)
	sw $a1, 2580($a0)
	
	sw $a1, 28($a0)		#The letter P
	sw $a1, 32($a0)
	
	sw $a1, 540($a0)
	sw $a1, 544($a0)
	
	sw $a1, 1052($a0)
	sw $a1, 1056($a0)
	
	sw $a1, 1564($a0)
	sw $a1, 1568($a0)
	
	sw $a1, 2076($a0)
	sw $a1, 2080($a0)
	
	sw $a1, 2588($a0)
	sw $a1, 2592($a0)
	
	sw $a1, 36($a0)		
	sw $a1, 40($a0)
	sw $a1, 44($a0)	
		
	sw $a1, 556($a0)		
	sw $a1, 560($a0)
	
	sw $a1, 1068($a0)		
	sw $a1, 1072($a0)
	
	sw $a1, 1572($a0)		
	sw $a1, 1576($a0)
	sw $a1, 1580($a0)		
	
	sw $a1, 568($a0)	#Health Bar
	sw $a1, 572($a0)
	sw $a1, 576($a0)
	sw $a1, 580($a0)
	sw $a1, 584($a0)
	sw $a1, 588($a0)
	sw $a1, 592($a0)
	sw $a1, 596($a0)
	sw $a1, 600($a0)
	sw $a1, 604($a0)
	sw $a1, 608($a0)
	sw $a1, 612($a0)
	
	sw $a1, 1080($a0)
	sw $a1, 1124($a0)
	
	sw $a1, 1592($a0)
	sw $a1, 1636($a0)
	
	sw $a1, 2104($a0)
	sw $a1, 2108($a0)
	sw $a1, 2112($a0)
	sw $a1, 2116($a0)
	sw $a1, 2120($a0)
	sw $a1, 2124($a0)
	sw $a1, 2128($a0)
	sw $a1, 2132($a0)
	sw $a1, 2136($a0)
	sw $a1, 2140($a0)
	sw $a1, 2144($a0)
	sw $a1, 2148($a0)
	
	la $a0, healthBar
	addi $a0, $a0, healthBarContents	#Starting positon of health bark
	
	addi $s1, $zero, 0
	
HealthLoop:	
	beq $s1, healthBarSize, HealthExit	#The size of the health bar
	
	bge $s1, $s0, LivesLost			#If we pass the health then we know we are drawing life lost
	
	sw $a3, 0($a0)				#Draw in green
	sw $a3, 4($a0)
	sw $a3, 512($a0)
	sw $a3, 516($a0)
	
	j HealthLoopIncrement
	
LivesLost:
	sw $a2, 0($a0)				#Draw in red
	sw $a2, 4($a0)
	sw $a2, 512($a0)
	sw $a2, 516($a0)
	
HealthLoopIncrement:
	addi $s1, $s1, 1			#Next positon
	addi $a0, $a0, 8
	j HealthLoop
	
HealthExit:
	jr $ra
	
############################## Score FUNCTION ############################## 
#This function displays the score of the game it takes in a score
	
Score:
	lw $a2, 0($sp)		#Score
	addi $sp, $sp, 4
	
	addi $s2, $a2, 0
	
	lw $a0, 0($sp)		#Position
	addi $sp, $sp, 4
	
	addi $s0, $a0, 0
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $a1, 0xFFFFFF	#White
	
	sw $a1, 0($a0)		#The S
	sw $a1, 512($a0)
	sw $a1, 1024($a0)
	
	sw $a1, 4($a0)
	
	sw $a1, 8($a0)
	sw $a1, 1028($a0)
	sw $a1, 1032($a0)
	
	sw $a1, 1544($a0)
	
	sw $a1, 2056($a0)
	
	sw $a1, 2560($a0)
	sw $a1, 2564($a0)
	sw $a1, 2568($a0)
	
	sw $a1, 16($a0)		#The C
	sw $a1, 528($a0)
	sw $a1, 1040($a0)
	
	sw $a1, 20($a0)
	
	sw $a1, 24($a0)
	
	sw $a1, 1552($a0)
	
	sw $a1, 2064($a0)
	
	sw $a1, 2576($a0)
	sw $a1, 2580($a0)
	sw $a1, 2584($a0)
	
	sw $a1, 32($a0)		#The O
	sw $a1, 544($a0)
	sw $a1, 1056($a0)
	
	sw $a1, 36($a0)
	
	sw $a1, 40($a0)
	sw $a1, 552($a0)
	sw $a1, 1064($a0)
	
	sw $a1, 1568($a0)
	sw $a1, 1576($a0)
	
	sw $a1, 2080($a0)
	sw $a1, 2088($a0)
	
	sw $a1, 2592($a0)
	sw $a1, 2596($a0)
	sw $a1, 2600($a0)
	
	sw $a1, 48($a0)		#The R
	sw $a1, 560($a0)
	sw $a1, 1072($a0)
	sw $a1, 1584($a0)
	sw $a1, 2096($a0)
	sw $a1, 2608($a0)
	
	sw $a1, 52($a0)
	
	sw $a1, 56($a0)
	sw $a1, 572($a0)
	sw $a1, 1080($a0)
	
	sw $a1, 1076($a0)
	
	sw $a1, 1596($a0)
	
	sw $a1, 2108($a0)
	
	sw $a1, 2620($a0)
	
	sw $a1, 68($a0)		#The E
	sw $a1, 72($a0)
	sw $a1, 76($a0)
	
	sw $a1, 580($a0)
	
	sw $a1, 1092($a0)
	sw $a1, 1096($a0)
	
	sw $a1, 1604($a0)
	
	sw $a1, 2116($a0)
	
	sw $a1, 2628($a0)
	sw $a1, 2632($a0)
	sw $a1, 2636($a0)
	
	sw $a1, 596($a0)
	
	sw $a1, 2132($a0)
	
	addi $a3, $zero, 0
	
DigitOneLoop:
	blt $a2, tenThousand, DrawDigitOne		#This is the ten thousand digit, calculate the number
	addi $a2, $a2, negativeTenThousand			
	addi $a3, $a3, 1
	j DigitOneLoop

DrawDigitOne:
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	
	addi $s1, $s0, digitOne
	
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	
	jal DrawDigit				#Draw the digit
	addi $a3, $zero, 0
	
DigitTwoLoop:
	blt $a2, thousand, DrawDigitTwo		#This is the thousands digit
	addi $a2, $a2, negativeThousand
	addi $a3, $a3, 1
	j DigitTwoLoop

DrawDigitTwo:	
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	
	addi $s1, $s0, digitTwo
	
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	
	jal DrawDigit				#Draw the digit

	addi $a3, $zero, 0
	
DigitThreeLoop:
	blt $a2, hundred, DrawDigitThree		#This is the hundreds digit
	addi $a2, $a2, negativeHundred
	addi $a3, $a3, 1
	j DigitThreeLoop

DrawDigitThree:
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	
	addi $s1, $s0, digitThree
	
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	
	jal DrawDigit				 #Draw the digit
	
	addi $a3, $zero, 0
	
DigitFourLoop:
	blt $a2, ten, DrawDigitFour		#This is the tens digit
	addi $a2, $a2, negativeTen
	addi $a3, $a3, 1
	j DigitFourLoop

DrawDigitFour:		
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	
	addi $s1, $s0, digitFour
	
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	
	jal DrawDigit				#Draw the digit

DrawDigitFive:
	addi $sp, $sp, -4			#This is the ones digit
	sw $a2, 0($sp)
	
	addi $s1, $s0, digitFive		
	
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	
	jal DrawDigit				#Draw the digit
	
	lw $ra, 0($sp)		
	addi $sp, $sp, 4
	jr $ra
	
############################## DrawDigit FUNCTION ############################## 
#This function draws a digit in the specified position

DrawDigit:
	lw $a0, 0($sp)		#Pos
	addi $sp, $sp, 4
	lw $a1, 0($sp)		#Number
	addi $sp, $sp, 4
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal ClearDigit
	
	lw $a0, 0($sp)		#Pos
	addi $sp, $sp, 4
	lw $a1, 0($sp)		#Number
	addi $sp, $sp, 4

#Check what number it is and go to the corresponding function
CheckIfNine:
	bne $a1, 9, CheckIfEight
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal Nine
	
	j DigitEnd
	
CheckIfEight:
	bne $a1, 8, CheckIfSeven
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal Eight
	
	j DigitEnd

CheckIfSeven:
	bne $a1, 7, CheckIfSix
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal Seven
	
	j DigitEnd

CheckIfSix:
	bne $a1, 6, CheckIfFive
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal Six
	
	j DigitEnd

CheckIfFive:
	bne $a1, 5, CheckIfFour
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal Five
	
	j DigitEnd
	
CheckIfFour:
	bne $a1, 4, CheckIfThree
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal Four
	
	j DigitEnd

CheckIfThree:
	bne $a1, 3, CheckIfTwo
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal Three
	
	j DigitEnd
	
CheckIfTwo:
	bne $a1, 2, CheckIfOne
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal Two
	
	j DigitEnd
	
CheckIfOne:
	bne $a1, 1, CheckIfZero
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal One
	
	j DigitEnd

CheckIfZero:
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal Zero

DigitEnd:	
	lw $ra, 0($sp)		
	addi $sp, $sp, 4
	jr $ra
	
############################## One FUNCTION ############################## 
#This function draws a one it takes in a position

One:
	lw $a0, 0($sp)		
	addi $sp, $sp, 4

	li $a1, 0xFFFFFF	#White
	
	sw $a1, 0($a0)
	sw $a1, 512($a0)
	sw $a1, 1024($a0)
	sw $a1, 1536($a0)
	sw $a1, 2048($a0)
	sw $a1, 2560($a0)
	
	jr $ra
	
############################## Two FUNCTION ############################## 
#This function draws a two it takes in a position
	
Two:
	lw $a0, 0($sp)		
	addi $sp, $sp, 4

	li $a1, 0xFFFFFF	#White
	
	sw $a1, 0($a0)
	sw $a1, 4($a0)
	sw $a1, 8($a0)
	
	sw $a1, 520($a0)
	
	sw $a1, 1032($a0)
	sw $a1, 1028($a0)
	sw $a1, 1024($a0)
	
	sw $a1, 1536($a0)
	
	sw $a1, 2048($a0)
	
	sw $a1, 2560($a0)
	sw $a1, 2564($a0)
	sw $a1, 2568($a0)
	
	jr $ra
	
############################## Three FUNCTION ############################## 
#This function draws a three it takes in a position

Three:
	lw $a0, 0($sp)		
	addi $sp, $sp, 4

	li $a1, 0xFFFFFF	#White
	
	sw $a1, 0($a0)
	sw $a1, 4($a0)
	sw $a1, 8($a0)
	
	sw $a1, 520($a0)
	
	sw $a1, 1032($a0)
	sw $a1, 1028($a0)
	sw $a1, 1024($a0)
	
	sw $a1, 1544($a0)
	
	sw $a1, 2056($a0)
	
	sw $a1, 2560($a0)
	sw $a1, 2564($a0)
	sw $a1, 2568($a0)
	
	jr $ra
	
############################## Four FUNCTION ############################## 
#This function draws a four it takes in a position
	
Four:
	lw $a0, 0($sp)		
	addi $sp, $sp, 4

	li $a1, 0xFFFFFF	#White
	
	sw $a1, 0($a0)
	sw $a1, 512($a0)
	sw $a1, 1024($a0)
	
	sw $a1, 8($a0)
	sw $a1, 520($a0)
	sw $a1, 1032($a0)
	
	sw $a1, 1028($a0)
	
	sw $a1, 1544($a0)
	
	sw $a1, 2056($a0)
	
	sw $a1, 2568($a0)
	
	jr $ra
	
############################## Five FUNCTION ############################## 
#This function draws a five it takes in a position
	
Five:
	lw $a0, 0($sp)		
	addi $sp, $sp, 4

	li $a1, 0xFFFFFF	#White
	
	sw $a1, 0($a0)
	sw $a1, 4($a0)
	sw $a1, 8($a0)
	
	sw $a1, 512($a0)
	
	sw $a1, 1032($a0)
	sw $a1, 1028($a0)
	sw $a1, 1024($a0)
	
	sw $a1, 1544($a0)
	
	sw $a1, 2056($a0)
	
	sw $a1, 2560($a0)
	sw $a1, 2564($a0)
	sw $a1, 2568($a0)
	
	jr $ra
	
############################## Six FUNCTION ############################## 
#This function draws a six it takes in a position
	
Six:
	lw $a0, 0($sp)		
	addi $sp, $sp, 4

	li $a1, 0xFFFFFF	#White
	
	sw $a1, 0($a0)
	sw $a1, 512($a0)
	sw $a1, 1024($a0)
	
	sw $a1, 4($a0)
	sw $a1, 8($a0)
	
	sw $a1, 1028($a0)
	sw $a1, 1032($a0)
	
	sw $a1, 1536($a0)
	sw $a1, 1544($a0)
	
	sw $a1, 2048($a0)
	sw $a1, 2056($a0)
	
	sw $a1, 2560($a0)
	sw $a1, 2564($a0)
	sw $a1, 2568($a0)
	
	jr $ra
	
############################## Seven FUNCTION ############################## 
#This function draws a seven it takes in a position
	
Seven:
	lw $a0, 0($sp)		
	addi $sp, $sp, 4

	li $a1, 0xFFFFFF	#White
	
	sw $a1, 0($a0)
	sw $a1, 4($a0)
	sw $a1, 8($a0)
	
	sw $a1, 520($a0)
	
	sw $a1, 1032($a0)
	sw $a1, 1028($a0)
	
	sw $a1, 1540($a0)
	sw $a1, 2052($a0)
	sw $a1, 2564($a0)
	
	jr $ra
	
############################## Eight FUNCTION ############################## 
#This function draws a eight it takes in a position
	
Eight:
	lw $a0, 0($sp)		
	addi $sp, $sp, 4

	li $a1, 0xFFFFFF	#White
	
	sw $a1, 0($a0)
	sw $a1, 512($a0)
	sw $a1, 1024($a0)
	
	sw $a1, 4($a0)
	
	sw $a1, 8($a0)
	sw $a1, 520($a0)
	sw $a1, 1032($a0)
	
	sw $a1, 1028($a0)
	
	sw $a1, 1536($a0)
	sw $a1, 1544($a0)
	
	sw $a1, 2048($a0)
	sw $a1, 2056($a0)
	
	sw $a1, 2560($a0)
	sw $a1, 2564($a0)
	sw $a1, 2568($a0)
	
	jr $ra
	
############################## Nine FUNCTION ############################## 
#This function draws a nine it takes in a position
	
Nine:
	lw $a0, 0($sp)		
	addi $sp, $sp, 4

	li $a1, 0xFFFFFF	#White
	
	sw $a1, 0($a0)
	sw $a1, 512($a0)
	sw $a1, 1024($a0)
	
	sw $a1, 8($a0)
	sw $a1, 520($a0)
	sw $a1, 1032($a0)
	
	sw $a1, 4($a0)
	
	sw $a1, 1028($a0)
	
	sw $a1, 1544($a0)
	
	sw $a1, 2056($a0)
	
	sw $a1, 2560($a0)
	sw $a1, 2564($a0)
	sw $a1, 2568($a0)
	
	jr $ra
	
############################## Zero FUNCTION ############################## 
#This function draws a zero it takes in a position

Zero:
	lw $a0, 0($sp)		
	addi $sp, $sp, 4

	li $a1, 0xFFFFFF	#White
	
	sw $a1, 0($a0)
	sw $a1, 512($a0)
	sw $a1, 1024($a0)
	
	sw $a1, 4($a0)
	
	sw $a1, 8($a0)
	sw $a1, 520($a0)
	sw $a1, 1032($a0)
	
	sw $a1, 1536($a0)
	sw $a1, 1544($a0)
	
	sw $a1, 2048($a0)
	sw $a1, 2056($a0)
	
	sw $a1, 2560($a0)
	sw $a1, 2564($a0)
	sw $a1, 2568($a0)
	
	jr $ra
	
############################## ClearDigit FUNCTION ############################## 
#This function clears a digit it takes in a position
	
ClearDigit:
	lw $a0, 0($sp)		
	addi $sp, $sp, 4
	
	li $a1, 0x3C4D69	#Dark blue for the banner
	
	sw $a1, 0($a0)
	sw $a1, 4($a0)
	sw $a1, 8($a0)
	
	sw $a1, 512($a0)
	sw $a1, 516($a0)
	sw $a1, 520($a0)
	
	sw $a1, 1024($a0)
	sw $a1, 1028($a0)
	sw $a1, 1032($a0)
		
	sw $a1, 1536($a0)
	sw $a1, 1540($a0)
	sw $a1, 1544($a0)
	
	sw $a1, 2048($a0)
	sw $a1, 2052($a0)
	sw $a1, 2056($a0)
	
	sw $a1, 2560($a0)
	sw $a1, 2564($a0)
	sw $a1, 2568($a0)
	
	jr $ra
	
############################## DrawLife FUNCTION ############################## 
#This function draws a life, it takes in a positon

DrawLife:
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	li $a1, 0xE0E0E0	#The grey colour
	li $a2, 0xBD0909	#The red colour
	
	sw $a1, 8($a0)
	sw $a1, 12($a0)
	
	sw $a1, 20($a0)
	sw $a1, 24($a0)
	
	sw $a1, 516($a0)
	sw $a2, 520($a0)
	sw $a2, 524($a0)
	
	sw $a1, 528($a0)
	sw $a2, 532($a0)
	sw $a2, 536($a0)
	
	sw $a1, 540($a0)
	
	sw $a1, 1024($a0)
	sw $a2, 1028($a0)
	sw $a2, 1032($a0)
	sw $a2, 1036($a0)
	sw $a2, 1040($a0)
	sw $a2, 1044($a0)
	sw $a2, 1048($a0)
	sw $a2, 1052($a0)
	sw $a1, 1056($a0)
	
	sw $a1, 1540($a0)
	sw $a2, 1544($a0)
	sw $a2, 1548($a0)
	sw $a2, 1552($a0)
	sw $a2, 1556($a0)
	sw $a2, 1560($a0)
	sw $a1, 1564($a0)
	
	sw $a1, 2056($a0)
	sw $a2, 2060($a0)
	sw $a2, 2064($a0)
	sw $a2, 2068($a0)
	sw $a1, 2072($a0)
	
	sw $a1, 2572($a0)
	sw $a2, 2576($a0)
	sw $a1, 2580($a0)
	
	sw $a1, 3088($a0)
	
	jr $ra
	
############################## ClearLife FUNCTION ############################## 
#This function clears a life, it takes in a positon

ClearLife:
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	li $a1, 0x000000	#Black colour
	
	sw $a1, 8($a0)
	sw $a1, 12($a0)
	
	sw $a1, 20($a0)
	sw $a1, 24($a0)
	
	sw $a1, 516($a0)
	sw $a1, 520($a0)
	sw $a1, 524($a0)
	
	sw $a1, 528($a0)
	sw $a1, 532($a0)
	sw $a1, 536($a0)
	
	sw $a1, 540($a0)
	
	sw $a1, 1024($a0)
	sw $a1, 1028($a0)
	sw $a1, 1032($a0)
	sw $a1, 1036($a0)
	sw $a1, 1040($a0)
	sw $a1, 1044($a0)
	sw $a1, 1048($a0)
	sw $a1, 1052($a0)
	sw $a1, 1056($a0)
	
	sw $a1, 1540($a0)
	sw $a1, 1544($a0)
	sw $a1, 1548($a0)
	sw $a1, 1552($a0)
	sw $a1, 1556($a0)
	sw $a1, 1560($a0)
	sw $a1, 1564($a0)
	
	sw $a1, 2056($a0)
	sw $a1, 2060($a0)
	sw $a1, 2064($a0)
	sw $a1, 2068($a0)
	sw $a1, 2072($a0)
	
	sw $a1, 2572($a0)
	sw $a1, 2576($a0)
	sw $a1, 2580($a0)
	
	sw $a1, 3088($a0)
	
	jr $ra
	
############################## DrawLife FUNCTION ############################## 
#This function draws a life collision, it takes in a positon

DrawLifeCollision:
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	li $a1, 0xE0E0E0	#Grey colour
	li $a2, 0xBD0909	#Red colour
	li $a3, 0x000000	#Black colour
	
	sw $a3, 8($a0)
	sw $a3, 12($a0)
	
	sw $a3, 20($a0)
	sw $a3, 24($a0)
	
	sw $a3, 516($a0)
	sw $a3, 520($a0)
	sw $a3, 524($a0)
	
	sw $a1, 528($a0)
	sw $a3, 532($a0)
	sw $a3, 536($a0)
	
	sw $a3, 540($a0)
	
	sw $a3, 1024($a0)
	sw $a3, 1028($a0)
	sw $a3, 1032($a0)
	sw $a1, 1036($a0)
	sw $a2, 1040($a0)
	sw $a1, 1044($a0)
	sw $a3, 1048($a0)
	sw $a3, 1052($a0)
	sw $a3, 1056($a0)
	
	sw $a3, 1540($a0)
	sw $a1, 1544($a0)
	sw $a2, 1548($a0)
	sw $a2, 1552($a0)
	sw $a2, 1556($a0)
	sw $a1, 1560($a0)
	sw $a3, 1564($a0)
	
	sw $a3, 2056($a0)
	sw $a1, 2060($a0)
	sw $a2, 2064($a0)
	sw $a1, 2068($a0)
	sw $a3, 2072($a0)
	
	sw $a3, 2572($a0)
	sw $a1, 2576($a0)
	sw $a3, 2580($a0)
	
	sw $a3, 3088($a0)
	
	jr $ra	
	
############################## MoveLife FUNCTION ############################## 
#This function moves the life icon
	
MoveLife:
	la $a0, life			#Load the life pointer
	addi $a1, $zero, defaultX	#Load the default value
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $a3, 0($a0)
	beq $a3, $a1, MoveLifeExit	#If default value then do not move
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	
	jal ClearLife			#Clear the life
	
	lw $a3, 0($sp)
	addi $sp, $sp, 4
	lw $a2, 0($sp)
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	addi $a3, $a3, lifeMove		#Move the life
	sw $a3, 0($a0)
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	
	jal DrawLife			#Draw the asteroid
	
	lw $a3, 0($sp)
	addi $sp, $sp, 4
	lw $a2, 0($sp)
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	
	jal CheckIfLeftEdge		#Checks if the life is at the left side of the screen 
	
	lw $a3, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	lw $a2, 0($sp)
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	bne $s0, $zero, MoveLifeExit

RemoveLife:				#If the life reached the end of the screen it is removed
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	
	jal ClearLife			#Clear the life
	
	lw $a3, 0($sp)
	addi $sp, $sp, 4
	lw $a2, 0($sp)
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	la $a0, life
	addi $a1, $zero, defaultX	#Put the default value in
	sw $a1, 0($a0)
	
MoveLifeExit:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
############################## SpawnLife FUNCTION ############################## 
#This function spawns a life

SpawnLife:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
			
	li $v0, 42
	li $a0, 0
	li $a1, lifeSpawnLocation
	syscall
	
	addi $a2, $zero, 512
	addi $a0, $a0, minSpawnLocationInterval
	mult $a2, $a0
	mflo $a2
	addi $a2, $a2, lifeRight	#Calculate the position to spawn
	
	la $a1, life
	sw $a2, 0($a1)
	
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	
	jal DrawLife			#Draw life
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra	
	
############################## LifeCollisionCheck FUNCTION ############################## 
#This function checks if there is a possible collision between the ship and a life takes in ship position and health

LifeCollisionCheck:
	lw $a0, 0($sp)		#shippos
	addi $sp, $sp, 4
	lw $a1, 0($sp)		#health
	addi $sp, $sp, 4
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $a2, life		#Load life pointer
	
	lw $a3, 0($a2)
	beq $a3, defaultX, LifeCollisionCheckExit
	
	#Note that we want to make collision detection as tight as possible to stop unneccessary checking so I made a shape around
	#the ship, this shape is like a boundry and if anything crosses that boundry then that is checked
	#In every check we have a top value that value is relative to the ship we are defining a boundry 
	#The bottom value is defining the position relative to the object we are checking 
	#We use this idea for all of the collision detection
	
	addi $s0, $a3, bottomBoundryLife
	blt $s0, $a0, LifeCollisionCheckExit
	
	LifeTopCheckOne:	
	addi $s0, $a0, frontOne
	bgt $a3, $s0, LifeTopCheckOnePTwo
	
	j LifeTopCheckTwo
	
LifeTopCheckOnePTwo:
	addi $s0, $a0, bottomOne
	addi $s4, $a3, topRightLife
	blt $s4, $s0, LifeCollisionCheckExit

LifeTopCheckTwo:
	addi $s0, $a0, frontTwo
	bgt $a3, $s0, LifeTopCheckTwoPTwo
	
	j LifeTopCheckThree
	
LifeTopCheckTwoPTwo:
	addi $s0, $a0, bottomTwo
	addi $s4, $a3, topRightLife
	blt $s4, $s0, LifeCollisionCheckExit 
	
LifeTopCheckThree:
	addi $s0, $a0, frontThree
	bgt $a3, $s0, LifeTopCheckThreePTwo
	
	j LifeTopCheckFour
	
LifeTopCheckThreePTwo:
	addi $s0, $a0, bottomThree
	addi $s4, $a3, topRightLife
	blt $s4, $s0, LifeCollisionCheckExit
	
LifeTopCheckFour:
	addi $s0, $a0, frontFour
	bgt $a3, $s0, LifeTopCheckFourPTwo
	
	j LifeTopCheckFive
	
LifeTopCheckFourPTwo:
	addi $s0, $a0, bottomFour
	addi $s4, $a3, topRightLife
	blt $s4, $s0, LifeCollisionCheckExit
	
LifeTopCheckFive:
	addi $s0, $a0, frontFive
	bgt $a3, $s0, LifeTopCheckFivePTwo
	
	j LifeTopCheckSix
	
LifeTopCheckFivePTwo:
	addi $s0, $a0, bottomFive
	addi $s4, $a3, topRightLife
	blt $s4, $s0, LifeCollisionCheckExit
	
LifeTopCheckSix:
	addi $s0, $a0, frontSix
	bgt $a3, $s0, LifeTopCheckSixPTwo
	
	j LifeTopCheckSeven
	
LifeTopCheckSixPTwo:
	addi $s0, $a0, bottomSix
	addi $s4, $a3, topRightLife
	blt $s4, $s0, LifeCollisionCheckExit
	
LifeTopCheckSeven:
	addi $s0, $a0, frontSeven
	bgt $a3, $s0, LifeTopCheckSevenPTwo
	
	j LifeTopCheckEight
	
LifeTopCheckSevenPTwo:
	addi $s0, $a0, bottomSeven
	addi $s4, $a3, topRightLife
	blt $s4, $s0, LifeCollisionCheckExit
	
LifeTopCheckEight:
	addi $s0, $a0, frontEight
	bgt $a3, $s0, LifeTopCheckEightPTwo
	
	j LifeTopCheckNine
	
LifeTopCheckEightPTwo:
	addi $s0, $a0, bottomEight
	addi $s4, $a3, topRightLife
	blt $s4, $s0, LifeCollisionCheckExit
	
LifeTopCheckNine:
	addi $s0, $a0, frontNine
	bgt $a3, $s0, LifeTopCheckNinePTwo
	
	j LifeTopCheckTen
	
LifeTopCheckNinePTwo:
	addi $s0, $a0, bottomNine
	addi $s4, $a3, topRightLife
	blt $s4, $s0, LifeCollisionCheckExit
	
LifeTopCheckTen:
	addi $s0, $a0, frontTen
	bgt $a3, $s0, LifeTopCheckTenPTwo
	
	j LifeTopCheckEleven
	
LifeTopCheckTenPTwo:
	addi $s0, $a0, bottomTen
	addi $s4, $a3, topRightLife
	blt $s4, $s0, LifeCollisionCheckExit
	
LifeTopCheckEleven:
	addi $s0, $a0, frontEleven
	bgt $a3, $s0, LifeTopCheckElevenPTwo
	
	j LifeBottomCheckOne
	
LifeTopCheckElevenPTwo:
	addi $s0, $a0, bottomEleven
	addi $s4, $a3, topRightLife
	blt $s4, $s0, LifeCollisionCheckExit
	
LifeBottomCheckOne:	
	addi $s0, $a0, frontOne
	addi $s4, $a3, bottomLeftLife
	bgt $s4, $s0, LifeBottomCheckOnePTwo
	
	j LifeBottomCheckTwo
	
LifeBottomCheckOnePTwo:
	addi $s0, $a0, bottomOne
	addi $s4, $a3, bottomRightLife
	blt $s4, $s0, LifeCollisionCheckExit

LifeBottomCheckTwo:
	addi $s0, $a0, frontTwo
	addi $s4, $a3, bottomLeftLife
	bgt $s4, $s0, LifeBottomCheckTwoPTwo
	
	j LifeBottomCheckThree
	
LifeBottomCheckTwoPTwo:
	addi $s0, $a0, bottomTwo
	addi $s4, $a3, bottomRightLife
	blt $s4, $s0, LifeCollisionCheckExit
	
LifeBottomCheckThree:
	addi $s0, $a0, frontThree
	addi $s4, $a3, bottomLeftLife
	bgt $s4, $s0, LifeBottomCheckThreePTwo
	
	j LifeBottomCheckFour
	
LifeBottomCheckThreePTwo:
	addi $s0, $a0, bottomThree
	addi $s4, $a3, bottomRightLife
	blt $s4, $s0, LifeCollisionCheckExit
	
LifeBottomCheckFour:
	addi $s0, $a0, frontFour
	addi $s4, $a3, bottomLeftLife
	bgt $s4, $s0, LifeBottomCheckFourPTwo
	
	j LifeBottomCheckFive
	
LifeBottomCheckFourPTwo:
	addi $s0, $a0, bottomFour	
	addi $s4, $a3, bottomRightLife
	blt $s4, $s0, LifeCollisionCheckExit
	
LifeBottomCheckFive:
	addi $s0, $a0, frontFive	
	addi $s4, $a3, bottomLeftLife
	bgt $s4, $s0, LifeBottomCheckFivePTwo
	
	j LifeBottomCheckSix
	
LifeBottomCheckFivePTwo:
	addi $s0, $a0, bottomFive	
	addi $s4, $a3, bottomRightLife
	blt $s4, $s0, LifeCollisionCheckExit
	
LifeBottomCheckSix:
	addi $s0, $a0, frontSix	
	addi $s4, $a3, bottomLeftLife
	bgt $s4, $s0, LifeBottomCheckSixPTwo
	
	j LifeBottomCheckSeven
	
LifeBottomCheckSixPTwo:
	addi $s0, $a0, bottomSix
	addi $s4, $a3, bottomRightLife
	blt $s4, $s0, LifeCollisionCheckExit
	
LifeBottomCheckSeven:
	addi $s0, $a0, frontSeven
	addi $s4, $a3, bottomLeftLife
	bgt $s4, $s0, LifeBottomCheckSevenPTwo
	
	j LifeBottomCheckEight
	
LifeBottomCheckSevenPTwo:
	addi $s0, $a0, bottomSeven
	addi $s4, $a3, bottomRightLife
	blt $s4, $s0, LifeCollisionCheckExit
	
LifeBottomCheckEight:
	addi $s0, $a0, frontEight
	addi $s4, $a3, bottomLeftLife
	bgt $s4, $s0, LifeBottomCheckEightPTwo
	
	j LifeBottomCheckNine
	
LifeBottomCheckEightPTwo:
	addi $s0, $a0, bottomEight
	addi $s4, $a3, bottomRightLife
	blt $s4, $s0, LifeCollisionCheckExit
	
LifeBottomCheckNine:
	addi $s0, $a0, frontNine
	addi $s4, $a3, bottomLeftLife
	bgt $s4, $s0, LifeBottomCheckNinePTwo
	
	j LifeBottomCheckTen
	
LifeBottomCheckNinePTwo:
	addi $s0, $a0, bottomNine
	addi $s4, $a3, bottomRightLife
	blt $s4, $s0, LifeCollisionCheckExit
	
LifeBottomCheckTen:
	addi $s0, $a0, frontTen
	addi $s4, $a3, bottomLeftLife
	bgt $s4, $s0, LifeBottomCheckTenPTwo
	
	j LifeBottomCheckEleven
	
LifeBottomCheckTenPTwo:
	addi $s0, $a0, bottomTen
	addi $s4, $a3, bottomRightLife
	blt $s4, $s0, LifeCollisionCheckExit
	
LifeBottomCheckEleven:
	addi $s0, $a0, frontEleven
	addi $s4, $a3, bottomLeftLife
	bgt $s4, $s0, LifeBottomCheckElevenPTwo
	
	j LifeCheckTwelve
	
LifeBottomCheckElevenPTwo:
	addi $s0, $a0, bottomEleven
	addi $s4, $a3, bottomRightLife
	blt $s4, $s0, LifeCollisionCheckExit

LifeCheckTwelve:
	addi $s0, $a0, shipBottomRight
	bgt $a3, $s0, LifeCollisionCheckExit
	
	addi $sp, $sp, -4	#At this point it is in the boundry
	sw $a3, 0($sp)
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal CheckLifeOverlap	#Check if overlaps 
	
	lw $s0, 0($sp)		#Either 0, -1 for collision check if -1 break 
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a2, 0($sp)
	addi $sp, $sp, 4
	lw $a3, 0($sp)
	addi $sp, $sp, 4
	
	bne $s0, -1, LifeCollisionCheckExit
	addi $a1, $a1, 1
	ble $a1, 5, LifeCollisionCheckExit
	addi $a1, $zero, 5
	j LifeCollisionCheckExit
	
LifeCollisionCheckExit:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	
	jr $ra

############################## CheckLifeOverlap FUNCTION ############################## 
#This function checks if the life is overlapping with the ship takes in life position and ship position

CheckLifeOverlap:
	lw $a0, 0($sp)		#shippos
	addi $sp, $sp, 4
	lw $a1, 0($sp)		#Life position
	addi $sp, $sp, 4
	
	addi $a2, $zero, 0
	addi $a3, $zero, 0
	
	la $t0, shipOutline	#Load the ship outline
	la $t1, lifeOutline	#Load the life outline
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
#We compare each pixel to check if the are equal, if they are then there is a collision
LifePixelLoop:
	beq $a2, lifeOutlineSize, CheckLifeOverlapExit
	addi $a2, $a2, 1
	lw $s0, 0($t1)
	
	add $s2, $a1, $s0
	addi $a3, $zero, 0
	
LifeShipPixelLoop:
	beq $a3, shipOutlineSize, LifePixelLoop
	addi $a3, $a3, 1
	lw $s1, 0($t0)
	
	add $s3, $a0, $s1
	
	bne $s3, $s2, LifeShipPixelLoopEnd
	
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	
	jal DrawLifeCollision		#Draw the life collision
	
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	lw $a2, 0($sp)
	addi $sp, $sp, 4
	lw $a3, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	li $v0, 32
	li $a0, collisionDelay 		# Wait 50 milliseconds before next line of code
	syscall
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	
	jal ClearLife			#Clear the life
	
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	la $a0, life
	addi $a1, $zero, defaultX
	sw $a1, 0($a0)			#Set life to default value and break
	
	addi $s0, $zero, -1
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	
	jr $ra
	
LifeShipPixelLoopEnd:
	addi $t0, $t0, 4		#Next ship pixel
	j LifeShipPixelLoop
		
CheckLifeOverlapExit:
	lw $ra, 0($sp)			#Next life pixel
	addi $sp, $sp, 4
	
	addi $sp, $sp, -4
	sw $zero, 0($sp)
	
	jr $ra
	
############################## DrawBonusPoints FUNCTION ############################## 
#This function draws the bonus points icon, takes in a position 

DrawBonusPoints:
	lw $a0, 0($sp)		#Position
	addi $sp, $sp, 4
	
	li $a1, 0xD4AF37	#Dark Gold
	li $a2, 0xFFD700	#Light Gold
	
	sw $a1, 8($a0)

	sw $a1, 516($a0)
	sw $a2, 520($a0)
	sw $a1, 524($a0)

	sw $a1, 1024($a0)
	sw $a2, 1028($a0)
	sw $a2, 1032($a0)
	sw $a2, 1036($a0)
	sw $a1, 1040($a0)

	sw $a1, 1540($a0)
	sw $a2, 1544($a0)
	sw $a1, 1548($a0)

	sw $a1, 2056($a0)

	jr $ra	
	
############################## DrawBonusPointsCollision FUNCTION ############################## 
#This function draws the bonus points collision, takes in a position 

DrawBonusPointsCollision:
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	li $a1, 0xD4AF37	#Dark Gold
	li $a2, 0xFFD700	#Light Gold
	li $a3, 0x000000
	
	sw $a3, 8($a0)

	sw $a1, 516($a0)
	sw $a3, 520($a0)
	sw $a1, 524($a0)

	sw $a3, 1024($a0)
	sw $a3, 1028($a0)
	sw $a2, 1032($a0)
	sw $a3, 1036($a0)
	sw $a3, 1040($a0)

	sw $a1, 1540($a0)
	sw $a3, 1544($a0)
	sw $a1, 1548($a0)

	sw $a3, 2056($a0)

	jr $ra
	
############################## ClearBonusPoints FUNCTION ############################## 
#This function clears the bonus points icon, takes in a position 
	
ClearBonusPoints:
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	li $a1, 0x000000	#Black
	
	sw $a1, 8($a0)

	sw $a1, 516($a0)
	sw $a1, 520($a0)
	sw $a1, 524($a0)

	sw $a1, 1024($a0)
	sw $a1, 1028($a0)
	sw $a1, 1032($a0)
	sw $a1, 1036($a0)
	sw $a1, 1040($a0)

	sw $a1, 1540($a0)
	sw $a1, 1544($a0)
	sw $a1, 1548($a0)

	sw $a1, 2056($a0)

	jr $ra	
	
############################## BonusPointsCollisionCheck FUNCTION ############################## 
#This function checks if there is a possible collision between the ship and the bonus points it takes in the ship position and points position

BonusPointsCollisionCheck:
	lw $a0, 0($sp)		#shippos
	addi $sp, $sp, 4
	lw $a1, 0($sp)		#points
	addi $sp, $sp, 4
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $a2, points
	lw $a3, 0($a2)

	beq $a3, defaultX, BonusPointsCollisionCheckLoopEnd
	
	#Note that we want to make collision detection as tight as possible to stop unneccessary checking so I made a shape around
	#the ship, this shape is like a boundry and if anything crosses that boundry then that is checked
	#In every check we have a top value that value is relative to the ship we are defining a boundry 
	#The bottom value is defining the position relative to the object we are checking 
	#We use this idea for all of the collision detection
	
	addi $s0, $a3, bottomBoundryPoints
	blt $s0, $a0, BonusPointsCollisionCheckLoopEnd
	
BonusPointsTopCheckOne:	
	addi $s0, $a0, frontOne
	bgt $a3, $s0, BonusPointsTopCheckOnePTwo
	
	j BonusPointsTopCheckTwo
	
BonusPointsTopCheckOnePTwo:
	addi $s0, $a0, bottomOne
	addi $s4, $a3, topRightPoints        
	blt $s4, $s0, BonusPointsCollisionCheckLoopEnd 

BonusPointsTopCheckTwo:
	addi $s0, $a0, frontTwo
	bgt $a3, $s0, BonusPointsTopCheckTwoPTwo
	
	j BonusPointsTopCheckThree
	
BonusPointsTopCheckTwoPTwo:
	addi $s0, $a0, bottomTwo
	addi $s4, $a3, topRightPoints        
	blt $s4, $s0, BonusPointsCollisionCheckLoopEnd  
	
BonusPointsTopCheckThree:
	addi $s0, $a0, frontThree
	bgt $a3, $s0, BonusPointsTopCheckThreePTwo
	
	j BonusPointsTopCheckFour
	
BonusPointsTopCheckThreePTwo:
	addi $s0, $a0, bottomThree
	addi $s4, $a3, topRightPoints        
	blt $s4, $s0, BonusPointsCollisionCheckLoopEnd
	
BonusPointsTopCheckFour:
	addi $s0, $a0, frontFour
	bgt $a3, $s0, BonusPointsTopCheckFourPTwo
	
	j BonusPointsTopCheckFive
	
BonusPointsTopCheckFourPTwo:
	addi $s0, $a0, bottomFour
	addi $s4, $a3, topRightPoints        
	blt $s4, $s0, BonusPointsCollisionCheckLoopEnd
	
BonusPointsTopCheckFive:
	addi $s0, $a0, frontFive
	bgt $a3, $s0, BonusPointsTopCheckFivePTwo
	
	j BonusPointsTopCheckSix
	
BonusPointsTopCheckFivePTwo:
	addi $s0, $a0, bottomFive
	addi $s4, $a3, topRightPoints        
	blt $s4, $s0, BonusPointsCollisionCheckLoopEnd 
	
BonusPointsTopCheckSix:
	addi $s0, $a0, frontSix
	bgt $a3, $s0, BonusPointsTopCheckSixPTwo
	
	j BonusPointsTopCheckSeven
	
BonusPointsTopCheckSixPTwo:
	addi $s0, $a0, bottomSix
	addi $s4, $a3, topRightPoints        
	blt $s4, $s0, BonusPointsCollisionCheckLoopEnd
	
BonusPointsTopCheckSeven:
	addi $s0, $a0, frontSeven
	bgt $a3, $s0, BonusPointsTopCheckSevenPTwo
	
	j BonusPointsTopCheckEight
	
BonusPointsTopCheckSevenPTwo:
	addi $s0, $a0, bottomSeven
	addi $s4, $a3, topRightPoints        
	blt $s4, $s0, BonusPointsCollisionCheckLoopEnd
	
BonusPointsTopCheckEight:
	addi $s0, $a0, frontEight
	bgt $a3, $s0, BonusPointsTopCheckEightPTwo
	
	j BonusPointsTopCheckNine
	
BonusPointsTopCheckEightPTwo:
	addi $s0, $a0, bottomEight
	addi $s4, $a3, topRightPoints        
	blt $s4, $s0, BonusPointsCollisionCheckLoopEnd
	
BonusPointsTopCheckNine:
	addi $s0, $a0, frontNine
	bgt $a3, $s0, BonusPointsTopCheckNinePTwo
	
	j BonusPointsTopCheckTen
	
BonusPointsTopCheckNinePTwo:
	addi $s0, $a0, bottomNine
	addi $s4, $a3, topRightPoints        
	blt $s4, $s0, BonusPointsCollisionCheckLoopEnd
	
BonusPointsTopCheckTen:
	addi $s0, $a0, frontTen
	bgt $a3, $s0, BonusPointsTopCheckTenPTwo
	
	j BonusPointsTopCheckEleven
	
BonusPointsTopCheckTenPTwo:
	addi $s0, $a0, bottomTen
	addi $s4, $a3, topRightPoints        
	blt $s4, $s0, BonusPointsCollisionCheckLoopEnd 
	
BonusPointsTopCheckEleven:
	addi $s0, $a0, frontEleven
	bgt $a3, $s0, BonusPointsTopCheckElevenPTwo
	
	j BonusPointsBottomCheckOne
	
BonusPointsTopCheckElevenPTwo:
	addi $s0, $a0, bottomEleven
	addi $s4, $a3, topRightPoints        
	blt $s4, $s0, BonusPointsCollisionCheckLoopEnd
	
BonusPointsBottomCheckOne:	
	addi $s0, $a0, frontOne
	addi $s4, $a3, bottomLeftPoints    
	bgt $s4, $s0, BonusPointsBottomCheckOnePTwo
	
	j BonusPointsBottomCheckTwo
	
BonusPointsBottomCheckOnePTwo:
	addi $s0, $a0, bottomOne
	addi $s4, $a3, bottomRightPoints   
	blt $s4, $s0, BonusPointsCollisionCheckLoopEnd 

BonusPointsBottomCheckTwo:
	addi $s0, $a0, frontTwo
	addi $s4, $a3, bottomLeftPoints    
	bgt $s4, $s0, BonusPointsBottomCheckTwoPTwo
	
	j BonusPointsBottomCheckThree
	
BonusPointsBottomCheckTwoPTwo:
	addi $s0, $a0, bottomTwo
	addi $s4, $a3, bottomRightPoints   
	blt $s4, $s0, BonusPointsCollisionCheckLoopEnd 
	
BonusPointsBottomCheckThree:
	addi $s0, $a0, frontThree
	addi $s4, $a3, bottomLeftPoints    
	bgt $s4, $s0, BonusPointsBottomCheckThreePTwo
	
	j BonusPointsBottomCheckFour
	
BonusPointsBottomCheckThreePTwo:
	addi $s0, $a0, bottomThree
	addi $s4, $a3, bottomRightPoints   
	blt $s4, $s0, BonusPointsCollisionCheckLoopEnd
	
BonusPointsBottomCheckFour:
	addi $s0, $a0, frontFour
	addi $s4, $a3, bottomLeftPoints    
	bgt $s4, $s0, BonusPointsBottomCheckFourPTwo
	
	j BonusPointsBottomCheckFive
	
BonusPointsBottomCheckFourPTwo:
	addi $s0, $a0, bottomFour
	addi $s4, $a3, bottomRightPoints   
	blt $s4, $s0, BonusPointsCollisionCheckLoopEnd 
	
BonusPointsBottomCheckFive:
	addi $s0, $a0, frontFive
	addi $s4, $a3, bottomLeftPoints    
	bgt $s4, $s0, BonusPointsBottomCheckFivePTwo
	
	j BonusPointsBottomCheckSix
	
BonusPointsBottomCheckFivePTwo:
	addi $s0, $a0, bottomFive
	addi $s4, $a3, bottomRightPoints   
	blt $s4, $s0, BonusPointsCollisionCheckLoopEnd 
	
BonusPointsBottomCheckSix:
	addi $s0, $a0, frontSix
	addi $s4, $a3, bottomLeftPoints    
	bgt $s4, $s0, BonusPointsBottomCheckSixPTwo
	
	j BonusPointsBottomCheckSeven
	
BonusPointsBottomCheckSixPTwo:
	addi $s0, $a0, bottomSix
	addi $s4, $a3, bottomRightPoints   
	blt $s4, $s0, BonusPointsCollisionCheckLoopEnd 
	
BonusPointsBottomCheckSeven:
	addi $s0, $a0, frontSeven
	addi $s4, $a3, bottomLeftPoints    
	bgt $s4, $s0, BonusPointsBottomCheckSevenPTwo
	
	j BonusPointsBottomCheckEight
	
BonusPointsBottomCheckSevenPTwo:
	addi $s0, $a0, bottomSeven
	addi $s4, $a3, bottomRightPoints   
	blt $s4, $s0, BonusPointsCollisionCheckLoopEnd 
	
BonusPointsBottomCheckEight:
	addi $s0, $a0, frontEight
	addi $s4, $a3, bottomLeftPoints    
	bgt $s4, $s0, BonusPointsBottomCheckEightPTwo
	
	j BonusPointsBottomCheckNine
	
BonusPointsBottomCheckEightPTwo:
	addi $s0, $a0, bottomEight
	addi $s4, $a3, bottomRightPoints   
	blt $s4, $s0, BonusPointsCollisionCheckLoopEnd 
	
BonusPointsBottomCheckNine:
	addi $s0, $a0, frontNine
	addi $s4, $a3, bottomLeftPoints    
	bgt $s4, $s0, BonusPointsBottomCheckNinePTwo
	
	j BonusPointsBottomCheckTen
	
BonusPointsBottomCheckNinePTwo:
	addi $s0, $a0, bottomNine
	addi $s4, $a3, bottomRightPoints   
	blt $s4, $s0, BonusPointsCollisionCheckLoopEnd 
	
BonusPointsBottomCheckTen:
	addi $s0, $a0, frontTen
	addi $s4, $a3, bottomLeftPoints    
	bgt $s4, $s0, BonusPointsBottomCheckTenPTwo
	
	j BonusPointsBottomCheckEleven
	
BonusPointsBottomCheckTenPTwo:
	addi $s0, $a0, bottomTen
	addi $s4, $a3, bottomRightPoints   
	blt $s4, $s0, BonusPointsCollisionCheckLoopEnd 
	
BonusPointsBottomCheckEleven:
	addi $s0, $a0, frontEleven
	addi $s4, $a3, bottomLeftPoints    
	bgt $s4, $s0, BonusPointsBottomCheckElevenPTwo
	
	j BonusPointsCheckTwelve
	
BonusPointsBottomCheckElevenPTwo:
	addi $s0, $a0, bottomEleven
	addi $s4, $a3, bottomRightPoints   
	blt $s4, $s0, BonusPointsCollisionCheckLoopEnd 

BonusPointsCheckTwelve:
	addi $s0, $a0, shipBottomRight   
	bgt $a3, $s0, BonusPointsCollisionCheckLoopEnd
	
	addi $sp, $sp, -4		#At this point there may be a collision
	sw $a3, 0($sp)
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal BonusPointsCheckOverlap	#Check if there is an ovelap
	
	lw $s0, 0($sp)			#Either 0, -1 for collision check if -1 then collision
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a2, 0($sp)
	addi $sp, $sp, 4
	lw $a3, 0($sp)
	addi $sp, $sp, 4
	
	bne $s0, -1, BonusPointsCollisionCheckLoopEnd
	addi $a1, $a1, pointsAdded	#Add points on collision

BonusPointsCollisionCheckLoopEnd:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	
	jr $ra

############################## BonusPointsCheckOverlap FUNCTION ############################## 
#This function checks if the bonus points is overlapping with the ship, it takes in the ship positon and points position 

BonusPointsCheckOverlap:
	lw $a0, 0($sp)		#shippos
	addi $sp, $sp, 4
	lw $a1, 0($sp)		#bonus points position
	addi $sp, $sp, 4
	
	addi $a2, $zero, 0
	addi $a3, $zero, 0
	
	la $t0, shipOutline	#Load the ship outline
	la $t1, pointsOutline	#Load the points outline
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
#We go over each pixel if any are equal then there is a collision
BonusPointsPixelLoop:
	beq $a2, pointsOutlineSize, BonusPointsCheckOverlapExit
	addi $a2, $a2, 1
	lw $s0, 0($t1)
	
	add $s2, $a1, $s0
	addi $a3, $zero, 0
	
BonusPointsShipPixelLoop:
	beq $a3, shipOutlineSize, BonusPointsPixelLoop
	addi $a3, $a3, 1
	lw $s1, 0($t0)
	
	add $s3, $a0, $s1
	
	bne $s3, $s2, BonusPointsShipPixelLoopEnd
	
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	
	jal DrawBonusPointsCollision	#Draw the collision
	
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	lw $a2, 0($sp)
	addi $sp, $sp, 4
	lw $a3, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	li $v0, 32
	li $a0, collisionDelay 		#Wait 50 milliseconds
	syscall
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	
	jal ClearBonusPoints		#Clear the bonus points
	
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	la $a0, points
	addi $a1, $zero, defaultX	#Reset to default and break
	sw $a1, 0($a0)
	
	addi $s0, $zero, -1

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	addi $sp, $sp, -4
	sw $s0, 0($sp) 
	
	jr $ra
	
BonusPointsShipPixelLoopEnd:
	addi $t0, $t0, 4		#Next ship pixel
	j BonusPointsShipPixelLoop
	
BonusPointsCheckOverlapExit:
	lw $ra, 0($sp)	
	addi $sp, $sp, 4
	
	addi $sp, $sp, -4
	sw $zero, 0($sp)
	
	jr $ra
	
############################## SpawnBonusPoints FUNCTION ############################## 
#This function spawns bonus points

SpawnBonusPoints:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
			
	li $v0, 42
	li $a0, 0
	li $a1, spawnLocationRange
	syscall
	
	addi $a2, $zero, 512
	addi $a0, $a0, minSpawnLocationInterval
	mult $a2, $a0
	mflo $a2
	addi $a2, $a2, BonusPointsRight		#Calculate position to spawn
	
	la $a1, points
	sw $a2, 0($a1)
	
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	
	jal DrawBonusPoints			#Draw the points

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra	
	
############################## MoveBonusPoints FUNCTION ############################## 
#This function moves the bonus points
	
MoveBonusPoints:
	la $a0, points				#Load the points array
	addi $a1, $zero, defaultX		#Load the default value
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $a3, 0($a0)
	beq $a3, $a1, MoveBonusPointsExit	#If default value then do not move
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	
	jal ClearBonusPoints		#Clear the points
	
	lw $a3, 0($sp)
	addi $sp, $sp, 4
	lw $a2, 0($sp)
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	addi $a3, $a3, pointsMove	#Move the points
	sw $a3, 0($a0)
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	
	jal DrawBonusPoints		#Draw the points
	
	lw $a3, 0($sp)
	addi $sp, $sp, 4
	lw $a2, 0($sp)
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	
	jal CheckIfLeftEdge		#Checks if the points is at the left side of the screen 
	
	lw $a3, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	lw $a2, 0($sp)
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	bne $s0, $zero, MoveBonusPointsExit

RemoveBonusPoints:				#If the points reached the end of the screen it is removed
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	
	jal ClearBonusPoints	#Clear the points
	
	lw $a3, 0($sp)
	addi $sp, $sp, 4
	lw $a2, 0($sp)
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	la $a0, points		
	addi $a1, $zero, defaultX	#Set back to default
	sw $a1, 0($a0)
	
MoveBonusPointsExit:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

############################## IsLifeMultiple FUNCTION ############################## 
#This function determines if a life should be spawnned, it takes in a score

IsLifeMultiple:
	lw $a0, 0($sp)			#Score
	addi $sp, $sp, 4
	
	beq $a0, 0 LifeMultipleExit	#If zero do not spawn
	addi $a2, $a0, 0
	
LifeMultipleLoop: 			
	blt $a2, 0, LifeMultipleExit
	
	bne $a2, 0, LifeMultipleEnd
	
	addi $a1, $zero, 1
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	
	jr $ra
	
LifeMultipleEnd:
	bgt $a0, lifeEasyScore, LifeHard	#If lower than this value then spawn more often
	addi $a2, $a2, lifeEasy
	j LifeMultipleLoop
	
LifeHard:
	addi $a2, $a2, lifeHard			#Spawn less often
	j LifeMultipleLoop

LifeMultipleExit:
	addi $sp, $sp, -4
	sw $zero, 0($sp)
	
	jr $ra
	
############################## IsBonusPointsMultiple FUNCTION ############################## 
#This function determines if bonus points should be spawned, it takes in a score
	
IsBonusPointsMultiple:
	lw $a0, 0($sp)			#Score
	addi $sp, $sp, 4
	
	beq $a0, 0 BonusPointsMultipleExit
	
	addi $a2, $a0, 0
	
BonusPointsMultipleLoop: 
	blt $a2, 0, BonusPointsMultipleExit
	
	bne $a2, 0, BonusPointsMultipleEnd
	
	addi $a1, $zero, 1
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	
	jr $ra
	
BonusPointsMultipleEnd:
	bgt $a0, pointsEasyScore, BonusPointsHard	#If under this value the points spawn more often
	addi $a2, $a2, pointsEasy
	j BonusPointsMultipleLoop
	
BonusPointsHard:
	addi $a2, $a2, pointsHard			#Points spawn less often
	j BonusPointsMultipleLoop

BonusPointsMultipleExit:
	addi $sp, $sp, -4
	sw $zero, 0($sp)
	
	jr $ra
	
############################## DrawBanner FUNCTION ############################## 
#This function draws the banner

DrawBanner:
	la $a0, topLeft
	li $a1, 0x3C4D69			#Dark blue
	
DrawBannerLoop:
	bgt $a0, topRight, DrawBannerExit	#Draw to the end of the screen
	 
	sw $a1, 0($a0)
	sw $a1, 512($a0)
	sw $a1, 1024($a0)
	sw $a1, 1536($a0)
	sw $a1, 2048($a0)
	sw $a1, 2560($a0)
	sw $a1, 3072($a0)
	sw $a1, 3584($a0)
	
DrawBannerLoopEnd:
	addi $a0, $a0, 4
	j DrawBannerLoop 
	
DrawBannerExit:
	jr $ra
	
############################## GameOverScore FUNCTION ############################## 
#This function outputs the score when the game is over it takes in a score

GameOverScore:
	lw $a2, 0($sp)		#Score
	addi $sp, $sp, 4
	
	addi $s2, $a2, 0
	
	lw $a0, 0($sp)		#Position
	addi $sp, $sp, 4
	
	addi $s0, $a0, 0
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $a1, 0xFFFFFF	#White
	
	sw $a1, 0($a0)		#The S
	sw $a1, 512($a0)
	sw $a1, 1024($a0)
	
	sw $a1, 4($a0)
	
	sw $a1, 8($a0)
	sw $a1, 1028($a0)
	sw $a1, 1032($a0)
	
	sw $a1, 1544($a0)
	
	sw $a1, 2056($a0)
	
	sw $a1, 2560($a0)
	sw $a1, 2564($a0)
	sw $a1, 2568($a0)
	
	sw $a1, 16($a0)		#The C
	sw $a1, 528($a0)
	sw $a1, 1040($a0)
	
	sw $a1, 20($a0)
	
	sw $a1, 24($a0)
	
	sw $a1, 1552($a0)
	
	sw $a1, 2064($a0)
	
	sw $a1, 2576($a0)
	sw $a1, 2580($a0)
	sw $a1, 2584($a0)
	
	sw $a1, 32($a0)		#The O
	sw $a1, 544($a0)
	sw $a1, 1056($a0)
	
	sw $a1, 36($a0)
	
	sw $a1, 40($a0)
	sw $a1, 552($a0)
	sw $a1, 1064($a0)
	
	sw $a1, 1568($a0)
	sw $a1, 1576($a0)
	
	sw $a1, 2080($a0)
	sw $a1, 2088($a0)
	
	sw $a1, 2592($a0)
	sw $a1, 2596($a0)
	sw $a1, 2600($a0)
	
	sw $a1, 48($a0)		#The R
	sw $a1, 560($a0)
	sw $a1, 1072($a0)
	sw $a1, 1584($a0)
	sw $a1, 2096($a0)
	sw $a1, 2608($a0)
	
	sw $a1, 52($a0)
	
	sw $a1, 56($a0)
	sw $a1, 572($a0)
	sw $a1, 1080($a0)
	
	sw $a1, 1076($a0)
	
	sw $a1, 1596($a0)
	
	sw $a1, 2108($a0)
	
	sw $a1, 2620($a0)
	
	sw $a1, 68($a0)		#The E
	sw $a1, 72($a0)
	sw $a1, 76($a0)
	
	sw $a1, 580($a0)
	
	sw $a1, 1092($a0)
	sw $a1, 1096($a0)
	
	sw $a1, 1604($a0)
	
	sw $a1, 2116($a0)
	
	sw $a1, 2628($a0)
	sw $a1, 2632($a0)
	sw $a1, 2636($a0)
	
	sw $a1, 596($a0)
	
	sw $a1, 2132($a0)
	
	addi $a3, $zero, 0
	
GameOverDigitOneLoop:				#First digit
	blt $a2, tenThousand, GameOverDrawDigitOne
	addi $a2, $a2, negativeTenThousand
	addi $a3, $a3, 1
	j GameOverDigitOneLoop

GameOverDrawDigitOne:
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	
	addi $s1, $s0, digitOne
	
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	
	jal GameOverDrawDigit
	addi $a3, $zero, 0
	
GameOverDigitTwoLoop:				#Second digit
	blt $a2, thousand, GameOverDrawDigitTwo
	addi $a2, $a2, negativeThousand
	addi $a3, $a3, 1
	j GameOverDigitTwoLoop

GameOverDrawDigitTwo:	
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	
	addi $s1, $s0, digitTwo
	
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	
	jal GameOverDrawDigit

	addi $a3, $zero, 0
	
GameOverDigitThreeLoop:				#Third digit
	blt $a2, hundred, GameOverDrawDigitThree
	addi $a2, $a2, negativeHundred
	addi $a3, $a3, 1
	j GameOverDigitThreeLoop

GameOverDrawDigitThree:
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	
	addi $s1, $s0, digitThree
	
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	
	jal GameOverDrawDigit

	addi $a3, $zero, 0
	
GameOverDigitFourLoop:				#Fourth digit
	blt $a2, ten, GameOverDrawDigitFour
	addi $a2, $a2, negativeTen
	addi $a3, $a3, 1
	j GameOverDigitFourLoop

GameOverDrawDigitFour:		
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	
	addi $s1, $s0, digitFour
	
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	
	jal GameOverDrawDigit

GameOverDrawDigitFive:				#Fifth digit
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	
	addi $s1, $s0, digitFive
	
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	
	jal GameOverDrawDigit
	
	lw $ra, 0($sp)		
	addi $sp, $sp, 4
	jr $ra
	
############################## GameOverDrawDigit FUNCTION ############################## 
#This function draws a digit when the game is over
 
GameOverDrawDigit:
	lw $a0, 0($sp)		#Pos
	addi $sp, $sp, 4
	lw $a1, 0($sp)		#Number
	addi $sp, $sp, 4
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal GameOverClearDigit	#Clear the digit
	
	lw $a0, 0($sp)		#Pos
	addi $sp, $sp, 4
	lw $a1, 0($sp)		#Number
	addi $sp, $sp, 4
	
	j CheckIfNine		#Check what number to draw
	
	lw $ra, 0($sp)		#Score
	addi $sp, $sp, 4
	jr $ra
	
############################## GameOverClearDigit FUNCTION ############################## 
#This function clears the digit at the end of the game

GameOverClearDigit:
	lw $a0, 0($sp)		
	addi $sp, $sp, 4
	
	li $a1, 0x000000	#Black
	
	sw $a1, 0($a0)
	sw $a1, 4($a0)
	sw $a1, 8($a0)
	
	sw $a1, 512($a0)
	sw $a1, 516($a0)
	sw $a1, 520($a0)
	
	sw $a1, 1024($a0)
	sw $a1, 1028($a0)
	sw $a1, 1032($a0)
		
	sw $a1, 1536($a0)
	sw $a1, 1540($a0)
	sw $a1, 1544($a0)
	
	sw $a1, 2048($a0)
	sw $a1, 2052($a0)
	sw $a1, 2056($a0)
	
	sw $a1, 2560($a0)
	sw $a1, 2564($a0)
	sw $a1, 2568($a0)
	
	jr $ra
	
############################## Welcome FUNCTION ############################## 
#This function prints the welcome screen

Welcome:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $a2, welcome		#Load welcome positon
	
	li $a1, 0xFFFFFF	#White
	
	li $v0, 32
	li $a0, 500 		# Wait 10 milliseconds before next loop
	syscall
	
	sw $a1, 0($a2)		#The W
	sw $a1, 512($a2)
	sw $a1, 1024($a2)
	sw $a1, 1536($a2)
	sw $a1, 2048($a2)
	sw $a1, 2564($a2)
	
	sw $a1, 2056($a2)
	sw $a1, 1544($a2)
	sw $a1, 2572($a2)
	
	sw $a1, 2064($a2)
	sw $a1, 1552($a2)
	sw $a1, 1040($a2)
	sw $a1, 528($a2)
	sw $a1, 16($a2)
	
	li $v0, 32
	li $a0, letterDelay 		# Wait 500 milliseconds before next loop
	syscall
	
	sw $a1, 24($a2)		#The E
	sw $a1, 536($a2)
	sw $a1, 1048($a2)
	sw $a1, 1560($a2)
	sw $a1, 2072($a2)
	sw $a1, 2584($a2)
	
	sw $a1, 28($a2)
	sw $a1, 32($a2)
	sw $a1, 36($a2)
	
	sw $a1, 1052($a2)
	sw $a1, 1056($a2)
	sw $a1, 36($a2)
	
	sw $a1, 2588($a2)
	sw $a1, 2592($a2)
	sw $a1, 2596($a2)
	
	li $v0, 32
	li $a0, letterDelay 		# Wait 500 milliseconds before next loop
	syscall
	
	sw $a1, 44($a2)		#The L
	sw $a1, 556($a2)
	sw $a1, 1068($a2)
	sw $a1, 1580($a2)
	sw $a1, 2092($a2)
	sw $a1, 2604($a2)
	
	sw $a1, 2608($a2)
	sw $a1, 2612($a2)
	
	li $v0, 32
	li $a0, letterDelay 		# Wait 500 milliseconds before next loop
	syscall
	
	sw $a1, 60($a2)		#The C
	sw $a1, 572($a2)
	sw $a1, 1084($a2)
	sw $a1, 1596($a2)
	sw $a1, 2108($a2)
	sw $a1, 2620($a2)
	
	sw $a1, 64($a2)
	sw $a1, 68($a2)
	sw $a1, 72($a2)
	
	sw $a1, 2624($a2)
	sw $a1, 2628($a2)
	sw $a1, 2632($a2)
	
	li $v0, 32
	li $a0, letterDelay 		# Wait 500 milliseconds before next loop
	syscall
	
	sw $a1, 80($a2)		#The 0
	sw $a1, 592($a2)
	sw $a1, 1104($a2)
	sw $a1, 1616($a2)
	sw $a1, 2128($a2)
	sw $a1, 2640($a2)
	
	sw $a1, 84($a2)
	sw $a1, 88($a2)
	sw $a1, 92($a2)
	
	sw $a1, 604($a2)
	sw $a1, 1116($a2)
	sw $a1, 1628($a2)
	sw $a1, 2140($a2)
	
	sw $a1, 2644($a2)
	sw $a1, 2648($a2)
	sw $a1, 2652($a2)
	
	li $v0, 32
	li $a0, letterDelay 		# Wait 500 milliseconds before next loop
	syscall
	
	sw $a1, 100($a2)		#The M
	sw $a1, 612($a2)
	sw $a1, 1124($a2)
	sw $a1, 1636($a2)
	sw $a1, 2148($a2)
	sw $a1, 2660($a2)
	
	sw $a1, 616($a2)
	sw $a1, 624($a2)
	sw $a1, 1132($a2)
	
	sw $a1, 2164($a2)
	sw $a1, 1652($a2)
	sw $a1, 1140($a2)
	sw $a1, 628($a2)
	sw $a1, 116($a2)
	sw $a1, 2676($a2)
	
	li $v0, 32
	li $a0, letterDelay 		# Wait 500 milliseconds before next loop
	syscall
	
	sw $a1, 124($a2)		#The E
	sw $a1, 636($a2)
	sw $a1, 1148($a2)
	sw $a1, 1660($a2)
	sw $a1, 2172($a2)
	sw $a1, 2684($a2)
	
	sw $a1, 128($a2)
	sw $a1, 132($a2)
	sw $a1, 136($a2)
	
	sw $a1, 1152($a2)
	sw $a1, 1156($a2)
	sw $a1, 136($a2)
	
	sw $a1, 2688($a2)
	sw $a1, 2692($a2)
	sw $a1, 2696($a2)
	
	li $v0, 32
	li $a0, letterDelay 		# Wait 500 milliseconds before next loop
	syscall
	
	la $a0, 0x1000DCD0
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal DrawShip		#Draw ship
	
	la $a0, 0x10008CD0
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal DrawShip		#Draw ship
	
	la $a0, 0x10008A00
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal DrawAsteroid		#Draw asteroid
	
	la $a0, 0x10008D0C
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal DrawAsteroid		#Draw asteroid
	
	la $a0, 0x1000A0F0
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal DrawAsteroid		#Draw asteroid
	
	la $a0, 0x1000B00C
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal DrawAsteroid		#Draw asteroid
	
	la $a0, 0x1000AFD0
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal DrawAsteroid		#Draw asteroid			
	
	la $a0, 0x1000D0F0
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal DrawAsteroid		#Draw asteroid
	
	la $a0, 0x1000DDC0
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal DrawAsteroid		#Draw asteroid
	
	la $a0, 0x1000DE20
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal DrawAsteroid		#Draw asteroid
	
	la $a0, 0x1000AC80
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal DrawLife			#Draw life
	
	la $a0, 0x1000DB6C
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal DrawLife			#Draw life
	
	la $a0, 0x10009990
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal DrawBonusPoints		#Draw points
	
	la $a0, 0x1000DA90
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal DrawBonusPoints		#Draw points
	
	lw $ra, 0($sp) 		
	addi $sp, $sp, 4
	
	jr $ra
	
############################## ClearScreen FUNCTION ############################## 
#This function clears the screen
	
ClearScreen:
	la $a0, topLeft
	li $a1, 0x000000	#Black
	
ClearLoop:
	bgt $a0, bottomRight, ClearLoopEnd
	sw $a1, 0($a0)
	addi $a0, $a0, 4
	j ClearLoop
	
ClearLoopEnd:
	jr $ra
	
############################## GameOver FUNCTION ############################## 
#This function draws the game over sign

GameOver:
	li $v0, 32
	li $a0, letterDelay 		# Wait 500 milliseconds before next loop
	syscall
	
	jal ClearScreen
	
	lw $a2, 0($sp)
	addi $sp, $sp, 4
	
	li $a1, 0xFFFFFF
	
	#Note each "group" of units represents one row in the Bitmap Display, groups are separated by spaces
	
	sw $a1, 8($a2)		#The Letter G
	sw $a1, 12($a2)	
	sw $a1, 16($a2)	
	sw $a1, 20($a2)
	sw $a1, 24($a2)		
	sw $a1, 28($a2)	
	sw $a1, 32($a2)	
	sw $a1, 36($a2)

	sw $a1, 520($a2)	
	sw $a1, 524($a2)	
	sw $a1, 528($a2)	
	sw $a1, 532($a2)
	sw $a1, 536($a2)		
	sw $a1, 540($a2)	
	sw $a1, 544($a2)	
	sw $a1, 548($a2)
	
	sw $a1, 1032($a2)	
	sw $a1, 1036($a2)	
	sw $a1, 1040($a2)	
	sw $a1, 1044($a2)
	sw $a1, 1048($a2)		
	sw $a1, 1052($a2)	
	sw $a1, 1056($a2)	
	sw $a1, 1060($a2)

	sw $a1, 1024($a2)	
	sw $a1, 1028($a2)	
	sw $a1, 1536($a2)	
	sw $a1, 1540($a2)
	sw $a1, 1544($a2)
	sw $a1, 2048($a2)	
	sw $a1, 2052($a2)
	sw $a1, 2056($a2)
	sw $a1, 2560($a2)	
	sw $a1, 2564($a2)
	sw $a1, 2568($a2)
	sw $a1, 3072($a2)	
	sw $a1, 3076($a2)
	sw $a1, 3080($a2)
	sw $a1, 3584($a2)	
	sw $a1, 3588($a2)
	sw $a1, 3592($a2)
	sw $a1, 4096($a2)	
	sw $a1, 4100($a2)
	sw $a1, 4104($a2)
	
	sw $a1, 4108($a2)	
	sw $a1, 4112($a2)	
	sw $a1, 4116($a2)	
	sw $a1, 4120($a2)
	sw $a1, 4124($a2)		
	sw $a1, 4128($a2)	
	sw $a1, 4132($a2)	
	
	sw $a1, 4616($a2)	
	sw $a1, 4620($a2)	
	sw $a1, 4624($a2)	
	sw $a1, 4628($a2)
	sw $a1, 4632($a2)		
	sw $a1, 4636($a2)	
	sw $a1, 4640($a2)	
	sw $a1, 4644($a2)
	
	sw $a1, 5128($a2)	
	sw $a1, 5132($a2)	
	sw $a1, 5136($a2)	
	sw $a1, 5140($a2)
	sw $a1, 5144($a2)		
	sw $a1, 5148($a2)	
	sw $a1, 5152($a2)	
	sw $a1, 5156($a2)
	
	sw $a1, 3612($a2)
	sw $a1, 3100($a2)
	sw $a1, 2588($a2)
	sw $a1, 2076($a2)
			
	sw $a1, 3616($a2)
	sw $a1, 3104($a2)
	sw $a1, 2592($a2)
	sw $a1, 2080($a2)
	
	sw $a1, 3620($a2)
	sw $a1, 3108($a2)
	sw $a1, 2596($a2)
	sw $a1, 2084($a2)
	
	sw $a1, 3096($a2)
	sw $a1, 3092($a2)
	sw $a1, 3088($a2)
	
	sw $a1, 2584($a2)
	sw $a1, 2580($a2)
	sw $a1, 2576($a2)

	sw $a1, 2072($a2)
	sw $a1, 2068($a2)
	sw $a1, 2064($a2)
	
	li $v0, 32
	li $a0, letterDelay 	# Wait 500 milliseconds before next loop
	syscall	
	
	sw $a1, 52($a2)		#The Letter A
	sw $a1, 56($a2)
	sw $a1, 60($a2)
	sw $a1, 64($a2)
	sw $a1, 68($a2)
	sw $a1, 72($a2)

	sw $a1, 564($a2)		
	sw $a1, 568($a2)
	sw $a1, 572($a2)
	sw $a1, 576($a2)
	sw $a1, 580($a2)
	sw $a1, 584($a2)
	
	sw $a1, 1068($a2)		
	sw $a1, 1072($a2)
	sw $a1, 1076($a2)
	sw $a1, 1080($a2)
	sw $a1, 1084($a2)
	sw $a1, 1088($a2)		
	sw $a1, 1092($a2)
	sw $a1, 1096($a2)
	sw $a1, 1100($a2)
	sw $a1, 1104($a2)

	sw $a1, 1580($a2)		
	sw $a1, 1584($a2)

	sw $a1, 1612($a2)
	sw $a1, 1616($a2)
	
	sw $a1, 2092($a2)		
	sw $a1, 2096($a2)
	sw $a1, 2100($a2)
	sw $a1, 2104($a2)
	sw $a1, 2108($a2)
	sw $a1, 2112($a2)		
	sw $a1, 2116($a2)
	sw $a1, 2120($a2)
	sw $a1, 2124($a2)
	sw $a1, 2128($a2)
	
	sw $a1, 2604($a2)		
	sw $a1, 2608($a2)
	sw $a1, 2612($a2)
	sw $a1, 2616($a2)
	sw $a1, 2620($a2)
	sw $a1, 2624($a2)		
	sw $a1, 2628($a2)
	sw $a1, 2632($a2)
	sw $a1, 2636($a2)
	sw $a1, 2640($a2)
	
	sw $a1, 3116($a2)		
	sw $a1, 3120($a2)
	sw $a1, 3124($a2)
	sw $a1, 3128($a2)
	sw $a1, 3132($a2)
	sw $a1, 3136($a2)		
	sw $a1, 3140($a2)
	sw $a1, 3144($a2)
	sw $a1, 3148($a2)
	sw $a1, 3152($a2)
	
	sw $a1, 3628($a2)		
	sw $a1, 3632($a2)
	
	sw $a1, 3660($a2)
	sw $a1, 3664($a2)

	sw $a1, 4140($a2)		
	sw $a1, 4144($a2)
	
	sw $a1, 4172($a2)
	sw $a1, 4176($a2)
	
	sw $a1, 4652($a2)		
	sw $a1, 4656($a2)
	
	sw $a1, 4684($a2)
	sw $a1, 4688($a2)
	
	sw $a1, 5164($a2)		
	sw $a1, 5168($a2)

	sw $a1, 5196($a2)
	sw $a1, 5200($a2)	
	
	li $v0, 32
	li $a0, letterDelay 	# Wait 500 milliseconds before next loop
	syscall	
	
	sw $a1, 88($a2)		#The letter M	
	sw $a1, 92($a2)
	
	sw $a1, 120($a2)
	sw $a1, 124($a2)
	
	sw $a1, 600($a2)
	sw $a1, 604($a2)		
	
	sw $a1, 632($a2)
	sw $a1, 636($a2)
	
	sw $a1, 1112($a2)
	sw $a1, 1116($a2)		
	sw $a1, 1120($a2)
	sw $a1, 1124($a2)
	
	sw $a1, 1136($a2)
	sw $a1, 1140($a2)		
	sw $a1, 1144($a2)
	sw $a1, 1148($a2)
	
	sw $a1, 1624($a2)
	sw $a1, 1628($a2)		
	sw $a1, 1632($a2)
	sw $a1, 1636($a2)
	
	sw $a1, 1648($a2)
	sw $a1, 1652($a2)		
	sw $a1, 1656($a2)
	sw $a1, 1660($a2)

	sw $a1, 2136($a2)
	sw $a1, 2140($a2)		
	sw $a1, 2144($a2)
	sw $a1, 2148($a2)
	sw $a1, 2152($a2)
	sw $a1, 2156($a2)		
	sw $a1, 2160($a2)
	sw $a1, 2164($a2)
	sw $a1, 2168($a2)
	sw $a1, 2172($a2)
	
	sw $a1, 2648($a2)
	sw $a1, 2652($a2)		

	sw $a1, 2664($a2)
	sw $a1, 2668($a2)		
	
	sw $a1, 2680($a2)
	sw $a1, 2684($a2)
	
	sw $a1, 3160($a2)
	sw $a1, 3164($a2)		
	
	sw $a1, 3176($a2)
	sw $a1, 3180($a2)		
	
	sw $a1, 3192($a2)
	sw $a1, 3196($a2)
	
	sw $a1, 3672($a2)
	sw $a1, 3676($a2)		
	
	sw $a1, 3704($a2)
	sw $a1, 3708($a2)
	
	sw $a1, 4184($a2)
	sw $a1, 4188($a2)		
	
	sw $a1, 4216($a2)
	sw $a1, 4220($a2)
	
	sw $a1, 4696($a2)
	sw $a1, 4700($a2)		
	
	sw $a1, 4728($a2)
	sw $a1, 4732($a2)
	
	sw $a1, 5208($a2)
	sw $a1, 5212($a2)		
	
	sw $a1, 5240($a2)
	sw $a1, 5244($a2)
	
	li $v0, 32
	li $a0, letterDelay 	# Wait 500 milliseconds before next loop
	syscall	
	
	sw $a1, 140($a2)	#The Letter E
	sw $a1, 144($a2)	
	sw $a1, 148($a2)		
	sw $a1, 152($a2)	
	sw $a1, 156($a2)	
	sw $a1, 160($a2)
	sw $a1, 164($a2)		
	sw $a1, 168($a2)	
	
	sw $a1, 652($a2)	
	sw $a1, 656($a2)
	sw $a1, 660($a2)		
	sw $a1, 664($a2)	
	sw $a1, 668($a2)	
	sw $a1, 672($a2)
	sw $a1, 676($a2)	
	sw $a1, 680($a2)	
	
	sw $a1, 1164($a2)
	sw $a1, 1168($a2)
	sw $a1, 1172($a2)		
	sw $a1, 1176($a2)	
	sw $a1, 1180($a2)	
	sw $a1, 1184($a2)
	sw $a1, 1188($a2)	
	sw $a1, 1192($a2)
		
	sw $a1, 1156($a2)	
	sw $a1, 1160($a2)

	sw $a1, 1668($a2)
	sw $a1, 1672($a2)	
	sw $a1, 1676($a2)

	sw $a1, 2180($a2)
	sw $a1, 2184($a2)	
	sw $a1, 2188($a2)

	sw $a1, 2692($a2)
	sw $a1, 2696($a2)	
	sw $a1, 2700($a2)
	
	sw $a1, 3204($a2)
	sw $a1, 3208($a2)	
	sw $a1, 3212($a2)
	
	sw $a1, 3716($a2)
	sw $a1, 3720($a2)	
	sw $a1, 3724($a2)

	sw $a1, 4228($a2)
	sw $a1, 4232($a2)	
	sw $a1, 4236($a2)
	
	sw $a1, 2188($a2)
	sw $a1, 2192($a2)
	sw $a1, 2196($a2)		
	sw $a1, 2200($a2)		
	
	sw $a1, 2700($a2)
	sw $a1, 2704($a2)
	sw $a1, 2708($a2)		
	sw $a1, 2712($a2)		

	sw $a1, 3212($a2)
	sw $a1, 3216($a2)
	sw $a1, 3220($a2)		
	sw $a1, 3224($a2)		

	sw $a1, 4240($a2)
	sw $a1, 4244($a2)
	sw $a1, 4248($a2)		
	sw $a1, 4252($a2)	
	sw $a1, 4256($a2)	
	sw $a1, 4260($a2)	
	sw $a1, 4264($a2)	

	sw $a1, 4748($a2)	
	sw $a1, 4752($a2)	
	sw $a1, 4756($a2)
	sw $a1, 4760($a2)		
	sw $a1, 4764($a2)	
	sw $a1, 4768($a2)	
	sw $a1, 4772($a2)
	sw $a1, 4776($a2)		

	sw $a1, 5260($a2)
	sw $a1, 5264($a2)
	sw $a1, 5268($a2)
	sw $a1, 5272($a2)		
	sw $a1, 5276($a2)	
	sw $a1, 5280($a2)	
	sw $a1, 5284($a2)
	sw $a1, 5288($a2)
	
	li $v0, 32
	li $a0, letterDelay 		# Wait 500 milliseconds before next loop
	syscall	
	
	sw $a1, 7176($a2)		#The Letter 0
	sw $a1, 7180($a2)	
	sw $a1, 7184($a2)	
	sw $a1, 7188($a2)
	sw $a1, 7192($a2)		
	sw $a1, 7196($a2)	
	
	sw $a1, 7688($a2)	
	sw $a1, 7692($a2)	
	sw $a1, 7696($a2)	
	sw $a1, 7700($a2)
	sw $a1, 7704($a2)		
	sw $a1, 7708($a2)	

	sw $a1, 8200($a2)	
	sw $a1, 8204($a2)	
	sw $a1, 8208($a2)	
	sw $a1, 8212($a2)
	sw $a1, 8216($a2)		
	sw $a1, 8220($a2)	
	sw $a1, 8224($a2)	
	sw $a1, 8228($a2)

	sw $a1, 8192($a2)	
	sw $a1, 8196($a2)	
	
	sw $a1, 8704($a2)	
	sw $a1, 8708($a2)
	sw $a1, 8712($a2)
	
	sw $a1, 9216($a2)	
	sw $a1, 9220($a2)
	sw $a1, 9224($a2)
	
	sw $a1, 9728($a2)	
	sw $a1, 9732($a2)
	sw $a1, 9736($a2)
	
	sw $a1, 10240($a2)	
	sw $a1, 10244($a2)
	sw $a1, 10248($a2)
	
	sw $a1, 10752($a2)	
	sw $a1, 10756($a2)
	sw $a1, 10760($a2)

	sw $a1, 11264($a2)	
	sw $a1, 11268($a2)
	sw $a1, 11272($a2)
	
	sw $a1, 11276($a2)	
	sw $a1, 11280($a2)	
	sw $a1, 11284($a2)	
	sw $a1, 11288($a2)
	sw $a1, 11292($a2)		
	sw $a1, 11296($a2)	
	sw $a1, 11300($a2)	
	
	sw $a1, 11784($a2)	
	sw $a1, 11788($a2)	
	sw $a1, 11792($a2)	
	sw $a1, 11796($a2)
	sw $a1, 11800($a2)		
	sw $a1, 11804($a2)	
	
	sw $a1, 12296($a2)	
	sw $a1, 12300($a2)	
	sw $a1, 12304($a2)	
	sw $a1, 12308($a2)
	sw $a1, 12312($a2)		
	sw $a1, 12316($a2)	
			
	sw $a1, 11292($a2)
	sw $a1, 10780($a2)
	sw $a1, 10268($a2)
	sw $a1, 9756($a2)
	sw $a1, 9244($a2)
	sw $a1, 8732($a2)
	
	sw $a1, 11296($a2)
	sw $a1, 10784($a2)
	sw $a1, 10272($a2)
	sw $a1, 9760($a2)
	sw $a1, 9248($a2)
	sw $a1, 8736($a2)
	
	sw $a1, 11300($a2)
	sw $a1, 10788($a2)
	sw $a1, 10276($a2)
	sw $a1, 9764($a2)	
	sw $a1, 9252($a2)
	sw $a1, 8740($a2)
	
	li $v0, 32
	li $a0, letterDelay 	# Wait 500 milliseconds before next loop
	syscall					
	
	sw $a1, 7212($a2)	#The Letter V	
	sw $a1, 7216($a2)		
	
	sw $a1, 7724($a2)	
	sw $a1, 7728($a2)
	
	sw $a1, 8236($a2)	
	sw $a1, 8240($a2)
	
	sw $a1, 8748($a2)	
	sw $a1, 8752($a2)

	sw $a1, 9260($a2)	
	sw $a1, 9264($a2)
	
	sw $a1, 9772($a2)	
	sw $a1, 9776($a2)
	
	sw $a1, 10284($a2)	
	sw $a1, 10288($a2)
	
	sw $a1, 10292($a2)	
	sw $a1, 10296($a2)	
		
	sw $a1, 10800($a2)
	sw $a1, 10804($a2)		
	sw $a1, 10808($a2)
		
	sw $a1, 11312($a2)	
	sw $a1, 11316($a2)	
	sw $a1, 11320($a2)
		
	sw $a1, 11324($a2)	
	sw $a1, 11328($a2)	
	
	sw $a1, 11836($a2)	
	sw $a1, 11840($a2)
		
	sw $a1, 12348($a2)	
	sw $a1, 12352($a2)
	
	sw $a1, 12312($a2)		
	sw $a1, 12316($a2)	
			
	sw $a1, 11332($a2)
	sw $a1, 11336($a2)
	sw $a1, 11340($a2)
	
	sw $a1, 10820($a2)
	sw $a1, 10824($a2)
	sw $a1, 10828($a2)
	
	sw $a1, 10308($a2)
	sw $a1, 10312($a2)
	sw $a1, 10316($a2)
	sw $a1, 10320($a2)
	
	sw $a1, 7244($a2)		
	sw $a1, 7248($a2)		
	
	sw $a1, 7756($a2)	
	sw $a1, 7760($a2)
	
	sw $a1, 8268($a2)	
	sw $a1, 8272($a2)
	
	sw $a1, 8780($a2)	
	sw $a1, 8784($a2)
	
	sw $a1, 9292($a2)	
	sw $a1, 9296($a2)
	
	sw $a1, 9804($a2)	
	sw $a1, 9808($a2)
	
	sw $a1, 10316($a2)	
	sw $a1, 10320($a2)
	
	li $v0, 32
	li $a0, letterDelay 	# Wait 500 milliseconds before next loop
	syscall	
	
	sw $a1, 7264($a2)	#The Letter E	
	sw $a1, 7268($a2)	
	sw $a1, 7272($a2)
	sw $a1, 7276($a2)		
	sw $a1, 7280($a2)	
	sw $a1, 7284($a2)
	sw $a1, 7288($a2)	
	sw $a1, 7292($a2)
		
	sw $a1, 7776($a2)
	sw $a1, 7780($a2)		
	sw $a1, 7784($a2)	
	sw $a1, 7788($a2)	
	sw $a1, 7792($a2)
	sw $a1, 7796($a2)	
	sw $a1, 7800($a2)	
	sw $a1, 7804($a2)
	
	sw $a1, 8280($a2)
	sw $a1, 8284($a2)		
	sw $a1, 8288($a2)	
	sw $a1, 8292($a2)	
	sw $a1, 8296($a2)
	sw $a1, 8300($a2)	
	sw $a1, 8304($a2)	
	sw $a1, 8308($a2)
	sw $a1, 8312($a2)	
	sw $a1, 8316($a2)
		
	sw $a1, 8792($a2)	
	sw $a1, 8796($a2)
	sw $a1, 8800($a2)
	
	sw $a1, 9304($a2)	
	sw $a1, 9308($a2)
	sw $a1, 9312($a2)
	
	sw $a1, 9816($a2)	
	sw $a1, 9820($a2)
	sw $a1, 9824($a2)
	
	sw $a1, 10328($a2)	
	sw $a1, 10332($a2)
	sw $a1, 10336($a2)
	
	sw $a1, 10840($a2)	
	sw $a1, 10844($a2)
	sw $a1, 10848($a2)
	
	sw $a1, 11352($a2)	
	sw $a1, 11356($a2)
	sw $a1, 11360($a2)
	
	sw $a1, 9312($a2)
	sw $a1, 9316($a2)		
	sw $a1, 9320($a2)	
	sw $a1, 9324($a2)	
	
	sw $a1, 9824($a2)
	sw $a1, 9828($a2)		
	sw $a1, 9832($a2)	
	sw $a1, 9836($a2)	
	
	sw $a1, 10336($a2)
	sw $a1, 10340($a2)		
	sw $a1, 10344($a2)	
	sw $a1, 10348($a2)	
	
	sw $a1, 11364($a2)
	sw $a1, 11368($a2)		
	sw $a1, 11372($a2)	
	sw $a1, 11376($a2)	
	sw $a1, 11380($a2)	
	sw $a1, 11384($a2)	
	sw $a1, 11388($a2)
	
	sw $a1, 11872($a2)	
	sw $a1, 11876($a2)	
	sw $a1, 11880($a2)
	sw $a1, 11884($a2)		
	sw $a1, 11888($a2)	
	sw $a1, 11892($a2)	
	sw $a1, 11896($a2)
	sw $a1, 11900($a2)		
		
	sw $a1, 12384($a2)
	sw $a1, 12388($a2)
	sw $a1, 12392($a2)
	sw $a1, 12396($a2)		
	sw $a1, 12400($a2)	
	sw $a1, 12404($a2)	
	sw $a1, 12408($a2)
	sw $a1, 12412($a2)
	
	li $v0, 32
	li $a0, letterDelay 		# Wait 500 milliseconds before next loop
	syscall	
	
	sw $a1, 7300($a2)		#The Letter R
	sw $a1, 7304($a2)	
	sw $a1, 7308($a2)	
	sw $a1, 7312($a2)
	sw $a1, 7316($a2)		
	sw $a1, 7320($a2)
	sw $a1, 7324($a2)		
	sw $a1, 7328($a2)
	
	sw $a1, 7812($a2)	
	sw $a1, 7816($a2)	
	sw $a1, 7820($a2)	
	sw $a1, 7824($a2)
	sw $a1, 7828($a2)		
	sw $a1, 7832($a2)
	sw $a1, 7836($a2)		
	sw $a1, 7840($a2)	
	
	sw $a1, 8324($a2)	
	sw $a1, 8328($a2)	
	sw $a1, 8332($a2)	
	sw $a1, 8336($a2)
	sw $a1, 8340($a2)		
	sw $a1, 8344($a2)	
	sw $a1, 8348($a2)	
	sw $a1, 8352($a2)	
	sw $a1, 8356($a2)	
	sw $a1, 8360($a2)
	
	sw $a1, 8836($a2)	
	sw $a1, 8840($a2)

	sw $a1, 8864($a2)	
	sw $a1, 8868($a2)
	sw $a1, 8872($a2)
	
	sw $a1, 9348($a2)	
	sw $a1, 9352($a2)
	sw $a1, 9356($a2)	
	sw $a1, 9360($a2)
	sw $a1, 9364($a2)	
	sw $a1, 9368($a2)
	sw $a1, 9372($a2)	
	sw $a1, 9376($a2)	
	sw $a1, 9380($a2)
	sw $a1, 9384($a2)
	
	sw $a1, 9860($a2)
	sw $a1, 9864($a2)	
	sw $a1, 9868($a2)	
	sw $a1, 9872($a2)
	sw $a1, 9876($a2)		
	sw $a1, 9880($a2)
	sw $a1, 9884($a2)		
	sw $a1, 9888($a2)
	
	sw $a1, 10372($a2)	
	sw $a1, 10376($a2)	
	sw $a1, 10380($a2)	
	sw $a1, 10384($a2)
	sw $a1, 10388($a2)		
	sw $a1, 10392($a2)
	sw $a1, 10396($a2)		
	sw $a1, 10400($a2)
	
	sw $a1, 10884($a2)	
	sw $a1, 10888($a2)
	
	sw $a1, 11396($a2)	
	sw $a1, 11400($a2)

	sw $a1, 11908($a2)	
	sw $a1, 11912($a2)
	
	sw $a1, 12420($a2)	
	sw $a1, 12424($a2)
	
	sw $a1, 10896($a2)	
	sw $a1, 10900($a2)	
	sw $a1, 10904($a2)
	
	sw $a1, 11408($a2)	
	sw $a1, 11412($a2)	
	sw $a1, 11416($a2)
	
	sw $a1, 11420($a2)	
	sw $a1, 11424($a2)
	
	sw $a1, 11928($a2)	
	sw $a1, 11932($a2)	
	sw $a1, 11936($a2)
	
	sw $a1, 12440($a2)	
	sw $a1, 12444($a2)	
	sw $a1, 12448($a2)
	
	li $v0, 32
	li $a0, letterDelay 		# Wait 500 milliseconds before next loop
	syscall	
	
	addi $s0, $zero, gameOverPos
	addi $s0, $s0, 13824
	
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	
	addi $sp, $sp, -4
	sw $t6, 0($sp)
	
	jal GameOverScore
	
	li $v0, 32
	li $a0, letterDelay 		# Wait 500 milliseconds before next loop
	syscall	
	
	la $a0, 0x10008404
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal AsteroidExplode		#Draw asteroid explode
	
	la $a0, 0x100082F0
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal AsteroidExplode		#Draw asteroid explode
	
	la $a0, 0x100095D0
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal AsteroidExplode		#Draw asteroid explode
	
	la $a0, 0x1000DA80
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal AsteroidExplode		#Draw asteroid explode
	
	la $a0, 0x1000DFD0
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal AsteroidExplode		#Draw asteroid explode
	
	la $a0, 0x1000BB90
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal AsteroidExplode
	
	la $a0, 0x1000BA00
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal AsteroidExplode
	
	la $a0, 0x1000F100
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	jal AsteroidExplode
	
GameOverLoop:
	li $t9, 0xffff0000	#Check if key pressed
	lw $t7, 0($t9)
	
	bne $t7, 1, GameOverLoop
	lw $t7, 4($t9) 		
	
	bne $t7, 0x70, Exit	#If key is 'p' then reset otherwise end game

	jal Reset
	jal ClearScreen
	j Main

Exit:	
	li $v0, 10 # terminate the program gracefully
	syscall

#The game is over :)






