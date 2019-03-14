# Lab 4: Memory, Scheduling, and Decryption

## Overview

[![Image from Gyazo](https://i.gyazo.com/3a5cb2fa9388383a5479883fe7e37fde.png)](https://gyazo.com/3a5cb2fa9388383a5479883fe7e37fde)

Use i and j as 8 bytes to save mod
[![Image from Gyazo](https://i.gyazo.com/37200c3c5c29fbb3ae1925e2e5261fba.png)](https://gyazo.com/37200c3c5c29fbb3ae1925e2e5261fba)

### FSM design

[![Image from Gyazo](https://i.gyazo.com/82ef7f958bfd5b7a95f36125775c2362.png)](https://gyazo.com/82ef7f958bfd5b7a95f36125775c2362)

### Algorithm

```v
// Input:
// secret_key [] : array of bytes that represent the secret key. In our implementation,
// we will assume a key of 24 bits, meaning this array is 3 bytes long
// encrypted_input []: array of bytes that represent the encrypted message. In our
// implementation, we will assume the input message is 32 bytes
// Output:
// decrypted _output []: array of bytes that represent the decrypted result. This will
// always be the same length as encrypted_input [].

// Task 1
initialize s array. You will build this in Task 1
for i = 0 to 255 {
    s[i] = i;
}
// shuffle the array based on the secret key. You will build this in Task 2
// Task 2a
j = 0
for i = 0 to 255 {
    // y: secret_key[i] is 1 byte
    j = (j + s[i] + secret_key[i mod keylength] ) //keylength is 3 in our impl.
    swap values of s[i] and s[j]
}
// Task 2b
// compute one byte per character in the encrypted message. You will build this in Task 2
i = 0, j=0
for k = 0 to message_length-1 { // message_length is 32 in our implementation
    i = i+1
    j = j+s[i]
    swap values of s[i] and s[j]
    f = s[ (s[i]+s[j]) ]
    decrypted_output[k] = f xor encrypted_input[k] // 8 bit wide XOR function
}

// Task 3: brute force solving. 
key_max = FF_FFFF; // 24 bits, 6 bytes
invalid = 0;
key_valid;
for key = 0 to key_max{
    for i = 0 to 255 {
        s[i] = i;
    }
    j = 0
    for i = 0 to 255 {
        j = (j + s[i] + key[i mod keylength] ) //keylength is 3 in our impl.
        swap values of s[i] and s[j]
    }
    i = 0, j=0
    for k = 0 to message_length-1 { // message_length is 32 in our implementation
        i = i+1
        j = j+s[i]
        swap values of s[i] and s[j]
        f = s[ (s[i]+s[j]) ]
        decrypted_output[k] = f xor encrypted_input[k] // 8 bit wide XOR function
        
        // added for the new task
        if not (decrypted_output[k] > 97 && decrypted_output[k] < 122 )|| decrypted_output[k] == 32{
            invalid = 1;
            break;
        }else{
            decrypted_output[k] = f xor encrypted_input[k] // 8 bit wide XOR function
        }
    }
    // after message is finished, if still valid we return the key. 
    if invalid{
        key_valid = key;
        break;
    }
}
```

### Solution review

| Action |Result   | Comments |
|---|---|---|
|   |   | |
|   |   | |
|   |   | |


## Task 1: yesterday once more

Build a flash memory loader. 
> secret keys are 3 bytes

### Valid Ready 
[sourced](https://www.cerc.utexas.edu/~deronliu/vlsi1/lab3/2014_fall_VLSI_I/LAB3_Website/handshake/handshake.pdf)

[![Image from Gyazo](https://i.gyazo.com/de813b5d46dacc5781d0d568df838dfa.png)](https://gyazo.com/de813b5d46dacc5781d0d568df838dfa)

[![Image from Gyazo](https://i.gyazo.com/c747f75f76ca076a0b4c06a26cfedfee.png)](https://gyazo.com/c747f75f76ca076a0b4c06a26cfedfee)

The beauty of it is: instead of using valid to indicate that some data is ready, we can just say that the module is valid, it's almost like the master turn on the slave, and ready is an respond from the slave to tell master that the module is ready to be run again. That means whenever the program is running, it's ready will be deasserted and the master can wait on ready signal to determine the next step. 

## Task 2: everyday I am shuffling

build a decryption core.

> The secret key is set using the slider switches. Note that the secret key should be 24 bits long, but you only have 18 slider switches on the DE2 board (and only 10 on the DE1-SoC board). For this task only (not Task 3 , you can hardwire the upper 14 bits of the secret key to 0.


## Task 3: nothing really matters

cracking the message use the decryption core

|Message   |Result | Solution    | Comment |
|---|---|---|---|
| 1  |this course is my favorite   | | [![Image from Gyazo](https://i.gyazo.com/634c1422cee0c2757441b3bde5bd3b0a.png)](https://gyazo.com/634c1422cee0c2757441b3bde5bd3b0a)|
| 2  | congratation on task 2   | | |
| 3  | ubc elec and comp engineering   | | [![Image from Gyazo](https://i.gyazo.com/117fcd7700ff7d0721f0a22a37a4d4fb.png)](https://gyazo.com/117fcd7700ff7d0721f0a22a37a4d4fb)|
|4 | rc4 is not very secure ||[![Image from Gyazo](https://i.gyazo.com/378d4cafb808f7742b246777e47d285e.png)](https://gyazo.com/378d4cafb808f7742b246777e47d285e) | 
|5 | you have solid vhdl skills | | [![Image from Gyazo](https://i.gyazo.com/d86fe04622db00981204001a8e2579a4.png)](https://gyazo.com/d86fe04622db00981204001a8e2579a4)|
|6 |this one is tricky with zero key |  | [![Image from Gyazo](https://i.gyazo.com/5ca1e9cdb45c1a50d7335c535df6aa75.png)](https://gyazo.com/5ca1e9cdb45c1a50d7335c535df6aa75)| 
|7 | vhdl ninjia saved the day | | [![Image from Gyazo](https://i.gyazo.com/9ab994ffe5a59cd36e178ba12a58d155.png)](https://gyazo.com/9ab994ffe5a59cd36e178ba12a58d155)|
| 8 |good luck on your exam| |[![Image from Gyazo](https://i.gyazo.com/2fc1912b8605fb715c7958c6cdd2d500.png)](https://gyazo.com/2fc1912b8605fb715c7958c6cdd2d500)| 

## Bonus

parallel debugging. Yeah, no... I have got midterms. 


## Debug Log

|Problem|file,lines|solution| comments|
|---|---|---|---|
|task 2b, first message is ):is.... | change the initial i.  |didnt solve it | |
| | changed new_k and so on | break the code for some reasons | Still didn't solve it|
| | | | |

## Total hours

15
