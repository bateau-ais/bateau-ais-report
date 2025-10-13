TARGET := bateau-ais-report
PDF_ENGINE := xelatex
DEFAULTS := defaults.yaml
out := dist

all: dist/$(TARGET)

dist/$(TARGET): src/main.md $(DEFAULTS) directories
	pandoc src/main.md \
		--defaults=$(DEFAULTS) \
		--pdf-engine=$(PDF_ENGINE) \
		--resource-path=src \
		-o $(out)/$(TARGET).pdf

directories:
	mkdir -p $(out)

