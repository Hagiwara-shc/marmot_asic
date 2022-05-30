MARMOT_RTL_DIR = /home/shc/Development/RISC-V/freedom/Marmot_Caravel
VSRCS = $(MARMOT_RTL_DIR)/Marmot_Caravel.vc

copy:
	@for v in `egrep \.v$$ $(VSRCS) | egrep -ve '^ *(\+|-)'` ; do \
    cp -p $(MARMOT_RTL_DIR)/$$v . ; \
  done
	@cp -p $(MARMOT_RTL_DIR)/rom.vh .
	diff user_project_wrapper.v ..
	rm -f user_project_wrapper.v
	
clean:
	rm -f *.v *.vh

