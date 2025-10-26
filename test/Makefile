# Verilog Simulation Makefile

# Directories
SRC_DIR := $(PWD)/../src
TB_DIR  := tb
BUILD_DIR := build

# Tools
IVERILOG := iverilog
VVP := vvp
GTKWAVE := gtkwave

# Files
VCD_FILE := $(TB_DIR)/$(TB).vcd
SIM_OUT  := $(BUILD_DIR)/sim.out

# Verilog standard
STD := -g2012

# Default testbench
TB ?= logic_gates_tb

# Collect all Verilog sources
#SRC_FILES := $(wildcard $(SRC_DIR)/*.v)
SRC_FILES := $(shell find $(SRC_DIR) -type f -name "*.v")
TB_FILE   := $(TB_DIR)/$(TB).v

# Default target
.PHONY: all
all: run

# Create build directory if not existing
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Compile step
$(SIM_OUT): $(SRC_FILES) $(TB_FILE) | $(BUILD_DIR)
	@echo "Compiling $(TB_FILE)..."
	$(IVERILOG) $(STD) -o $@ $(SRC_FILES) $(TB_FILE)

# Run simulation
.PHONY: run
run: $(SIM_OUT)
	@echo "Running simulation..."
	$(VVP) $(SIM_OUT)
	@if [ -f "$(VCD_FILE)" ]; then \
		echo "Opening GTKWave..."; \
		$(GTKWAVE) $(VCD_FILE) & \
	fi

# Clean build artifacts
.PHONY: clean
clean:
	rm -rf $(BUILD_DIR) $(VCD_FILE)
	@echo "Clean complete."