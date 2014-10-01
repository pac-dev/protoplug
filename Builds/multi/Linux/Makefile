BUILDDIR = ../../../Bin/linux
SO1 = Lua\ Protoplug\ Fx.so
SO2 = Lua\ Protoplug\ Gen.so

all: $(BUILDDIR)/$(SO1) $(BUILDDIR)/$(SO2)
$(BUILDDIR)/$(SO1):
	cd ../../fx/Builds/Linux && $(MAKE)
$(BUILDDIR)/$(SO2):
	cd ../../gen/Builds/Linux && $(MAKE)

clean:
	cd ../../fx/Builds/Linux && $(MAKE) clean
	cd ../../gen/Builds/Linux && $(MAKE) clean

strip:
	cd ../../fx/Builds/Linux && $(MAKE) strip
	cd ../../gen/Builds/Linux && $(MAKE) strip

# when changing these, check hardcoded relative symlinks below (rpmbuild compat)
# and non-installRoot path written to txt
TARGET_PATH1 = $(INSTALLROOT)/usr/local/lib/lxvst
TARGET_PATH2 = $(INSTALLROOT)/usr/local/lib/vst
PPGFILES_LOC = $(INSTALLROOT)/usr/share

install: $(BUILDDIR)/$(SO1) $(BUILDDIR)/$(SO2)
	@echo "installing protoplug to $(TARGET_PATH1)"
	install -D $(BUILDDIR)/$(SO1) "$(TARGET_PATH1)"/$(SO1)
	install -D $(BUILDDIR)/$(SO2) "$(TARGET_PATH1)"/$(SO2)
	install -d $(PPGFILES_LOC)
	cp -rf ../../../ProtoplugFiles $(PPGFILES_LOC)/
	chmod -R +r $(PPGFILES_LOC)/ProtoplugFiles
	echo  /usr/share/ProtoplugFiles > "$(TARGET_PATH1)"/ProtoplugFiles.txt
	install -d "$(TARGET_PATH2)"
	cd "$(TARGET_PATH2)"; ln -sf ../lxvst/$(SO1) $(SO1)
	cd "$(TARGET_PATH2)"; ln -sf ../lxvst/$(SO2) $(SO2)
ifdef LXVST_PATH
ifneq ($(LXVST_PATH), $(TARGET_PATH1))
ifneq ($(LXVST_PATH), $(TARGET_PATH2))
	install -d "$(LXVST_PATH)"
	ln -sf "$(TARGET_PATH1)"/$(SO1) "$(LXVST_PATH)"/$(SO1)
	ln -sf "$(TARGET_PATH1)"/$(SO2) "$(LXVST_PATH)"/$(SO2)
endif
endif
endif
ifdef VST_PATH
ifneq ($(LXVST_PATH), $(TARGET_PATH1))
ifneq ($(LXVST_PATH), $(TARGET_PATH2))
ifneq ($(VST_PATH), $(LXVST_PATH))
	install -d "$(VST_PATH)"
	ln -sf "$(TARGET_PATH1)"/$(SO1) "$(VST_PATH)"/$(SO1)
	ln -sf "$(TARGET_PATH1)"/$(SO2) "$(VST_PATH)"/$(SO2)
endif
endif
endif
endif
	@echo "Successfully installed protoplug"

uninstall:
	@echo "uninstalling protoplug"
	rm -f "$(TARGET_PATH1)"/$(SO1)
	rm -f "$(TARGET_PATH1)"/$(SO2)
	-rm -f "$(TARGET_PATH2)"/$(SO1)
	-rm -f "$(TARGET_PATH2)"/$(SO2)
ifdef LXVST_PATH
ifneq ($(LXVST_PATH), $(TARGET_PATH1))
ifneq ($(LXVST_PATH), $(TARGET_PATH2))
	-rm -f "$(LXVST_PATH)"/$(SO1)
	-rm -f "$(LXVST_PATH)"/$(SO2)
endif
endif
endif
ifdef VST_PATH
ifneq ($(LXVST_PATH), $(TARGET_PATH1))
ifneq ($(LXVST_PATH), $(TARGET_PATH2))
ifneq ($(VST_PATH), $(LXVST_PATH))
	-rm -f "$(VST_PATH)"/$(SO1)
	-rm -f "$(VST_PATH)"/$(SO2)
endif
endif
endif
endif
	@echo "Successfully uninstalled protoplug"
