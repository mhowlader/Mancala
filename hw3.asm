# Mohtasim Howlader
# mohowlader
# 112937689

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

.text

load_game:

	addi $sp, $sp, -28
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)

	move $s0, $a0 #move the address of the state into $s0
	move $s1, $a1 #move the filename to $s1


	#opening file
	li $v0, 13
	move $a0, $s1 #move fiilename into a0
	li $a1, 0 #set flag to read-only
	li $a2, 0 #set mode to 0, ignore it
	syscall 
	bltz $v0, file_error #if v0 is negative, than go to filerror and end load game, otherwise continuue to readfile
	move $s2, $v0 #store the file descriptor into $s2

	#reading file
	addi $sp, $sp, -4 #create memory buffer to hold each character read when parsing file
	li $s3, 0 #total number of stones in the game
	
	#first line (number of stones in top mancala
	li $t5, 0 #total number of stones in top mancala
	li $v0, 14 #syscall for reading file
	move $a0, $s2 #move file descriptor into a0
	move $a1, $sp #stack will hold the memory buffer for each character
	li $a2, 1 #only store one character at a time
	


	
	firstlineloop:
		li $v0, 14
		syscall #read 1 character from the file
	
		lbu $t0, 0($sp) #retrive the character read from the file
		li $t1, '\n' #check if equal to \n
		li $t2, '\r' #checkk if equal to \r
		beq $t0, $t1, endfirstline
		beq $t0, $t2, endfirstbackrn
		addi $t0, $t0, -48 #convert from ascii to binary
		li $t3, 10
		mult $t5, $t3 #multiple number of stones by 10
		mflo $t4 #product
		add $t5, $t4, $t0 #add to total number of stones in top manacala

		j firstlineloop
	
		
	endfirstbackrn:
		li $v0, 14
		syscall #skip once
	endfirstline:
		sb $t5, 1($s0) #store number of stones in top mancala into gamestate
		add $s3, $s3, $t5 #add total number of stones in top mancala to total stones overall
	
	

	#2nd line (number of stones in bottom moncala
	li $t5, 0 #total number of stones in bottom mancala
	li $v0, 14 #syscall for reading file
	move $a0, $s2 #move file descriptor into a0
	move $a1, $sp #stack will hold the memory buffer for each character
	li $a2, 1 #only store one character at a time
	
	secondlineloop:
		li $v0, 14
		syscall #read 1 character from the file
	
		lbu $t0, 0($sp) #retrive the character read from the file
		li $t1, '\n' #check if equal to \n
		li $t2, '\r' #checkk if equal to \r
		beq $t0, $t1, endsecondline
		beq $t0, $t2, endsecondbackrn
		addi $t0, $t0, -48 #convert from ascii to binary
		li $t3, 10
		mult $t5, $t3 #multiple number of stones by 10
		mflo $t4 #product
		add $t5, $t4, $t0 #add to total number of stones in top manacala

		j secondlineloop
	
		
	endsecondbackrn:
		li $v0, 14
		syscall #skip once
	endsecondline:
		sb $t5, 0($s0) #store number of stones in top mancala into gamestate
		add $s3, $s3, $t5 #add total number of stones in top mancala to total stones overall
	
	#3rd line(number of pockets	)
	li $t5, 0 #total number of pockets in each row
	li $v0, 14 #syscall for reading file
	move $a0, $s2 #move file descriptor into a0
	move $a1, $sp #stack will hold the memory buffer for each character
	li $a2, 1 #only store one character at a time
	
	thirdlineloop:
		li $v0, 14
		syscall #read 1 character from the file
	
		lbu $t0, 0($sp) #retrive the character read from the file
		li $t1, '\n' #check if equal to \n
		li $t2, '\r' #checkk if equal to \r
		beq $t0, $t1, endthirdline
		beq $t0, $t2, endthirdbackrn
		addi $t0, $t0, -48 #convert from ascii to binary
		li $t3, 10
		mult $t5, $t3 #multiple number of pockets by 10
		mflo $t4 #product
		add $t5, $t4, $t0 #add to total number of pockets in each row

		j thirdlineloop
	
		
	endthirdbackrn:
		li $v0, 14
		syscall #skip once
	endthirdline:
		sb $t5, 2($s0) #store number of pockets in bottom row
		sb $t5, 3($s0) #store number of pockets in top row
		#li $t0, 49 #upper limit for how many pockets allowed
		#ble $t5, $t0, endpockets #if greater than 49, then going to be an error
		#li $v1, 0 #if exceeds 49, then v1 is 0
		#j gameboard
	
	endpockets:
		add $s6, $t5, $t5 #multiply pockets by 2, store in s6
		sb $0, 4($s0) #moves executed starts at 0
		li $t0, 'B' #B for player 1
		sb $t0, 5($s0) #store player in for player turn

	#fill gameboard with number of stones in mancalas and pockets in ascii
	gameboard:
	
		#first two characters will be numebr of stones in top mancala
		lbu $s4, 1($s0) #get top mancala
		lbu $s5, 0($s0) #get bottom mancala
		addi $s0, $s0, 6 #shift the gamestate address to the gameboard
		li $t0, 10 #going to divide by 10
		div $s4, $t0 #divide top mancala by 10
		mfhi $t1 #first digit of top mancala
		mflo $t2 #second digit of top manala
		addi $t1, $t1, 48
		sb $t1, 0($s0) #store first digit of num stones in top mancala
		addi $t2, $t2, 48
		sb $t2, 1($s0) #store second digit of num stones in top mancala
		addi $s0, $s0, 2 #shift gamestate address now to be filled with num stones in pockets
		
	#starting to read each num of stones in each pocket in top row one at a time and copy to game state
	li $t5, 0 #total number of stones for each pocket
	li $v0, 14 #syscall for reading file
	move $a0, $s2 #move file descriptor into a0
	move $a1, $sp #stack will hold the memory buffer for each character
	li $a2, 1 #only store one character at a time
	
	toprowloop:
		li $v0, 14
		syscall
	
		lbu $t0, 0($sp) #retrive the character read from the file
		li $t1, '\n' #check if equal to \n
		li $t2, '\r' #checkk if equal to \r
		beq $t0, $t1, botrow
		beq $t0, $t2, endtoprowrn
		
		sb $t0, 0($s0) #store the character from the file and place it in gameboard
		addi $t0, $t0, -48 #convert to binary, store in total number of stones in the pocket
		li $t1, 10
		mult $t0, $t1
		mflo $t5 #multiply first digit by 10 and store in t5
		
		addi $s0, $s0, 1 #shift gameboard by 1
		
		li $v0, 14
		syscall
		
		lbu $t0, 0($sp) #retrive the character read from the file
		sb $t0, 0($s0) #store second digit character in gameboard
		addi $t0, $t0, -48 #convert second digit character to binary
		add $t5, $t5, $t0 #add second digit to total
		
		addi $s0, $s0, 1 #shift gameboard by 1
		add $s3, $s3, $t5 #add number of stones in the pocket tot toal num of stones in the board
		
		j toprowloop
	
	endtoprowrn:
		li $v0, 14
		syscall #skip a space
	
		
	#set up reading each character in bottom row one character at a time
	botrow: 
		li $t5, 0 #total number of stones for each pocket
		li $v0, 14 #syscall for reading file
		move $a0, $s2 #move file descriptor into a0
		move $a1, $sp #stack will hold the memory buffer for each character
		li $a2, 1 #only store one character at a time
	botrowloop:
		li $v0, 14
		syscall
		beq, $v0, $0, endbotrow
		lbu $t0, 0($sp) #retrive the character read from the file
		li $t1, '\n' #check if equal to \n
		li $t2, '\r' #checkk if equal to \r
		beq $t0, $t1, endbotrow
		beq $t0, $t2, endbotrow
		
		sb $t0, 0($s0) #store the character from the file and place it in gameboard
		addi $t0, $t0, -48 #convert to binary, store in total number of stones in the pocket
		li $t1, 10
		mult $t0, $t1
		mflo $t5 #multiply first digit by 10 and store in t5
		
		addi $s0, $s0, 1 #shift gameboard by 1
		
		li $v0, 14
		syscall
		
		lbu $t0, 0($sp) #retrive the character read from the file
		sb $t0, 0($s0) #store second digit character in gameboard
		addi $t0, $t0, -48 #convert second digit character to binary
		add $t5, $t5, $t0
		
		addi $s0, $s0, 1 #shift gameboard by 1
		add $s3, $s3, $t5 #add number of stones in the pocket tot toal num of stones in the board
		
		j botrowloop
	
		
	endbotrow:	
		li $t0, 10 #going to divide by 10
		div $s5, $t0 #divide top mancala by 10
		mfhi $t1 #first digit of top mancala
		mflo $t2 #second digit of top manala
		addi $t1, $t1, 48
		sb $t1, 0($s0) #store first digit of num stones in top mancala
		addi $t2, $t2, 48
		sb $t2, 1($s0) #store second digit of num stones in top mancala
		addi $s0, $s0, 2 #shift gamestate address now to be filled with num stones in pockets
		sb $0, 0($s0) #add null character to end of string
	closefile:
	#end reading file
	addi $sp, $sp, 4 #readdjust stack pointer
	
	li $v0, 16 #syscall close file
	move $a0, $s2 #file descriptor into s2
	syscall
	
	li $t0, 99
	bgt $s3, $t0, stone_error #if total stones greater than 99 then stones error, otherwise no stones error
	li $v0, 1 #set to 1 if no stone error
	j checkpockets
	 
	stone_error:
		li $v0, 0 #set to 0 if stone error
	
	checkpockets:
		li $t0, 98
		bgt $s6, $t0, pockets_error
		move $v1, $s6 #move total num pockets to v1
		j end_load_game
	
	pockets_error:
		li $v1, 0
		j end_load_game
	

	
	file_error:
		li $v0, -1
		li $v1, -1
		j end_load_game

	end_load_game:
	
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s6, 24($sp)
		addi $sp, $sp, 28
		jr $ra
