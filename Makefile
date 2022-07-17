KICAD_PROJECT_NAME=pic_programmer
SCHEMATIC=$(KICAD_PROJECT_NAME).kicad_sch
PCB=$(KICAD_PROJECT_NAME).kicad_pcb
KIBOT_CFG=release.kibot.yaml
EXPORT_DIR=exports

.PHONY: release

release:
	kibot -e $(SCHEMATIC) -b $(PCB) -c $(KIBOT_CFG)

clean:
	rm -f $(KICAD_PROJECT_NAME).xml
	rm -rf $(EXPORT_DIR)
