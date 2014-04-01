# VHDL make file

SRC_ROOT := src
VCOM_FLAGS := -93 -source -quiet
BUILD_DIR := build
TAG_DIR := $(BUILD_DIR)/tags
LIB_BASE_DIR := $(BUILD_DIR)/lib

NO_COLOR=\x1b[0m
SUCC_COLOR=\x1b[32;01m
ERROR_COLOR=\x1b[31;01m
WARN_COLOR=\x1b[33;01m

OK=$(OK_COLOR)[OK]$(NO_COLOR)

# Find the source files
#SRC_DIRS := $(sort $(dir $(wildcard $(SRC_ROOT)/*)))
SRC_DIRS := $(wildcard $(SRC_ROOT)/*)
LIB_DIRS := $(foreach sdir, $(SRC_DIRS), $(LIB_BASE_DIR)/$(notdir $(sdir)) )

VPATH = $(SRC_DIRS)
VPATH += $(TAG_DIR)

EXCLUDE_SRC := timing_ops_xilinx.vhdl
SRC := $(filter-out $(EXCLUDE_SRC), $(foreach sdir, $(SRC_DIRS), $(notdir $(wildcard $(sdir)/*.vhd*))))
SRC := $(filter %.vhd %.vhdl, $(SRC))

#$(info $(SRC))
#$(info $(SRC_DIRS))
#$(info $(LIB_DIRS))

TAG_OBJS := $(foreach fname, $(SRC), $(basename $(notdir $(fname))).tag)

.SUFFIXES:
.SUFFIXES: .vhdl .vhd

define BUILD_VHDL
@echo "** Compiling:" $<
dir=`dirname $<`; \
vcom $(VCOM_FLAGS) -work `basename $$dir` $<
@touch $(TAG_DIR)/$@
endef

%.tag: %.vhdl
	$(BUILD_VHDL)

%.tag: %.vhd
	$(BUILD_VHDL)


.PHONY: compile clean

compile: $(TAG_OBJS)

clean:
	rm -rf $(BUILD_DIR)



# Generate dependency rules
RULES := auto_rules.mk

$(BUILD_DIR)/$(RULES): $(SRC) | $(BUILD_DIR)
	@echo Making rules
	@python scripts/vdep.py $^ > $@

include $(BUILD_DIR)/$(RULES)



$(BUILD_DIR):
	mkdir $(BUILD_DIR)

$(TAG_DIR): | $(BUILD_DIR)
	mkdir $(TAG_DIR)


$(LIB_BASE_DIR): | $(BUILD_DIR)
	mkdir $(LIB_BASE_DIR)

$(LIB_DIRS): | $(LIB_BASE_DIR)
	@echo $(LIB_DIRS) | xargs -n 1 vlib



$(TAG_OBJS): | $(TAG_DIR) $(LIB_DIRS) $(BUILD_DIR)/$(RULES)


#all: $(TAG_OBJS)