get_pocket:
	
	addi $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	

	move $s0, $a0 #store state address
	move $s1, $a1 #store player
	move $s2, $a2 #distance from mancala
	
	li $t0, 'B' #check if B
	li $t1, 'T'
	beq $s1, $t0, playervalid
	beq $s1, $t1, playervalid
	j pocket_error #if not B or T, then error
	
	playervalid:
	
	#check if distance is valid
	bltz $s2, pocket_error #if less than 0 than error
	lbu $s3, 2($s0) #retrive the number of pockets in each row
	addi $t0, $s3, -1 #lower it by 1 to account for index
	bgt $s2, $t0, pocket_error #if distance is greater than total number of pockets in each row than error
	
	#create increment based on whether B or T
	addi $s0, $s0, 8 #go to beginning of gameboard (player 2's first pocket)
	li $t0, 'T' 
	bne $s1, $t0, bottom_inc #if B then go to bottom inc
	li $s4, 2 #if top then each increment is 2
	j pocket_loop #jump to pocketloop
	#if bottom then have to go to end of gameboard and go backwards from there
	bottom_inc:
		li $s4, -2 #have to go backwards if starting from bottom mancala
		li $t0, 4 #multiply 4
		mult $s3, $t0 #multiply num pockets by 4
		mflo $t0 
		addi $t0, $t0, -2 #subtract 2
		add $s0, $s0, $t0 #add it by the offset to get to the pocket next to bottom mancala
		
	pocket_loop:	
		
		beq $s2, $0, eval_pocket #while distance is not equal to 0, continue looop, otherwise go to evaluate the num stones in current pocket
		add $s0, $s0, $s4 #increment
		addi $s2, $s2 , -1
		j pocket_loop
	
	eval_pocket:
		lbu $t0, 0($s0) #get first digit
		addi $t0, $t0, -48 #convert to binary
		li $t1, 10
		mult $t0, $t1
		mflo $t0 #multipyl first digit by 10
		lbu $t2, 1($s0) #get second digit
		addi $t2, $t2, -48
		add $t0, $t0, $t2 #combine the first and second digit together to get number of stone in the pocket
		move $v0, $t0
		j end_get_pocket
		
	pocket_error:
		li $v0, -1
		j end_get_pocket 
	

	end_get_pocket:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		addi $sp, $sp, 20
		jr $ra
