CC=coffee
SRCDIR=src
BUILDDIR=build
ALL_SRC_FILES := $(wildcard $(SRCDIR)/*)
ALL_OTHER_SRC_FILES := $(filter-out %.coffee, $(ALL_SRC_FILES))
ALL_OTHER_FILES := $(ALL_OTHER_SRC_FILES:$(SRCDIR)/%=$(BUILDDIR)/%)

SRC=$(wildcard $(SRCDIR)/*.coffee)
BUILD=$(SRC:$(SRCDIR)/%.coffee=$(BUILDDIR)/%.js)

all: other coffee icons

# coffeescript files

coffee: $(BUILD)

$(BUILDDIR)/%.js: $(SRCDIR)/%.coffee
	$(CC) -o $(BUILDDIR)/ -c $<

# other files

other: $(ALL_OTHER_FILES)

$(ALL_OTHER_FILES): $(BUILDDIR)/%: $(SRCDIR)/%
	cp $< $@

# icons

icons: build/rtsilver_128.png build/rtsilver_64.png build/rtsilver_48.png build/rtsilver_38.png build/rtsilver_19.png build/rtsilver_16.png

build/rtsilver_128.png:
	convert rtsilver-icon.png -resize 128x128 build/rtsilver_128.png

build/rtsilver_64.png:
	convert rtsilver-icon.png -resize 64x64 build/rtsilver_64.png

build/rtsilver_48.png:
	convert rtsilver-icon.png -resize 48x48 build/rtsilver_48.png

build/rtsilver_38.png:
	convert rtsilver-icon.png -resize 38x38 build/rtsilver_38.png

build/rtsilver_19.png:
	convert rtsilver-icon.png -resize 19x19 build/rtsilver_19.png

build/rtsilver_16.png:
	convert rtsilver-icon.png -resize 16x16 build/rtsilver_16.png

# crx building stuff

rsakey: key.pem

crx: rtsilver.crx

key.pem:
	@echo "Generating RSA key in PKCS#8 format."
	openssl genrsa 4096 | openssl pkcs8 -topk8 -nocrypt -out $@

rtsilver.crx: $(ALL_OTHER_FILES) $(BUILD) key.pem
	google-chrome --pack-extension="$(BUILDDIR)/" --pack-extension-key="key.pem"
	mv $(BUILDDIR).crx $@

# cleanup

.PHONY: clean
clean:
	-rm $(BUILDDIR)/*
	-rm rtsilver.crx
