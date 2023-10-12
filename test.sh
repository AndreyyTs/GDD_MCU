#!/bin/bash

# Запустите iverilog с нужными параметрами
iverilog -g2005-sv test_gownak.sv -o test.vvp

# Если вы хотите сразу запустить сгенерированный исполняемый файл
vvp test.vvp


vvp test.vvp


gtkwave test_gownak.vcd 