set_pocket:
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)

	move $s0, $a0 #store state address
	move $s1, $a1 #store player
	move $s2, $a2 #distance from mancala
	move $s5, $a3 #store the number to be inserted into pocket
	
	li $t0, 'B' #check if B
	li $t1, 'T'
	beq $s1, $t0, playervalid2
	beq $s1, $t1, playervalid2
	j pocket_error2 #if not B or T, then error
	
	playervalid2:
	
	#check if distance is valid
	bltz $s2, pocket_error2
	lbu $s3, 2($s0) #retrive the number of pockets
	addi $t0, $s3, -1 #lower it by 1 to account for index
	bgt $s2, $t0, pocket_error2 #if distance is greater than total number of pockets than error
	
	#check if size is valid
	li $t0, 99
	bgt $s5, $t0, size_error #if size is greater than 99, then size error
	
	#create increment based on whether B or T
	addi $s0, $s0, 8 #go to beginning of gameboard (player 2's first pocket)
	li $t0, 'T' 
	bne $s1, $t0, bottom_inc2 #if B then go to bottom inc
	li $s4, 2 #if top then each increment is 2
	j pocket_loop2 #jump to pocketloop
	#if bottom then have to go to end of gameboard and go backwards from there
	bottom_inc2:
		li $s4, -2 #have to go backwards if starting from bottom mancala
		li $t0, 4 #multiply 4
		mult $s3, $t0 #multiply num pockets by 4
		mflo $t0 
		addi $t0, $t0, -2 #subtract 2
		add $s0, $s0, $t0 #add it by the offset to get to the pocket next to bottom mancala
		
	pocket_loop2:	
		
		beq $s2, $0, eval_pocket2 #while distance is not equal to 0, continue looop, otherwise go to evaluate the num stones in current pocket
		add $s0, $s0, $s4 #increment
		addi $s2, $s2 , -1
		j pocket_loop2
	
	#insert size into the pocket
	eval_pocket2:
		li $t0, 10 #divide by 10
		div $s5, $t0
		mflo $t0 #first digit
		mfhi $t1 #second digit
		
		addi $t0, $t0, 48
		addi $t1, $t1, 48 #convert to ascii
		
		sb $t0, 0($s0)
		sb $t1, 1($s0) #store the characters
	
		move $v0, $s5 #store size in v0
		j end_set_pocket
		
	pocket_error2:
		li $v0, -1
		j end_set_pocket 
	
	size_error:	
		li $v0, -2
		j end_set_pocket

	
	end_set_pocket:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		addi $sp, $sp, 24
		jr $ra
collect_stones:
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)


	move $s0, $a0 #pointer to state address
	move $s1, $a1 #player
	move $s2, $a2 #stones to add to mancala
	
	
	li $t0, 'B' #check if B
	li $t1, 'T'
	beq $s1, $t0, playervalid3
	beq $s1, $t1, playervalid3
	j player_error #if not B or T, then error
	
	playervalid3:
	
	blez $s2, stones_mancala_error #if stones to be added is 0 or less than erorr
	
	li $t0, 'T'
	#if bottom player then change bottom mancala byte and go to end of gameboard
	bne $s1, $t0, bottom_coll #if top plsyer, then change the topmancala byte
	lbu $s3, 1($s0) #get number of stones in top mancala
	add $s3, $s3, $s2 #add stones to orgiinal amount in mancala
	sb $s3, 1($s0) #store number of stones in top mancala byte
	addi $s0, $s0, 6 #to to top mancana in gameboard
	j update_mancala
	
	#uupdate bottom mancala byte and move state address to bottom mancala
	bottom_coll: 
		lbu $s3, 0($s0) #get bottom mancala byte
		add $s3, $s3, $s2 #add stones to amount in mancala
		sb $s3, 0($s0) #update bottom mancala byte
		lbu $t1, 2($s0) #store in t1 the nmber of pockets in each row
		li $t0, 8
		add $s0, $s0, $t0 #add #s0 with 8 to get to first pocket after top mancala
		li $t2, 4 
		mult $t1, $t2 #mult num pockets in each row by 4 to get the increment needed to get to bottom mancala
		mflo $t1
		add $s0, $s0, $t1 #move state address to bottom mancala

	update_mancala:
		li $t0, 10 #divide by 10
		div $s3, $t0
		mflo $t0 #first digit
		mfhi $t1 #second digit
		
		addi $t0, $t0, 48
		addi $t1, $t1, 48 #convert to ascii
		
		sb $t0, 0($s0)
		sb $t1, 1($s0) #store the characters
	
		move $v0, $s2 #store size in v0
		j end_collect_stones
	player_error:
		li $v0, -1
		j end_collect_stones
		
	stones_mancala_error:
		li $v0, -2
		j end_collect_stones
	
	

	end_collect_stones:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		addi $sp, $sp, 16
		jr $ra
