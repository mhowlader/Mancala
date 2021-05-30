# Mancala

Mancala is a two-player turn-based board game in which there are two rows of pockets filled with stones for each player. The objective is to capture as many stones as one can into their own mancala before the game is over. A brief overview of the rules is explained in this [video](https://www.youtube.com/watch?v=OX7rj93m6o8&t=37s). 

## Instructions

1. Clone the repository.
2. Open the MarsSpring2021.jar file. 
3. In Mars, open the play_game_test.asm file. 
4. Type the desired moves filename after "moves_filename: .asciiz" in line 2.
5. Type the desired board filename after "board_filename: .asciiz" in line 3.
6. Assemble the file.
7. Run the program. 

Format of the output:

1st line: 0 if game not over or tie, 1 if player 1 won, 2 if player 2 won

2nd line: # of valid moves exectuted.

3rd line: Player 2's Mancala

4th line: Player 1's Mancala

5th line: Player 2's Pockets

6th line: Player 1's Pockets
