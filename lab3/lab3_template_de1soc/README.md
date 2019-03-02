Lab 3
==
# Instruction
Read the Picoblaze activity
## Task 1
> toggle LEDR[0] every second

### Notes
currently, the LED control is 
```.text
;
;**************************************************************************************
; Interrupt Service Routine (ISR)
;**************************************************************************************
;
; The interrupt is used purely to provide a 1 second heart beat binary counter pattern
; on the 8 LEDs.
ISR: STORE s0, ISR_preserve_s0           ;preserve register
    FETCH s0, LED_pattern               ;read current counter value
    ADD s0, 01                          ;increment counter
    STORE s0, LED_pattern               ;store new counter value
    OUTPUT s0, LED_port                 ;display counter value on LEDs
    FETCH s0, ISR_preserve_s0           ;restore register
    RETURNI ENABLE
```
This block will store the LED counter value and display the port value to LED_port. If we want to 



## Task 2
Go to the [SLIDE](https://drive.google.com/file/d/0By2-dmbuBCMTTXJoazZ1VHA3RkU/view)

[![Image from Gyazo](https://i.gyazo.com/841ca1fb3565fa0aeee9de2ab6d83c2c.png)](https://gyazo.com/841ca1fb3565fa0aeee9de2ab6d83c2c)

[![Image from Gyazo](https://i.gyazo.com/a0b46d4a4ddf8af9243e8d836d89609c.png)](https://gyazo.com/a0b46d4a4ddf8af9243e8d836d89609c)

[![Image from Gyazo](https://i.gyazo.com/d08323bf514577ff4b99af24c8dc4c7a.png)](https://gyazo.com/d08323bf514577ff4b99af24c8dc4c7a)
> the relations between in_port, out_port and port_id

[![Image from Gyazo](https://i.gyazo.com/53403ad860d113757d6c8d4c54eec3c4.png)](https://gyazo.com/53403ad860d113757d6c8d4c54eec3c4)

[![Image from Gyazo](https://i.gyazo.com/b0699ba2c12414d1281cba27e6a5a1b4.png)](https://gyazo.com/b0699ba2c12414d1281cba27e6a5a1b4)

[![Image from Gyazo](https://i.gyazo.com/0425bf1b6aa7bbbe0ea3e48ae5213d52.png)](https://gyazo.com/0425bf1b6aa7bbbe0ea3e48ae5213d52)

[![Image from Gyazo](https://i.gyazo.com/c0b97ee53bc3b2a32d2545b8a9aa1ede.png)](https://gyazo.com/c0b97ee53bc3b2a32d2545b8a9aa1ede)

> The interrupt routine will be activated each time a new
value is read from the Flash memory. Each value is a
sound sample, each sample has its "intensity", or
absolute value. The interrupt will accumulate (=sum) 256
of these absolute values (a value each time the
interrupt is called), and the interrupt routine will
divide this sum by 256 every 256-th interrupt. This is
essentially an averaging filter operation, i.e. we are
averaging every 256 absolute values of samples. Division
by 256, because that is the power of 2, can be done very
simply by discarding log2(256) bits from the sum.

### Notes
1. Change the interrupt timer to based on flash memory input
   1. [delay timer](../pracPICO_task2.psm#398)
   2. Change the interrupt signal in [interrupt_ack](simple_picoblaze.v#101)
3. get the sound sample from somewhere
   1. We will feed the input data [simple_picoblaze](./simple_ipod_solution.v#L293)
   2. every cycle the program will pick it up.
4. **Working on the assembly code logic**
   1. save the value to a register (the value is absolute)
   2. At the moment, saving it to the register. 
   3. It's essentially two loops. 
   4. divide the sum by 256, or log2(256)
#### pesudo code
> 
```python
if i < 256: // i is s0
    input_data = data_in // input_data is s3
    sum += input_data // sum is s1 
    if carry:
        s2 ++
    i ++
else
    output = sum / 256; 
    i = 0
```
```text
STORE s0, ISR_preserve_s0
STORE s1, ISR_preserve_s1
STORE s2, ISR_preserve_s2
STORE s3, ISR_preserve_s3 ; get a register for storing data
>FETCH s0, ISR_preserve_s0
FETCH s1, ISR_preserve_s1
FETCH s2, ISR_preserve_s2
FETCH s3, ISR_preserve_s3
```

The reason for this is cause divided by 256 = right shift 8 bits, which in the case
of using 2 8 bits register is just ignore the "sum" one and take the "avg" one as the output.

5. **Set the port for LED_0 seperately** \
We want to display the 1 blinking LED at the same time as the other 8, therefore we will use another port, LED_0_port, which has port_id of 01 -> 00000001 or port_id[0]. 
6. **Toggle the interrupt signal** \
   1. The interrupt signal was triggered every 1 HZ
   2. **Updated** we wil not use clk interrupt anymore, since the clk are not perfectly synced anyway. Use a data change sync trigger is much more relible. 
``` v
// Note that because we are using clock enable we DO NOT need to synchronize with clk

  always @ (posedge clk)
  begin
      //--divide 50MHz by 50,000,000 to form 1Hz pulses
      if (int_count==(clk_freq_in_hz-1)) //clock enable
		begin
         int_count <= 0;
         event_1hz <= 1;
      end else
		begin
         int_count <= int_count + 1;
         event_1hz <= 0;
      end
 end

 always @ (posedge clk or posedge interrupt_ack)  //FF with clock "clk" and reset "interrupt_ack"
 begin
      if (interrupt_ack) //if we get reset, reset interrupt in order to wait for next clock.
            interrupt <= 0;
      else
		begin 
		      if (event_1hz)   //clock enable
      		      interrupt <= 1;
          		else
		            interrupt <= interrupt;
      end
 end
```
7. **make the input_data absolute from simple_ipod** \
It's a simple change to make sure signed data from audio is changed to abolute. Use a if > 0 else check. 
8. **Integration check**
   1. Initialized all the ports in [cold_start](../pracPICO_task2.psm#175)
   2. The main program will flip (XOR) LED_pattern (which is only used for LED_0), then output it. 
   3. Interrupt is triggered by the [interrupt_trigger_routing](./simple_picoblaze.v#79) It will trigger interrupt every "50M count", 
      1. **Option 2**: Manual use a register to check if the audio_data was changed. If it is, trigger the interrupt to update the message. 
   4. 
9.  
                    

## Task 3
> Every time we do this division by 256, the PicoBlaze
interrupt routine should output the average value to
the LEDG[7:0]. (If you have a DE1-SoC, use LEDR[9:2])
Note that you have to "fill" the LEDs from left to
right, i.e. make the LEDs light up to the value of the
most significant binary digit of the average. For
example, if the average of the absolute values is, in
binary, 00101101, then since the highest bit that is "1"
is bit #5 (where bit #0 is the LSB), the LEDs should be
XXXXXX00 (where "X" is on and "0" is off). As always,
look at what the solution does if you have any doubts.

## Task 4
> After each averaged value is output to the appropriate
LEDs, the accumulator is set to 0 to prepare to average
the next 256 values, and so on.

## Comment
