BUILD_DIR = /home/shc/Development/RISC-V/freedom/builds/marmotcaravel
VSRCS = $(BUILD_DIR)/shc.marmotcaravel.MarmotCaravelConfig.vsrcs.F

copy:
	cp -p `grep -v '+incdir+' $(VSRCS)` .
	cp -p $(BUILD_DIR)/rom.vh .
	
clean:
	rm -f *.v *.vh

