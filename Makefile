kb_name = corne
sides = left right
WEST_OPTS = "" # -p for pristine

all: clean $(sides) reset
.PHONY: all

clean:
	rm -f target/*
.PHONY: clean

target:
	mkdir target/

left right: target
	west build \
		$(WEST_OPTS) \
		-d build/$@ \
		-s $(WORKSPACE_DIR)/app \
		-b nice_nano_v2 \
		-- \
			-DSHIELD=$(kb_name)_$@ \
			-DZMK_CONFIG=$(shell pwd)/config \
			-DZMK_EXTRA_MODULES=$(shell pwd)

	cp build/$@/zephyr/zmk.uf2 target/$(kb_name)-$@.uf2
.PHONY: left right

reset:
	west build \
		-d build/reset \
		-s $(WORKSPACE_DIR)/app \
		-b nice_nano_v2 \
		-- \
		  -DSHIELD=settings_reset

	cp build/reset/zephyr/zmk.uf2 target/settings_reset.uf2
.PHONY: reset

flash-left:
	cp target/$(kb_name)-left.uf2 /Volumes/NICENANO/
.PHONY: flash-left

flash-right:
	cp target/$(kb_name)-right.uf2 /Volumes/NICENANO/
.PHONY: flash-right

flash-reset:
	cp target/settings_reset.uf2 /Volumes/NICENANO/
.PHONY: flash-reset
