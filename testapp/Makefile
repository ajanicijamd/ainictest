ROCM_HOME := /opt/rocm
AMDSMI_INCLUDE := $(ROCM_HOME)/include

CFLAGS += -std=c++17 -I$(AMDSMI_INCLUDE) \
  -g -O0 \
  -DUSE_AINIC \
  -DENABLE_ESMI_LIB \
  -DAINIC_SUPPORTED \
  -DENABLE_ESMI_LIB

LDFLAGS += -L $(ROCM_HOME)/lib -lstdc++ -lamd_smi -L $(ROCM_HOME)/lib

SOURCES := main.cpp ainic_stats.cpp
HEADERS := ainic_stats.hpp

all: build
build: prog
prog: $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) -o $@ $(SOURCES) $(LDFLAGS)

clean:
	rm -rf ./prog

rebuild: clean build
run: build
	. ./setenv.sh && ./prog
