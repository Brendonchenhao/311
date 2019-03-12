# Lab 4: Memory, Scheduling, and Decryption

## Overview

[![Image from Gyazo](https://i.gyazo.com/3a5cb2fa9388383a5479883fe7e37fde.png)](https://gyazo.com/3a5cb2fa9388383a5479883fe7e37fde)

[![Image from Gyazo](https://i.gyazo.com/37200c3c5c29fbb3ae1925e2e5261fba.png)](https://gyazo.com/37200c3c5c29fbb3ae1925e2e5261fba)

### Algorithm

```text     
// Input:
// secret_key [] : array of bytes that represent the secret key. In our implementation,
// we will assume a key of 24 bits, meaning this array is 3 bytes long
// encrypted_input []: array of bytes that represent the encrypted message. In our
// implementation, we will assume the input message is 32 bytes
// Output:
// decrypted _output []: array of bytes that represent the decrypted result. This will
// always be the same length as encrypted_input [].
// initialize s array. You will build this in Task 1
for i = 0 to 255 {
s[i] = i;
}
// shuffle the array based on the secret key. You will build this in Task 2
j = 0
for i = 0 to 255 {
j = (j + s[i] + secret_key[i mod keylength] ) mod 256 //keylength is 3 in our impl.
swap values of s[i] and s[j]
}
// compute one byte per character in the encrypted message. You will build this in Task 2
i = 0, j=0
for k = 0 to message_length-1 { // message_length is 32 in our implementation
i = (i+1) mod 256
j = (j+s[i]) mod 256
swap values of s[i] and s[j]
f = s[ (s[i]+s[j]) mod 256 ]
decrypted_output[k] = f xor encrypted_input[k] // 8 bit wide XOR function
}
```

## Task 1: yesterday once more

Build a flash memory loader. 


## Task 2: everyday I am shuffling

build a decryption core.

## Task 3: nothing really matters

cracking the message use the decryption core

## Bonus

parallel debugging. 

## Debug Log

|Problem|file,lines|solution| comments|
|---|---|---|---|
| | | | |
| | | | |
| | | | |