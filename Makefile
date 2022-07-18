KICAD_PROJECT_NAME=pic_programmer
SCHEMATIC=$(KICAD_PROJECT_NAME).kicad_sch
PCB=$(KICAD_PROJECT_NAME).kicad_pcb
KIBOT_CFG=.kibot/release.kibot.yaml
EXPORT_DIR=exports

.PHONY: release

# release:
# 	kibot -e $(SCHEMATIC) -b $(PCB) -c $(KIBOT_CFG)

release:
	docker run \
		--rm \
		-it \
		--name="KiBot" \
		--env NO_AT_BRIDGE=1 \
		--env INTERACTIVE_HTML_BOM_NO_DISPLAY=True \
		--volume="$(shell pwd):/home/root/workdir" \
		--workdir="/home/root/workdir" \
		setsoft/kicad_auto_test:ki6 \
		/bin/bash -c "kibot -e $(SCHEMATIC) -b $(PCB) -c $(KIBOT_CFG)"

docker-shell:
	docker run \
		--rm \
		-it \
		--name="KiBot" \
		--env NO_AT_BRIDGE=1 \
		--env INTERACTIVE_HTML_BOM_NO_DISPLAY=True \
		--volume="$(shell pwd):/home/root/workdir" \
		--workdir="/home/root/workdir" \
		setsoft/kicad_auto_test:ki6 \
		/bin/bash

clean:
	rm -f $(KICAD_PROJECT_NAME).xml
	rm -rf $(EXPORT_DIR)
