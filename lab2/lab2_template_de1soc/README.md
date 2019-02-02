Lab 2: Simple iPod
===
# Part 1: program the flash memory
~~Done, need to test the FPGA solution~~
## The behavior of the program:
1. LCD updated with **someting** 
2. // TODO: figure out that something
3. Action table
   
|action   |Functionality   | Comments | Implementation |
|---|---|---|---|
| Keyboard E  | Start the music  | need to press this before starting music | as the start or enable of the fsm, or get the address start updating|
| Keyboard D | Stop the music | I think it restarts? | stop the address updating|
| KEY0 |slow up  music | |change the speed variable|
| KEY1 |speed up the music|| change the speed variable|
| KEY2 |reset the speed | |reset the speed|
| Keyboard B | Play the music backwards|| change the direction of the address updating to negative|
| Keyboard F | Play the music forward|| change the direction of the address updating to positive|
| Keyboard R | Restart the music | start from the beginning | set the address to 0|

4. Interface
   - [speed count](./simple_ipod_solution.v#L555) (change the sameple space)
   - [read keyboard input](./simple_ipod_solution.v#L312)
   - [Clock_divider](./simple_ipod_solution.v#L359)
   - [audio_data change](./simple_ipod_solution.v#L257)
   - 
5. 


# Part 2: Look at the solution file to understand what to be done

# Part 3: Just do it
Open the file "simple_ipod_solution.v". Look inside this
file Write_Kbd_To_Scope_LCD modules, Kbd_ctrl and key2ascii.
These modules are already written and work well, no need to
change them. However, I recommend that you enter the modules
to see how they work. Overall, Kbd_ctrl manages the
interface with the keyboard, and outputs the variable
"kbd_scan_code", which is converted by the module key2ascii
to an ASCII code (which is the same code of the parameters
"character_A", "character_B" etc., that you already know).
This ASCII code is used by the module Write_Kbd_To_Scope_LCD
to write the letters in the LCD. The module
Write_Kbd_To_Scope_LCD is interesting because it contains an
FSM - try to understand how it works. To understand the interface with the keyboard, you can look at the DE1 manual. 

# Part 4: Start to write code, after designing

## 1. interface with the flash memory
create a 
## 2. design a FSM

### 2.1. FSM for reading flash

### 2.2 FSM for control. 


