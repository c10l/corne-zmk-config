kb_name = corne
sides = left right
TARGET = build/target
WEST_OPTS = "" # -p for pristine
USB_LOGGING_ARG = "-S zmk-usb-logging"

ifeq ($(USB_LOGGING),true)
BUILD_ARGS := $(USB_LOGGING_ARG)
endif

all: clean $(sides) reset
.PHONY: all

clean:
	rm -f $(TARGET)/*
.PHONY: clean

build/target:
	mkdir $(TARGET)/

left right: build/target
	west build \
		$(WEST_OPTS) \
		-d build/$@ \
		-s $(WORKSPACE_DIR)/app \
		-b nice_nano_v2 \
		$(BUILD_ARGS) \
		-- \
			-DSHIELD=$(kb_name)_$@ \
			-DZMK_CONFIG=$(shell pwd)/config \
			-DZMK_EXTRA_MODULES=$(shell pwd)

	cp build/$@/zephyr/zmk.uf2 $(TARGET)/$(kb_name)-$@.uf2
.PHONY: left right

reset:
	west build \
		-d build/reset \
		-s $(WORKSPACE_DIR)/app \
		-b nice_nano_v2 \
		-- \
		  -DSHIELD=settings_reset

	cp build/reset/zephyr/zmk.uf2 $(TARGET)/settings_reset.uf2
.PHONY: reset

flash-left:
	cp $(TARGET)/$(kb_name)-left.uf2 /Volumes/NICENANO/
.PHONY: flash-left

flash-right:
	cp $(TARGET)/$(kb_name)-right.uf2 /Volumes/NICENANO/
.PHONY: flash-right

flash-reset:
	cp $(TARGET)/settings_reset.uf2 /Volumes/NICENANO/
.PHONY: flash-reset