verify_move:
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)

	move $s0, $a0 #state
	move $s1, $a1 #origin pocket
	move $s2, $a2 #distacnce num pockets to move from origin pocket
	
	li $t0, 99
	beq $s2, $t0, turn_swap #if distance equal to 99 then turnswap
	
	#check if origin pocket is invalid for row size
	bltz $s1, origin_pocket_error #if origin pocket less than 0, then error
	lbu $t0, 2($s0) #get num of pockets in row
	addi $t0, $t0, -1 #subtract by 1 to account for the 0th index
	bgt $s1, $t0, origin_pocket_error #if origin pocket greater than total number of pockets in the row, error
	
	#check if distance is an error
	beqz $s2, distance_error #if equal to zero then it's an error
	
	#find out the current player
	lbu $s3, 5($s0) #get the current player
	li $t0, 'B'
	beq $s3, $t0, bottom_verify #if equal to B go to bottom verify, otherwise it's player top
	addi $s0, $s0, 8 #get to the first pocket of top mancala
	li $t0, 2
	mult $s1, $t0 #multiply origin pocket by 2 to accocunt for two bytes per pocket
	mflo $t0 
	add $s0, $s0, $t0 #shift the address to get to the origin pocket
	j eval_verify
	
	bottom_verify:
		lbu $t0, 2($s0) #get number of pockets in each row
		addi $s0, $s0, 8 #get to the first pocket of top mancala
		li $t1, 4
		mult $t0, $t1 #multiply number of pockets by 4 to get to the bottom mancala
		mflo $t0 #store in $t0
		addi $t0, $t0 -2 #get to the first pocket right before the bottom mancala
		add $t1, $s1, $s1 #multiply origin pocket by 2 to get to the increment backwards
		sub $t0, $t0, $t1 #subtract from 0th index pocket after bottom mancala to get to origin pocket
		add $s0, $s0, $t0 #get to origin pocket
		
	eval_verify:
		lbu $t0, 0($s0) #get first digit
		addi $t0, $t0, -48 #convert to binary
		li $t1, 10
		mult $t0, $t1
		mflo $t0 #multipyl first digit by 10
		lbu $t2, 1($s0) #get second digit
		addi $t2, $t2, -48
		add $t0, $t0, $t2 #combine the first and second digit together to get number of stone in the pocket
		beqz $t0, zero_stones_error
		bne $t0, $s2, distance_error #if number of stones is not equal to distance than error
		li $v0, 1 #valid move
		j end_verify_move 
		
	turn_swap:
		li $v0, 2 #set v0 to 2
		lbu $t0, 4($s0) #get moves executued
		addi $t0, $t0, 1 #increment
		sb $t0, 4($s0)
		lbu $t0, 5($s0) #get current player
		li $t1, 'B' #check if B
		beq $t0, $t1, swap_to_T #if current player is B, then change to T
		li $t1, 'B' #otherwise current player is T and you must swap to T
		sb $t1, 5($s0) #change player to B
		j end_verify_move
		swap_to_T: 
			li $t1, 'T'
			sb $t1, 5($s0) #change player to T
			j end_verify_move


	zero_stones_error:
		li $v0, 0
		j end_verify_move
	origin_pocket_error:
		li $v0, -1
		j end_verify_move
	distance_error:
		li $v0, -2
		j end_verify_move
	end_verify_move:
	
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		addi $sp, $sp, 16
		jr  $ra
execute_move:

	addi $sp, $sp, -32
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $ra, 28($sp) #stora ra in the stack

	
	move $s0, $a0 #state
	move $s1, $a1 #origin_pocket then current pocket
	lbu $s3, 2($s0) #get num pockets
	lbu $s4, 5($s0) #get current player
	li $s6, 0 #s6 keeps track of how many times mancala was incremented
	
	#get number of stones in origin pocket
	move $a0, $s0 #state
	move $a1, $s4 #player
	move $a2, $s1 #pass distance to get pocket

	jal get_pocket
	move $s2, $v0 #store the number of stones in origin pocket into $s2

	
	
	#set origin pocket to 0
	move $a0, $s0 
	move $a1, $s4
	move $a2, $s1
	li $a3, 0 #set the origin pocket to 0

	jal set_pocket #set origin pocket to 0
	
	
	move $s5, $s4 #player row starts off same as cur player
	addi $s1, $s1, -1 #subtract 1 from origin pocket, which will now be current pocket
	
	#while num stones > 0
	execute_loop: 
		blez $s2, normal_end_loop #if num stones is less than or equal to 0, then normal ending
		bgez $s1, get_set_pocket #if current pocket less than 0, that means it reached mancala, otherwise 
		
		### BEGINNING OF REACHED A MANCALA
		
		
		#if curplayer and player row not equal, that means you're on other player's mancala
		bne $s4, $s5, other_player_mancala #if curplayer and player row equal, means you're on your own mancala
		
		##BEGINNING OF WHEN YOU REACHED YOUR OWN MANCALA ##
		move $a0, $s0
		move $a1, $s4
		li $t0, 1
		move $a2, $t0 #increment mancala by 1
		
		jal collect_stones #set origin pocket to 0
		addi $s6, $s6, 1 #increment s6 by 1
		
		#check if this was the last stone depositied
		li $t0, 1
		bne $s2, $t0, swap_rows #if this was the last stone deposited, otherwise swap rows
		li $v1, 2 #set v1 to 2
		j update_gamestate #leave loop
		
		
		swap_rows:	
			#swap player rows
			li $t0, 'B'
			beq $s5, $t0, row_swap_T
			li $s5, 'B'
			j cont_own_mancala
			row_swap_T:
				li $s5, 'T'
				
		#continue own mancala stuff
		cont_own_mancala:
			move $s1, $s3 #set current pockets to num pockets, which will be decremented
			j decrement
		
		###### END OWN MANCALA #####
		
		other_player_mancala:
			addi $t0, $s3, -1 #start next cur pocket and end of other row
			move $s1, $t0
			#swap player rows
			li $t0, 'B'
			beq $s5, $t0, row_swap_T2
			li $s5, 'B' #set it to B
			j get_set_pocket
			row_swap_T2:
				li $s5, 'T'
		
		### END OF REACHED A MANCALA ###
		
		#getting stones in pocket and incrementing it
		get_set_pocket:	
			##get pocket
            move $a0, $s0
            move $a1, $s5 #current row 
            move $a2, $s1
            
            jal get_pocket #set origin pocket to 0
            move $t0, $v0 #store stones from the pocket
            
            addi $t0,$t0, 1 #increment number of stones in the pocket by 2
            
            move $a0, $s0 #insert incremented number of stones back into pocket
            move $a1, $s5
            move $a2, $s1
            move $a3, $t0
            jal set_pocket
            move $t0, $v0 #set t0 to value of stones in that pocket
            
            ##check if this is the last stone deposited and was an empty pocket and on own side
            li $t1, 1
            bne $s2,$t1, decrement
            bne $t0, $t1, decrement
            bne $s4, $s5, decrement
            li $v1, 1 #set v0 to true if the conditions are all true
            j update_gamestate
		decrement:
			addi $s1, $s1, -1 #decrement current pocket
			addi $s2, $s2, -1 #decrement numstones
			j execute_loop

	normal_end_loop:
		li $v1, 0
		
	update_gamestate:
		lbu $t0, 4($s0) #retrive moves execute
		addi $t0, $t0, 1
		sb $t0, 4($s0) #increment moves executed
		move $v0, $s6 #number of stones added to mancala in $v0
		
		li $t0, 2 #
		beq $v1, $t0, end_execute_move #if v1 is 2 (meaning it landed on own mancala) then don't swap
		
		#swap current player
		li $t0, 'B'
		beq $s4, $t0, cur_player_swap_to_T
		sb $t0, 5($s0) #set player turn to B
		j end_execute_move
		
		cur_player_swap_to_T:
		li $t0, 'T'
		sb $t0, 5($s0) #set it to T
		
		
	end_execute_move:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s6, 24($sp)
		lw $ra, 28($sp)
		addi $sp, $sp, 32
		jr $ra
