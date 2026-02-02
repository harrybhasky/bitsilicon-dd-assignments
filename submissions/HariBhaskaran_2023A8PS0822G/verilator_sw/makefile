
TOP       = stopwatch_top
VERILATOR = verilator
CXX       = g++
CXXFLAGS  = -std=c++17 -Wall

RTL_DIR   = ../rtl
SRC_CPP   = main.cpp

VERILATOR_FLAGS = -Wall --cc --exe --build --trace \
                  --top-module $(TOP) \
                  $(RTL_DIR)/stopwatch_top.v \
                  $(RTL_DIR)/seconds_counter.v \
                  $(RTL_DIR)/minutes_counter.v \
                  $(RTL_DIR)/control_fsm.v

all: sim

sim:
	$(VERILATOR) $(VERILATOR_FLAGS) $(SRC_CPP)

run:
	./obj_dir/V$(TOP)

clean:
	rm -rf obj_dir *.o *.vcd
