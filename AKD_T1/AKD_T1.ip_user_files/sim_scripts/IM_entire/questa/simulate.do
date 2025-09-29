onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib IM_entire_opt

do {wave.do}

view wave
view structure
view signals

do {IM_entire.udo}

run -all

quit -force
