Lab 3
==
# Instruction
Read the Picoblaze activity
## Task 1
toggle LEDR[0] every second

## Task 2
The interrupt routine will be activated each time a new
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

## Comments