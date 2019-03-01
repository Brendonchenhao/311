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

Go to the [SLIDE](https://drive.google.com/file/d/0By2-dmbuBCMTTXJoazZ1VHA3RkU/view)

[![Image from Gyazo](https://i.gyazo.com/841ca1fb3565fa0aeee9de2ab6d83c2c.png)](https://gyazo.com/841ca1fb3565fa0aeee9de2ab6d83c2c)

[![Image from Gyazo](https://i.gyazo.com/a0b46d4a4ddf8af9243e8d836d89609c.png)](https://gyazo.com/a0b46d4a4ddf8af9243e8d836d89609c)

[![Image from Gyazo](https://i.gyazo.com/d08323bf514577ff4b99af24c8dc4c7a.png)](https://gyazo.com/d08323bf514577ff4b99af24c8dc4c7a)


[![Image from Gyazo](https://i.gyazo.com/53403ad860d113757d6c8d4c54eec3c4.png)](https://gyazo.com/53403ad860d113757d6c8d4c54eec3c4)

[![Image from Gyazo](https://i.gyazo.com/b0699ba2c12414d1281cba27e6a5a1b4.png)](https://gyazo.com/b0699ba2c12414d1281cba27e6a5a1b4)

[![Image from Gyazo](https://i.gyazo.com/0425bf1b6aa7bbbe0ea3e48ae5213d52.png)](https://gyazo.com/0425bf1b6aa7bbbe0ea3e48ae5213d52)

### Notes
1. get the sound sample from somewhere
2. save the value to a register (the value is absolute)
3. divide the sum by 256, or log2(256)

## Task 3
Every time we do this division by 256, the PicoBlaze
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
After each averaged value is output to the appropriate
LEDs, the accumulator is set to 0 to prepare to average
the next 256 values, and so on.

## Comment
