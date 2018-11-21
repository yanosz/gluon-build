# GLUON-RELEASE to use
ifndef GLUON_RELEASE
	GLUON_RELEASE:=v2018.1.2
endif

#What hoods to use?
ifndef KBU_HOODS
	KBU_HOODS:=koeln bonn umgebung
endif

ifndef TARGETS
	TARGETS:=ar71xx-tiny ar71xx-generic ar71xx-nand x86-generic x86-geode x86-64 brcm2708-bcm2708 brcm2708-bcm2709 mpc85xx-generic ramips-mt7621
endif


###
### Nothing to be changed from here
###

world: dist

# Create all distribution artifacts in ./dist
dist: $(addprefix dist/,$(KBU_HOODS))
	find $(PWD)/dist -type f -print0  | xargs -0 sha512sum > $(PWD)/dist/sha512sums

# Log Build
init: gluon/Makefile
	mkdir -p $(PWD)/dist
	date > $(PWD)/dist/log.txt
	@echo "GLUON_RELEASE: $(GLUON_RELEASE)" >> $(PWD)/dist/log.txt
	@echo "REPOSITORY_PREFIX: $(REPOSITORY_PREFIX)" >> $(PWD)/dist/log.txt
	@echo "SITE_BRANCH: $(SITE_BRANCH)" >> $(PWD)/dist/log.txt
	@echo "Gluon git status" >> $(PWD)/dist/log.txt
	cd gluon; git branch -v >> $(PWD)/dist/log.txt

.PHONY: dist/% init clean clean-% dist world
# Create a distribution for a certain gluon
dist/%: init
	cp site/site.mk $(PWD)/gluon/site
	DOMAIN=$* envsubst < site/site.conf > $(PWD)/gluon/site/site.conf
	cp -a site/i18n/* $(PWD)/gluon/site/i18n
	cp -a site/domains $(PWD)/gluon/site
	make -C gluon update

	for target in $(TARGETS) ; do \
		make -j2 -C gluon all GLUON_TARGET=$$target V=99 2> $(PWD)/dist/err.txt > $(PWD)/dist/out.txt; \
		make -C gluon clean GLUON_TARGET=$$target; \
	done
	mv $(PWD)/gluon/output $(PWD)/dist/$*

gluon/Makefile:
	git clone https://github.com/freifunk-gluon/gluon.git -b $(GLUON_RELEASE)
	mkdir -p $(PWD)/gluon/site/i18n

clean:
	rm -Rf dist
