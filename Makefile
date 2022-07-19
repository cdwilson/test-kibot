KICAD_PROJECT_NAME=pic_programmer
KICAD_SCHEMATIC=$(KICAD_PROJECT_NAME).kicad_sch
KICAD_PCB=$(KICAD_PROJECT_NAME).kicad_pcb
KIBOT_CFG=.kibot/release.kibot.yaml
KIBOT_OUTPUT_DIR=exports
KIBOT_DOCKER_CONTAINER_NAME=KiBot

.PHONY: release

all: release

release:
	docker run \
		--rm \
		-it \
		--name="$(KIBOT_DOCKER_CONTAINER_NAME)" \
		--env NO_AT_BRIDGE=1 \
		--env INTERACTIVE_HTML_BOM_NO_DISPLAY=True \
		--volume="$(shell pwd):/home/root/workdir" \
		--workdir="/home/root/workdir" \
		setsoft/kicad_auto_test:ki6 \
		/bin/bash -c "kibot -e $(KICAD_SCHEMATIC) -b $(KICAD_PCB) -c $(KIBOT_CFG)"

docker-shell:
	docker run \
		--rm \
		-it \
		--name="$(KIBOT_DOCKER_CONTAINER_NAME)" \
		--env NO_AT_BRIDGE=1 \
		--env INTERACTIVE_HTML_BOM_NO_DISPLAY=True \
		--volume="$(shell pwd):/home/root/workdir" \
		--workdir="/home/root/workdir" \
		setsoft/kicad_auto_test:ki6 \
		/bin/bash

clean:
	rm -f $(KICAD_PROJECT_NAME).xml
	rm -rf $(KIBOT_OUTPUT_DIR)