steal:
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)

	move $s0, $a0 #state
	move $s1, $a1 #dest_pocket, will be stolen_pcoket later
	lbu $s2, 5($s0) #current player
	li $s4, 0 #stones_added to be returned by this function, set to 0
	#set s3 to opposite player which is the one who is going to steal
	li $t0, 'B'
	beq $s2, $t0, steal_swap_to_T
	li $s3, 'B' #set it to B
	j original_pocket_stones #deposit the 1 stone of the stealplayer's pocket into his mancala
	steal_swap_to_T:
		li $s3, 'T'
	
	original_pocket_stones:
	#deposit the 1 stone of the dest_pocket into the former player's mancala
	
		#set the dest_pocket to 0
		move $a0, $s0 #state
		move $a1, $s3 #this is the steal_player
		move $a2, $s1 #locaation is dest_pocket
		move $a3, $0 #set dest pocket to 0
		jal set_pocket 
	
		#now collect 1 stone into steal_player's mancala
		move $a0, $s0 #state
		move $a1, $s3 #steal player's mancala
		li $a2, 1 #size is 1
		jal collect_stones 
		add $s4, $s4, $v0 #add 1 to stones_added
		
	#get the stones from the current player's pocket and deposit into steal_player's mancala
	cur_player_stones:
		lbu $t0, 2($s0) #get num pockets
		sub $s1, $t0, $s1 #subtract numpockets by dest_pocket
		addi $s1, $s1, -1 #subtracct by 1
		
		move $a0, $s0
		move $a1, $s2 #current player
		move $a2, $s1 #set distance to stolen pocket
		
		jal get_pocket
		#get the stones in stolen pocket
		
		#collect stones from stolen pocket and put in steal_player's mancala
		move $a0, $s0
		move $a1, $s3 #steal player
		move $a2, $v0 #get the stones from get_pocket
		jal collect_stones
		add $s4, $s4, $v0 #add the stones to stones_added
		
		#set stolen pocket to 0
		move $a0, $s0
		move $a1, $s2 #current player
		move $a2, $s1 #stolen pocket
		move $a3, $0 #set the pocket to 0
		jal set_pocket
		
		move $v0, $s4 #set v0 to stones_added

	end_steal:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $ra, 20($sp)
		addi $sp, $sp, 24
		jr $ra
check_row:
	addi $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $ra, 16($sp)
		
	move $s0, $a0 #state
	li $s1, 'B' #start off checking bottom row
	li $s2, 0 #current pocket
	lbu $s3, 2($s0) #num_pockets
	
	li $t9, 0 #i=0
	li $t0, 2 
	
	#while i<2 LOOP BEGINNING
	check_row_outer_loop:
		bge $t9, $t0, both_rows_not_empty #if i>=2 then the rows are not empty
		
		#while current pocket less than num_pockets
		check_row_inner_loop:
			bge $s2, $s3, check_row_swap #if it's greater than or equal then swap the rows
			move $a0, $s0
			move $a1, $s1 #player
			move $a2, $s2 #current pocket
			jal get_pocket
			bgtz $v0, check_row_swap #if stones greater than zero means row
			addi $t0, $s3, -1 #reduce num pockets by 1 because of 0th index
			#if cur pocket = num pockets -1, it means this was last pocket in row and whole row was empty -> game over
			bne $s2, $t0, increment_inner_loop
			j game_over
			increment_inner_loop:
				addi $s2, $s2, 1
				j check_row_inner_loop
		#end of innter loop
		check_row_swap:
			li $s1, 'T' #since only two loops, it has to be T
			addi $t9, $t9, 1 #increment i
			li $s2, 0
			j check_row_outer_loop
		
	both_rows_not_empty:
		li $v0, 0 #set v0 to 0
		j compare_mancalas
	
	game_over:
		li $t0, 'B'
		beq $s1, $t0, game_over_swap
		move $s1, $t0 #set s1 to B
		j add_up_opposite_row
		game_over_swap:
			li $s1, 'T'
			
		add_up_opposite_row:
			li $s2, 0 #start curpocket at 0
			#while curpocket less than numpocket, add up all the stones, while setting them to 0
			add_up_loop:
				bge $s2, $s3, end_game_over
				move $a0, $s0 
				move $a1, $s1
				move $a2, $s2
				jal get_pocket
				move $a2,$v0 #move stones from get pocket to a2
				jal collect_stones
				move $a2, $s2
				li $a3, 0
				jal set_pocket #set that pocket to 0
				addi $s2, $s2, 1 #increment cur pocket
				j add_up_loop
		
	end_game_over:
		li $t0, 'D' 
		sb $t0, 5($s0) #set player turn to 'D' when game done
		li $v0, 1
		
	compare_mancalas:
		lbu $t0, 0($s0) #bottom mancala
		lbu $t1, 1($s0) #top mancala
		li $v1, 0
		beq $t0, $t1, end_check_row #f equal then v1 =1
		bgt $t1, $t0, top_greater #if top greater, then go to top greater
		li $v1, 1  #otherwise bottom greater
		j end_check_row
		top_greater:
			li $v1, 2
	end_check_row:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $ra, 16($sp)
		addi $sp, $sp, 20
		jr $ra
