# re2v
Regular expressions to SystemVerilog compiler.

## Overview
A small utility that converts a PCRE-style regular expression into a SystemVerilog NFA(nondeterministic finite automata). Regular expression is supplied as a command line 
argument, SystemVerilog code is printed to standard output:
```shell
re2v 'Hel{1,2}o'
```
## Interfaces
Generated code contains a module definition with following ports:

| Port name  | Direction | Width | Description|
| ------------- | ------------- | ------------- | ------------- |
| clk  | input  | 1 | Clock input |
| rst_n  | input  | 1 | Active low reset |
| in  | input  | 8 | Input stream character. Sampled on every clock cycle |
| match  | output  | 1 | Match detected. Set high every time pattern match is detected |


```verilog
module re(input clk, input rst_n, input logic [7:0] in, output match);
...
module
```

## Example
```shell
re2v 'Hel{1,2}o'
Input stream: "Hello, world!! Helo world! Helllo, world!!"
```
![re](https://cloud.githubusercontent.com/assets/1516471/21919215/69edca3c-d90d-11e6-92a7-f632597b524d.png)
