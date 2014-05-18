# VHDL make file

RTL_ROOT := rtl
VCOM_FLAGS := -source -quiet
BUILD_DIR := build
TAG_DIR := $(BUILD_DIR)/tags
LIB_BASE_DIR := $(BUILD_DIR)/lib

VERSION := $(shell grep -e "^version" doc/conf.py | sed -e "s/.*'\([^']*\)'/\1/")
DIST_NAME := vhdl-extras-$(VERSION)
DIST_DIR := $(BUILD_DIR)/dist/$(DIST_NAME)

NO_COLOR=\x1b[0m
SUCC_COLOR=\x1b[32;01m
ERROR_COLOR=\x1b[31;01m
WARN_COLOR=\x1b[33;01m

OK=$(OK_COLOR)[OK]$(NO_COLOR)

# Find the RTL source files
RTL_DIRS := $(wildcard $(RTL_ROOT)/*)
LIB_DIRS := $(foreach sdir, $(RTL_DIRS), $(LIB_BASE_DIR)/$(notdir $(sdir)) )

VPATH = $(RTL_DIRS)
VPATH += $(TAG_DIR)

# Skip XST specific timing package
EXCLUDE_RTL := timing_ops_xilinx.vhdl
RTL := $(filter-out $(EXCLUDE_RTL), $(foreach sdir, $(RTL_DIRS), $(notdir $(wildcard $(sdir)/*.vhd*))))
RTL := $(filter %.vhd %.vhdl, $(RTL))

TAG_OBJS := $(foreach fname, $(RTL), $(basename $(notdir $(fname))).tag)

.SUFFIXES:
.SUFFIXES: .vhdl .vhd

define BUILD_VHDL
@dir=`dirname $<`; \
if [ -z $${dir##*_*} ]; then \
std=$${dir##*_}; \
else \
std=93; \
fi; \
echo "** Compiling:" std=$$std lib=`basename $$dir` $<; \
vcom $(VCOM_FLAGS) -$$std -work `basename $$dir` $<
@touch $(TAG_DIR)/$@
endef

%.tag: %.vhdl
	$(BUILD_VHDL)

%.tag: %.vhd
	$(BUILD_VHDL)


.PHONY: compile clean dist

compile: $(TAG_OBJS)

clean:
	rm -rf $(BUILD_DIR)

dist: $(DIST_DIR)
	rm -rf $(DIST_DIR)/* $(DIST_DIR)/.* 2>&-; hg clone . $(DIST_DIR)
	cd $(BUILD_DIR)/dist; tar czf $(DIST_NAME).tgz $(DIST_NAME); zip -q -r $(DIST_NAME).zip $(DIST_NAME)

# Generate dependency rules
RULES := auto_rules.mk

$(BUILD_DIR)/$(RULES): $(RTL) | $(BUILD_DIR)
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


$(DIST_DIR): | $(BUILD_DIR)
	mkdir -p $(DIST_DIR)