load_moves:
	addi $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	
	move $s0, $a0 #address to moves
	move $s1, $a1 #file name, will become file descriptor
	li $s2, 0 #total number of moves to be returned
	
	#opening file
	li $v0, 13
	move $a0, $s1 #move fiilename into a0
	li $a1, 0 #set flag to read-only
	li $a2, 0 #set mode to 0, ignore it
	syscall 
	bltz $v0, load_moves_file_error #if v0 is negative, than go to filerror and end load game, otherwise continuue to readfile
	move $s1, $v0 #store the file descriptor into $s1

	#reading file
	addi $sp, $sp, -4 #create memory buffer to hold each character read when parsing file

	#first line (number of columns
	li $s3, 0 #number of columns (same as size of the row)
	li $v0, 14 #syscall for reading file
	move $a0, $s1 #move file descriptor into a0
	move $a1, $sp #stack will hold the memory buffer for each character
	li $a2, 1 #only store one character at a time
	
	load_moves_firstlineloop:
		li $v0, 14
		syscall #read 1 character from the file
	
		lbu $t0, 0($sp) #retrive the character read from the file
		li $t1, '\n' #check if equal to \n
		li $t2, '\r' #checkk if equal to \r
		beq $t0, $t1, endloadmovesfirstline
		beq $t0, $t2, endloadmovesfirstbackrn
		addi $t0, $t0, -48 #convert from ascii to binary
		li $t3, 10
		mult $s3, $t3 #multiple number of columns 
		mflo $t4 #product
		add $s3, $t4, $t0 #add to total number of columns

		j load_moves_firstlineloop
		
	endloadmovesfirstbackrn:
		li $v0, 14
		syscall #skip once
	endloadmovesfirstline:
	
	#second line (number of columns
	li $s4, 0 #number of columns (same as size of the row)
	li $v0, 14 #syscall for reading file
	move $a0, $s1 #move file descriptor into a0
	move $a1, $sp #stack will hold the memory buffer for each character
	li $a2, 1 #only store one character at a time
	
	load_moves_secondlineloop:
		li $v0, 14
		syscall #read 1 character from the file
	
		lbu $t0, 0($sp) #retrive the character read from the file
		li $t1, '\n' #check if equal to \n
		li $t2, '\r' #checkk if equal to \r
		beq $t0, $t1, endloadmovessecondline
		beq $t0, $t2, endloadmovessecondbackrn
		addi $t0, $t0, -48 #convert from ascii to binary
		li $t3, 10
		mult $s4, $t3 #multiple number of columns 
		mflo $t4 #product
		add $s4, $t4, $t0 #add to total number of columns

		j load_moves_secondlineloop
		
	endloadmovessecondbackrn:
		li $v0, 14
		syscall #skip once
	endloadmovessecondline:
		
	li $t8, 0 #i
	li $t9, 0 #j
	
	lm_outer_loop:
		beq $t8, $s4, end_moves_loop #if i is equal to number of rows then end the loop, otherwise keep going
		li $t9, 0 #j
		lm_inner_loop:
			beq $t9, $s3, increment_lm_outer #if j is equal to number of colums, then end the inner loop
			
			li $v0, 14
			syscall
			
			lbu $t0, 0($sp) #retrive the character read from the file
            #li $t1, '\n' #check if equal to \n
            #li $t2, '\r' #checkk if equal to \r
            #beq $t0, $t1, botrow
            #beq $t0, $t2, endtoprowrn
            
            #check if first character greater than '4'
            li $t2, 52
            bgt $t0, $t2, invalid_char_first #if character greater than 52
            li $t2, 48
            blt $t0, $t2, invalid_char #if character less than 48, then invalid char
            
           
            addi $t0, $t0, -48 #convert to binary
            li $t1, 10
            mult $t0, $t1
            mflo $t1 #multiply first digit by 10 and store in t1, 
            
            
            li $v0, 14
            syscall
            
            lbu $t0, 0($sp) #retrive the character read from the file
			#check if first character greater than '4'
            li $t2, 56
            bgt $t0, $t2, invalid_char #if character greater than 52
            li $t2, 48
            blt $t0, $t2, invalid_char #if character less than 48, then invalid char
			
            addi $t0, $t0, -48 #convert second digit character to binary
            add $t1, $t1, $t0 #add second digit to total
            
            sb $t1, 0($s0) #store the move
            
			j increment_lm_inner_loop
			
			#if the invalid char was first character
			invalid_char_first:
				li $v0, 14
				syscall
			invalid_char:
            	li $t2, 'X'
            	sb $t2, 0($s0) #store X for invalid character
            
            increment_lm_inner_loop:
            	addi $s0, $s0, 1 #shift gameboard by 1 
            	addi $s2, $s2, 1 #increment number of moves
            	addi $t9, $t9, 1 #increment j
            	j lm_inner_loop
	
		increment_lm_outer:
			addi $t0, $s4, -1 #check if this was the last row
			bge $t8, $t0, end_moves_loop #if it is then end loop, otherwise do the following
			li $t0, 99
			sb $t0, 0($s0) #store 99 in moves
			addi $s2, $s2, 1 #increment number of moves
			addi $s0, $s0, 1 #increment pointer
			addi $t8, $t8, 1 #increment i
			j lm_outer_loop
			
	end_moves_loop:
		
		#end reading file
		addi $sp, $sp, 4 #readdjust stack pointer
	
		li $v0, 16 #syscall close file
		move $a0, $s1 #file descriptor into s2
		syscall
		
		move $v0, $s2 #store num of moves
		j end_load_moves


	load_moves_file_error:
		li $v0, -1
		
	end_load_moves:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		addi $sp, $sp, 20
		jr $ra
		
