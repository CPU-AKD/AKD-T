onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib IM_opt

do {wave.do}

view wave
view structure
view signals

do {IM.udo}

run -all

quit -force
