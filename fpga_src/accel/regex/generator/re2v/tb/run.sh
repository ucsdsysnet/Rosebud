./dist/build/re2v/re2v 'Hel{1,2}o' > m.sv
iverilog -g2005-sv tb.sv m.sv && vvp a.out