play_game:
	move $fp, $sp #store the frame pointer
	addi $sp, $sp, -28
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $ra, 24($sp)
	
	
	move $s0, $a0 #moves filename, can be used again afterwards
	move $s1, $a1 #board filename, can be used again afterwards
	move $s2, $a2 #game state
	move $s3, $a3, #moves array
	lw $s4, 0($fp) #num moves to execute
	li $s5, 0 #number of valid moves executed
	
	move $a0, $s2 #store gamestate in $a0
	move $a1, $s1 #store filename in $a1
	jal load_game #load the game
	blez $v0, play_game_file_error #if v0 less than or equal to 0 that means there is a file error, otherwise continue
	
	#check if initial gameboard is over
	move $a0, $s2 #game state
	jal check_row #check if game over and adjust gameboard
	bgtz $v0, play_game_over #if v0 greater than 0 that means game is over, otherwise continue
	
	move $a0, $s3 #mvoes arra
	move $a1, $s0 #moves filename
	jal load_moves #load moves
	bltz $v0, play_game_file_error #if v0 less than 0 then there's file error, otherwise continue
	move $s0, $v0 #store number of moves in moves array in $s0
	
	num_moves_to_execute_loop:
		#while num moves to execute > 0
		blez $s4, game_not_finished #if it's less than or equal to 0 then to go game not finished
		
		
		#if number of moves left in moves_array > _0
		blez $s0, game_not_finished #if less than or equal to ten go to game not finished
		lbu $t0, 0($s3) #get the move from the move array
		
		move $a0, $s2 #gamestate
		li $t1, 99
		beq $t0, $t1, force_swap_verify_move #if move is equal to 99 then force swap
		bltz $t0, next_move #is less than 0 skip move
		li $t1, 48
		bgt $t0, $t1, next_move #if greater than 48, skip move
		lbu $a1, 5($s2) #get the current player
		move $a2, $t0 #store the pocket
		jal get_pocket
		lbu $a1, 0($s3) #origin pocket
		move $a2, $v0 #distance is num stones from get pocket
		move $s1, $v0 #store the original number of stones in the pocket in $s1
		j play_game_verify_move
		force_swap_verify_move:
			addi $s5, $s5, 1 #increemnt number of valid moves executed
			li $a1, 0
			move $a2, $t0 #set distance to 99
		
		play_game_verify_move:
			move $a0, $s2 #state
			jal verify_move #
			blez $v0, next_move #if verify move returns less than or equal to 0 then skip_move
			li $t0, 2
			beq $v0, $t0, valid_move_decrement #if verify move returns 2 that means it was a force swap so don't have to executem ov
			#otherwise that means verify move returned 1 which was valid move
			addi $s5, $s5, 1 #increment number of valid moves executed
			move $a0, $s2
			lbu $a1, 0($s3) #get the move from the move array
			jal execute_move #do execute move
			li $t0, 1
			bne $t0, $v1, play_game_check_row #if v1 is not 1 (which means either 0 or 2) then just do check row
			#otherwise it's 1 meaning have to do steal
			
			#algorithm for calculating the destination pocket for steal
			lbu $t0, 0($s3) #origin pocket 
			lbu $t1, 2($s2) #get num pockets
			add $t2, $s1, $t1
			addi $t2, $t2, -1
			sub $t2, $t2, $t0
			add  $t3, $t1, $t1 #multiply num pockets
			addi $t3, $t3, 1 
			div $t2, $t3
			mfhi $t2
			sub $t2, $t1, $t2
			addi $t2, $t2, -1
			
			
			move $a0, $s2
			move $a1, $t2 #store the desgination pocket
			jal steal 	
				
			
		play_game_check_row:
			move $a0, $s2
			jal check_row
			bgtz $v0, play_game_over #if greater than 0 than game over
			
		#decrement num moves to execute 
		valid_move_decrement:
			addi $s4, $s4, -1 #decrement num moves left to execute
		next_move:
			addi $s0, $s0, -1 #decreemtn num movess left in moves array
			addi $s3, $s3, 1 #increment address of moves array to get next move
			j num_moves_to_execute_loop
			
			
	
	game_not_finished:
		li $v0, 0
		j play_game_valid_moves_ex
	
	play_game_over:
		move $v0, $v1 #game result
	
	play_game_valid_moves_ex:
		move $v1, $s5 #store num validmovs executed in v1
		j end_play_game
	
	play_game_file_error:
		li $v0, -1
		li $v1, -1
	
	end_play_game:	
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $ra, 24($sp)
		addi $sp, $sp, 28
		jr  $ra
