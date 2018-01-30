# GLUON-RELEASE to use
ifndef GLUON_RELEASE
	GLUON_RELEASE:=v2017.1.x
endif

#What branch in the site repos to use?
ifndef SITE_BRANCH
  	SITE_BRANCH:=v2017.1-no-autoupdate
endif

#What hoods to use?
ifndef KBU_HOODS
	KBU_HOODS:=ffkbu ffkbuk ffkbuu
endif

#What's the repository prefix
ifndef REPOSITORY_PREFIX
	REPOSITORY_PREFIX:=https://git.kbu.freifunk.net/ff-kbu/
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
dist/%: init site-%
	cp site-$*/site.mk $(PWD)/gluon/site
	cp site-$*/site.conf $(PWD)/gluon/site
	cp -a site-$*/i18n/* $(PWD)/gluon/site/i18n
	make -C gluon update
	
	#ar71xx-targets
	make -C gluon all GLUON_TARGET=ar71xx-tiny V=99 2> $(PWD)/err.txt > $(PWD)/out.txt
	make -C gluon all GLUON_TARGET=ar71xx-generic V=99 2>> $(PWD)/err.txt >> $(PWD)/out.txt
	
	#x86-targets
	make -C gluon all GLUON_TARGET=x86-generic V=99 2>> $(PWD)/err.txt >> $(PWD)/out.txt
	make -C gluon all GLUON_TARGET=x86-geode V=99 2>> $(PWD)/err.txt >> $(PWD)/out.txt
	make -C gluon all GLUON_TARGET=x86-64 V=99 2>> $(PWD)/err.txt >> $(PWD)/out.txt

	#Broadcom-targets
	make -C gluon all GLUON_TARGET=brcm2708-bcm2708 V=99 2>> $(PWD)/err.txt >> $(PWD)/out.txt
	make -C gluon all GLUON_TARGET=brcm2708-bcm2709 V=99 2>> $(PWD)/err.txt >> $(PWD)/out.txt

	# Misc targets
	make -C gluon all GLUON_TARGET=mpc85xx-generic V=99 2>> $(PWD)/err.txt >> $(PWD)/out.txt
	make -C gluon all GLUON_TARGET=ramips-mt7621 V=99 2>> $(PWD)/err.txt >> $(PWD)/out.txt

	mv $(PWD)/gluon/output $(PWD)/dist/$*
	cp -a site-$* $(PWD)/dist/$*/site-$*
	echo "Git status hood $*" >> $(PWD)/dist/log.txt
	cd $(PWD)/site-$*; git branch -v >> $(PWD)/dist/log.txt

site-%:
	git clone $(REPOSITORY_PREFIX)site-$*.git -b $(SITE_BRANCH) 


gluon/Makefile:
	git clone https://github.com/freifunk-gluon/gluon.git -b $(GLUON_RELEASE)
	mkdir -p $(PWD)/gluon/site/i18n

clean: $(addprefix clean-,$(KBU_HOODS))
	rm -Rf dist

clean-%:
	rm -Rf site-$*

