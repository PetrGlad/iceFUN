PROJ = adc

FILES = AdcDemo.v

.PHONY: build clean burn

build:
	verilator --lint-only -Wall $(FILES)
	# synthesize using Yosys
	yosys -p "synth_ice40 -top AdcDemo -json $(PROJ).json" $(FILES)
	# Place and route using nextpnr
	nextpnr-ice40 -r --hx8k --json $(PROJ).json --package cb132 --asc $(PROJ).asc --opt-timing --pcf iceFUN.pcf
	# nextpnr-ice40 -r --hx8k --json $(PROJ).json --package cb132 --asc $(PROJ).asc --pcf iceFUN.pcf

	# Convert to bitstream using IcePack
	icepack $(PROJ).asc $(PROJ).bin

gui:
	nextpnr-ice40 --gui -r --hx8k --json $(PROJ).json --package cb132 --asc $(PROJ).asc --opt-timing --pcf iceFUN.pcf

sim:
	verilator -cc --exe AdcDemo.v sim_main.cpp
	$(MAKE) -j 4 -C obj_dir -f VAdcDemo.mk
	obj_dir/VAdcDemo

burn:
	iceFUNprog -v $(PROJ).bin

clean:
	rm -f *.asc *.bin *.blif $(PROJ).json -rf obj_dir *.log *.dmp *.vpd core
