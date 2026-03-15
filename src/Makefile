FILE=top
FREQ=27 #MHz

CST = picorv32_20k.cst

PICORV32_SRC = cores/picorv32/picorv32.v
GOWIN_USER_FLASH_SRC = gowin_user_flash/gowin_user_flash.v
GOWIN_FLASH_CONTROLLER_SRC = gowin_flash_controller/gowin_flash_controller.v
GOWIN_RPLL_20K_SRC = gowin_rpll_20k/gowin_rpll.v

DEPS = $(PICORV32_SRC) countdown_timer.v edge_finder.v force_rebuild.v global_defs.v leds.v reset.v sd_spi_helper.v simpleuart.v sram8bit.v sram.v sys_parameters.v uart_wrap.v uflash_controller.v ws2812b_tgt.v ws2812b.v $(GOWIN_RPLL_20K_SRC)

# TODO: verilator/testbench + gtkwave simulation

$(FILE).json: $(FILE).v $(CST)
	yosys -p "read_verilog $(FILE).v $(DEPS); synth_gowin -top $(FILE) -json $(FILE).json"

pnr$(FILE).json: $(FILE).json
	nextpnr-himbaechel --json $(FILE).json \
										 --write pnr$(FILE).json \
										 --device GW2A-LV18QN88C8/I7 \
										 --vopt family=GW2A-18C \
										 --vopt cst=$(CST) \
										 --freq $(FREQ) \
										 --report report.json

$(FILE).fs: pnr$(FILE).json
	gowin_pack -d GW2A-18C -o $(FILE).fs pnr$(FILE).json

detect:
	@openFPGALoader --detect

upload: $(FILE).fs
	openFPGALoader -b tangnano20k -f $(FILE).fs

stats: report.json
	@jq -r ' "LUT4: \(.utilization.LUT4.used) / \(.utilization.LUT4.available) (\(.utilization.LUT4.used / .utilization.LUT4.available * 100 | floor)%)","DFF: \(.utilization.DFF.used) / \(.utilization.DFF.available) (\(.utilization.DFF.used / .utilization.DFF.available * 100 | floor)%)","IOB: \(.utilization.IOB.used) / \(.utilization.IOB.available) (\(.utilization.IOB.used / .utilization.IOB.available * 100)%)","fmax: \(.fmax.clk_IBUF_I_O.achieved) MHz (constraint: \(.fmax.clk_IBUF_I_O.constraint) MHz)" ' report.json

clean:
	@rm -f $(FILE).json pnr$(FILE).json $(FILE).fs report.json
