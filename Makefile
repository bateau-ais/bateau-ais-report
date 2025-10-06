TARGET := bateau-ais-report
PDF_ENGINE := tectonic
DEFAULTS := defaults.yaml

all: dist/$(TARGET)

dist/$(TARGET): src/main.md $(DEFAULTS) directories
	pandoc src/main.md \
		--defaults=$(DEFAULTS) \
		--pdf-engine=$(PDF_ENGINE) \
		--resource-path=src \
		-o dist/$(TARGET).pdf

directories:
	mkdir -p dist

clean:
	rm dist/*

