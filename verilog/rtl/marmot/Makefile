MARMOT_DIR = /home/shc/Development/RISC-V/freedom/marmotcaravel
VSRCS = $(MARMOT_DIR)/Marmot.vc

copy:
	cp -p `grep -v '+incdir+' $(VSRCS)` .
	cp -p $(MARMOT_DIR)/rom.vh .
	
clean:
	rm -f *.v *.vh