print_board:
	move $t9, $a0 #state 
	move $t8, $a0 #another state address
	#print top mancala
	lbu $a0, 6($t9) #first character of top mancala
	li $v0, 11
	syscall
	lbu $a0, 7($t9)
	li $v0, 11
	syscall
	li $a0, '\n'
	li $v0, 11
	syscall
	
	#print bottom mancala
	lbu $t7, 2($t9) #num pockets
	li $t0, 4
	mult $t7, $t0 #multipy by 4
	mflo $t6 #numpockets *4
	addi $t9, $t9, 8 #go to beginning of pockets
	add $t9, $t9, $t6
	lbu $a0, 0($t9)
	li $v0, 11
	syscall

	lbu $a0, 1($t9)
	li $v0, 11
	syscall
	
	li $a0, '\n'
	li $v0, 11
	syscall
	
	#print top row
	li $t0, 0
	sub $t9, $t9, $t6 #go back to beginning of pockets
	
	print_first_loop:
		beq $t0, $t7, end_print_first #while less than num pockets
		lbu $a0, 0($t9) #get first char
		li $v0, 11
		syscall
		lbu $a0, 1($t9)
		li $v0, 11
		syscall
		addi $t0, $t0, 1
		addi $t9, $t9, 2
		j print_first_loop
	
	end_print_first:
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $t0, 0
	
	print_second_loop:
		beq $t0, $t7, end_print_second #while less than num pockets
		lbu $a0, 0($t9) #get first char
		li $v0, 11
		syscall
		lbu $a0, 1($t9)
		li $v0, 11
		syscall
		addi $t0, $t0, 1
		addi $t9, $t9, 2
		j print_second_loop
		
	end_print_second:
		li $a0, '\n'
		li $v0, 11
		syscall
	
	end_print_board:	
		jr $ra
write_board:
	move $s0, $a0 #state
	lbu $s1, 2($s0) #num pockets
	
	addi $sp, $sp, -10 #subtract by 10 to make space for output.txt
	li $t0, 'o'
	sb $t0, 0($sp)
	li $t0, 'u'
	sb $t0, 1($sp)
	li $t0, 't'
	sb $t0, 2($sp)
	li $t0, 'p'
	sb $t0, 3($sp)
	li $t0, 'u'
	sb $t0, 4($sp)
	li $t0, 't'
	sb $t0, 5($sp)
	li $t0, '.'
	sb $t0, 6($sp)
	li $t0, 't'
	sb $t0, 7($sp)
	li $t0, 'x'
	sb $t0, 8($sp)
	li $t0, 't'
	sb $t0, 9($sp)
	
	move $a0, $sp #output.txt
	li $a1, 1
	li $a2, 0
	li $v0, 13
	syscall
	bltz $v0, write_open_file_error
	move $s2, $v0 #file descriptor
	addi $sp, $sp, 10 #restore stack
	
	move $a0, $s2 #file descriptor
	addi $sp, $sp, -4 #memory buffer
	move $a1, $sp #memoery buffer
	li $a2, 1 #1 byte at a time
	
	#top mancala
	lbu $t0, 6($s0) #first character of top mancala
	sb $t0, 0($sp)
	li $v0, 15
	syscall
	bltz $v0, write_to_file_error
	lbu $t0, 7($s0)
	sb $t0, 0($sp)
	li $v0, 15
	syscall
	bltz $v0, write_to_file_error
	li $t0, '\n' 
	sb $t0, 0($sp)
	li $v0, 15
	syscall
	bltz $v0, write_to_file_error

	#bottom mancala
	lbu $t7, 2($s0) #num pockets
	li $t0, 4
	mult $t7, $t0 #multipy by 4
	mflo $t6 #numpockets *4
	addi $s0, $s0, 8 #go to beginning of pockets
	add $s0, $s0, $t6
	lbu $t0, 0($s0)
	sb $t0, 0($sp)
	li $v0, 15
	syscall
	bltz $v0, write_to_file_error

	lbu $t0, 1($s0)
	sb $t0, 0($sp)
	li $v0, 15
	syscall
	bltz $v0, write_to_file_error
	
	li $t0, '\n'
	sb $t0, 0($sp)
	li $v0, 15
	syscall
	bltz $v0, write_to_file_error
	#end bottom mancala
	
	
	#print top row
	li $t5, 0
	sub $s0, $s0, $t6 #go back to beginning of pockets
	
	print_write_first_loop:
		beq $t5, $t7, end_print_write_first #while less than num pockets
		lbu $t0, 0($s0) #get first char
		sb $t0, 0($sp)
		li $v0, 15
		syscall
		bltz $v0, write_to_file_error
		lbu $t0, 1($s0)
		sb $t0, 0($sp)
		li $v0, 15
		syscall
		bltz $v0, write_to_file_error
		addi $t5, $t5, 1
		addi $s0, $s0, 2
		j print_write_first_loop
	
	end_print_write_first:
	li $t0, '\n'
	sb $t0, 0($sp)
	li $v0, 15
	syscall
	bltz $v0, write_to_file_error
	
	li $t5, 0
	
	print_write_second_loop:
		beq $t5, $t7, end_print_write_second #while less than num pockets
		lbu $t0, 0($s0) #get first char
		sb $t0, 0($sp)
		li $v0, 15
		syscall
		bltz $v0, write_to_file_error
		lbu $t0, 1($s0)
		sb $t0, 0($sp)
		li $v0, 15
		syscall
		bltz $v0, write_to_file_error
		addi $t5, $t5, 1
		addi $s0, $s0, 2
		j print_write_second_loop
		
	end_print_write_second:
		li $t0, '\n'
		sb $t0, 0($sp)
		li $v0, 15
		syscall
		bltz $v0, write_to_file_error
	
	j close_write_file_valid
	
	write_to_file_error:
		li $v0, 16
		move $a0, $s2
		syscall
		li $v0, -1
		j end_write_board
		
	close_write_file_valid:
		li $v0, 16
		move $a0, $s2
		syscall
		li $v0, 1
	j end_write_board
	
	write_open_file_error:
		li $v0, -1
	end_write_board:	
		jr $ra
	
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
