KICAD_PROJECT_NAME=pic_programmer
KICAD_PROJECT_FILE=$(KICAD_PROJECT_NAME).kicad_pro
KICAD_SCHEMATIC_FILE=$(KICAD_PROJECT_NAME).kicad_sch
KICAD_PCB_FILE=$(KICAD_PROJECT_NAME).kicad_pcb
KIBOT_RELEASE_CFG_FILE=release.kibot.yaml
KIBOT_OUTPUT_DIR=_build
KIBOT_DOCKER_CONTAINER_NAME=KiBot
KIBOT_DOCKER_IMAGE=setsoft/kicad_auto
KIBOT_DOCKER_TAG=dev_k6

define kibot-docker-pull
	docker pull "$(KIBOT_DOCKER_IMAGE):$(KIBOT_DOCKER_TAG)"
endef

define kibot-docker-run
docker run \
	--rm \
	-it \
	--platform linux/amd64 \
	--name="$(KIBOT_DOCKER_CONTAINER_NAME)" \
	--env NO_AT_BRIDGE=1 \
	--env INTERACTIVE_HTML_BOM_NO_DISPLAY=True \
	--volume="$(shell pwd):/home/root/workdir" \
	--workdir="/home/root/workdir" \
	"$(KIBOT_DOCKER_IMAGE):$(KIBOT_DOCKER_TAG)" \
	/bin/bash
endef

define kibot-release
	$(kibot-docker-pull)
	$(kibot-docker-run) -c "kibot -e $(KICAD_SCHEMATIC_FILE) -b $(KICAD_PCB_FILE) -c $(KIBOT_RELEASE_CFG_FILE) -d $(KIBOT_OUTPUT_DIR); sync"
endef

.PHONY: all release kibot-quick-start kibot-quick-start-dry kibot-example kibot-shell kibot-yaml tidy clean-kibot clean-backups clean-bom clean

all: release

release:
	$(kibot-release)

kibot-quick-start:
	$(kibot-docker-run) -c "kibot --quick-start"

kibot-quick-start-dry:
	$(kibot-docker-run) -c "kibot --quick-start --dry"

kibot-example:
	$(kibot-docker-run) -c "kibot --example"

kibot-shell:
	$(kibot-docker-run)

tidy:
	-$(RM) .DS_Store *~

clean-kibot:
	-$(RM) -r $(KIBOT_OUTPUT_DIR)

clean-backups:
	-$(RM) -r *-backups
	-$(RM) -r *-bak

clean-bom:
	-$(RM) $(KICAD_PROJECT_NAME).{xml,csv}

clean: tidy clean-kibot clean-backups clean-bom
	-$(RM) fp-info-cache
	-$(RM) report.txt

