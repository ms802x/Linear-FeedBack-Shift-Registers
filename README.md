# Linear Feedback Shift Register

Linear Feedback Shift Register can be used as a Pseudorandom number generator. This Linear Feedback Shift Register is built for 8051 Microcontroller Architecture .

![alt text](https://i.gyazo.com/3dfc2b0fe7a40c7f48e29f907a41d0ed.png)

## Background
The first value given to the LFSR is called the seed, the pattern generated by the seed make the generated sequence look as if it was random. However, the same input to the LFSR will always produce the same output.

This  code find the masks (XOR gates locations) that generates unique none repeated sequence for any given seed.   

## Reference
https://datagenetics.com/blog/november12017/index.html