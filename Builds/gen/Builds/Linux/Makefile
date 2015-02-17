# Automatically generated makefile, created by the Introjucer
# Don't edit this file! Your changes will be overwritten when you re-save the Introjucer project!

# (this disables dependency generation if multiple architectures are set)
DEPFLAGS := $(if $(word 2, $(TARGET_ARCH)), , -MMD)

ifndef CONFIG
  CONFIG=Debug
endif

ifeq ($(CONFIG),Debug)
  BINDIR := build
  LIBDIR := build
  OBJDIR := build/intermediate/Debug
  OUTDIR := ../../../../Bin/linux

  ifeq ($(TARGET_ARCH),)
    TARGET_ARCH := -march=native
  endif

  CPPFLAGS := $(DEPFLAGS) -std=c++11 -D "LINUX=1" -D "DEBUG=1" -D "_DEBUG=1" -D "_PROTOGEN=1" -D "JUCER_LINUX_MAKE_7346DA2A=1" -D "JUCE_APP_VERSION=1.2.0" -D "JUCE_APP_VERSION_HEX=0x10200" -I /usr/include -I /usr/include/freetype2 -I ../../../../Frameworks/vstsdk2.4_minimal -I ../../JuceLibraryCode -I ../../../../Frameworks/JuceModules
  CFLAGS += $(CPPFLAGS) $(TARGET_ARCH) -g -ggdb -fPIC -O0
  CXXFLAGS += $(CFLAGS)
  LDFLAGS += $(TARGET_ARCH) -L$(BINDIR) -L$(LIBDIR) -shared -L/usr/X11R6/lib/ -lX11 -lXext -lXinerama -lasound -ldl -lfreetype -lpthread -lrt 
  LDDEPS :=
  RESFLAGS :=  -D "LINUX=1" -D "DEBUG=1" -D "_DEBUG=1" -D "_PROTOGEN=1" -D "JUCER_LINUX_MAKE_7346DA2A=1" -D "JUCE_APP_VERSION=1.2.0" -D "JUCE_APP_VERSION_HEX=0x10200" -I /usr/include -I /usr/include/freetype2 -I ../../../../Frameworks/vstsdk2.4_minimal -I ../../JuceLibraryCode -I ../../../../Frameworks/JuceModules
  TARGET := Lua\ Protoplug\ Gen.so
  BLDCMD = $(CXX) -o $(OUTDIR)/$(TARGET) $(OBJECTS) $(LDFLAGS) $(RESOURCES) $(TARGET_ARCH)
  CLEANCMD = rm -rf $(OUTDIR)/$(TARGET) $(OBJDIR)
endif

ifeq ($(CONFIG),Release)
  BINDIR := build
  LIBDIR := build
  OBJDIR := build/intermediate/Release
  OUTDIR := ../../../../Bin/linux

  ifeq ($(TARGET_ARCH),)
    TARGET_ARCH := -march=native
  endif

  CPPFLAGS := $(DEPFLAGS) -std=c++11 -D "LINUX=1" -D "NDEBUG=1" -D "_PROTOGEN=1" -D "JUCER_LINUX_MAKE_7346DA2A=1" -D "JUCE_APP_VERSION=1.2.0" -D "JUCE_APP_VERSION_HEX=0x10200" -I /usr/include -I /usr/include/freetype2 -I ../../../../Frameworks/vstsdk2.4_minimal -I ../../JuceLibraryCode -I ../../../../Frameworks/JuceModules
  CFLAGS += $(CPPFLAGS) $(TARGET_ARCH) -fPIC -O3
  CXXFLAGS += $(CFLAGS)
  LDFLAGS += $(TARGET_ARCH) -L$(BINDIR) -L$(LIBDIR) -shared -fvisibility=hidden -L/usr/X11R6/lib/ -lX11 -lXext -lXinerama -lasound -ldl -lfreetype -lpthread -lrt 
  LDDEPS :=
  RESFLAGS :=  -D "LINUX=1" -D "NDEBUG=1" -D "_PROTOGEN=1" -D "JUCER_LINUX_MAKE_7346DA2A=1" -D "JUCE_APP_VERSION=1.2.0" -D "JUCE_APP_VERSION_HEX=0x10200" -I /usr/include -I /usr/include/freetype2 -I ../../../../Frameworks/vstsdk2.4_minimal -I ../../JuceLibraryCode -I ../../../../Frameworks/JuceModules
  TARGET := Lua\ Protoplug\ Gen.so
  BLDCMD = $(CXX) -o $(OUTDIR)/$(TARGET) $(OBJECTS) $(LDFLAGS) $(RESOURCES) $(TARGET_ARCH)
  CLEANCMD = rm -rf $(OUTDIR)/$(TARGET) $(OBJDIR)
endif

OBJECTS := \
  $(OBJDIR)/BottomPane_7dd2cbf8.o \
  $(OBJDIR)/CustomGuiPanel_9883585f.o \
  $(OBJDIR)/Dockable_28a2b4d2.o \
  $(OBJDIR)/HintedFeel_f8575f71.o \
  $(OBJDIR)/ProtoWindow_ea5db61d.o \
  $(OBJDIR)/BinaryDejaVu_89f4d29b.o \
  $(OBJDIR)/BinarySourceCodePro_500c252b.o \
  $(OBJDIR)/FreeTypeAmalgam_4165a77d.o \
  $(OBJDIR)/vf_FreeTypeFaces_cad0c764.o \
  $(OBJDIR)/LuaCodeTokeniser_f0cb1fb4.o \
  $(OBJDIR)/LuaLink_9b975913.o \
  $(OBJDIR)/LuaState_be791fe2.o \
  $(OBJDIR)/PluginEditor_804b2969.o \
  $(OBJDIR)/PluginProcessor_8e389920.o \
  $(OBJDIR)/ProtoplugDir_f6898a0.o \
  $(OBJDIR)/BinaryData_ce4232d4.o \
  $(OBJDIR)/juce_audio_basics_8188fe57.o \
  $(OBJDIR)/juce_audio_devices_c8ee1955.o \
  $(OBJDIR)/juce_audio_formats_f76f62f5.o \
  $(OBJDIR)/juce_audio_processors_cbe1910f.o \
  $(OBJDIR)/juce_core_1a6f1539.o \
  $(OBJDIR)/juce_data_structures_906d6835.o \
  $(OBJDIR)/juce_events_93923d2d.o \
  $(OBJDIR)/juce_graphics_a84abe11.o \
  $(OBJDIR)/juce_gui_basics_e72eb50d.o \
  $(OBJDIR)/juce_gui_extra_e3e4c5d5.o \
  $(OBJDIR)/juce_PluginUtilities_efbf1261.o \
  $(OBJDIR)/juce_VST_Wrapper_73fdde6a.o \
  $(OBJDIR)/juce_VST3_Wrapper_759a2528.o \

.PHONY: clean

$(OUTDIR)/$(TARGET): $(OBJECTS) $(LDDEPS) $(RESOURCES)
	@echo Linking protoplug_gen
	-@mkdir -p $(BINDIR)
	-@mkdir -p $(LIBDIR)
	-@mkdir -p $(OUTDIR)
	@$(BLDCMD)

clean:
	@echo Cleaning protoplug_gen
	@$(CLEANCMD)

strip:
	@echo Stripping protoplug_gen
	-@strip --strip-unneeded $(OUTDIR)/$(TARGET)

$(OBJDIR)/BottomPane_7dd2cbf8.o: ../../../../Source/guiclasses/BottomPane.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling BottomPane.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/CustomGuiPanel_9883585f.o: ../../../../Source/guiclasses/CustomGuiPanel.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling CustomGuiPanel.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/Dockable_28a2b4d2.o: ../../../../Source/guiclasses/Dockable.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling Dockable.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/HintedFeel_f8575f71.o: ../../../../Source/guiclasses/HintedFeel.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling HintedFeel.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/ProtoWindow_ea5db61d.o: ../../../../Source/guiclasses/ProtoWindow.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling ProtoWindow.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/BinaryDejaVu_89f4d29b.o: ../../../../Source/vflib/BinaryDejaVu.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling BinaryDejaVu.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/BinarySourceCodePro_500c252b.o: ../../../../Source/vflib/BinarySourceCodePro.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling BinarySourceCodePro.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/FreeTypeAmalgam_4165a77d.o: ../../../../Source/vflib/FreeTypeAmalgam.c
	-@mkdir -p $(OBJDIR)
	@echo "Compiling FreeTypeAmalgam.c"
	@$(CC) $(CFLAGS) -o "$@" -c "$<"

$(OBJDIR)/vf_FreeTypeFaces_cad0c764.o: ../../../../Source/vflib/vf_FreeTypeFaces.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling vf_FreeTypeFaces.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/LuaCodeTokeniser_f0cb1fb4.o: ../../../../Source/LuaCodeTokeniser.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling LuaCodeTokeniser.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/LuaLink_9b975913.o: ../../../../Source/LuaLink.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling LuaLink.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/LuaState_be791fe2.o: ../../../../Source/LuaState.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling LuaState.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/PluginEditor_804b2969.o: ../../../../Source/PluginEditor.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling PluginEditor.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/PluginProcessor_8e389920.o: ../../../../Source/PluginProcessor.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling PluginProcessor.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/ProtoplugDir_f6898a0.o: ../../../../Source/ProtoplugDir.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling ProtoplugDir.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/BinaryData_ce4232d4.o: ../../JuceLibraryCode/BinaryData.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling BinaryData.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_audio_basics_8188fe57.o: ../../../../Frameworks/JuceModules/juce_audio_basics/juce_audio_basics.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_audio_basics.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_audio_devices_c8ee1955.o: ../../../../Frameworks/JuceModules/juce_audio_devices/juce_audio_devices.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_audio_devices.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_audio_formats_f76f62f5.o: ../../../../Frameworks/JuceModules/juce_audio_formats/juce_audio_formats.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_audio_formats.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_audio_processors_cbe1910f.o: ../../../../Frameworks/JuceModules/juce_audio_processors/juce_audio_processors.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_audio_processors.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_core_1a6f1539.o: ../../../../Frameworks/JuceModules/juce_core/juce_core.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_core.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_data_structures_906d6835.o: ../../../../Frameworks/JuceModules/juce_data_structures/juce_data_structures.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_data_structures.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_events_93923d2d.o: ../../../../Frameworks/JuceModules/juce_events/juce_events.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_events.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_graphics_a84abe11.o: ../../../../Frameworks/JuceModules/juce_graphics/juce_graphics.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_graphics.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_gui_basics_e72eb50d.o: ../../../../Frameworks/JuceModules/juce_gui_basics/juce_gui_basics.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_gui_basics.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_gui_extra_e3e4c5d5.o: ../../../../Frameworks/JuceModules/juce_gui_extra/juce_gui_extra.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_gui_extra.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_PluginUtilities_efbf1261.o: ../../../../Frameworks/JuceModules/juce_audio_plugin_client/utility/juce_PluginUtilities.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_PluginUtilities.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_VST_Wrapper_73fdde6a.o: ../../../../Frameworks/JuceModules/juce_audio_plugin_client/VST/juce_VST_Wrapper.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_VST_Wrapper.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_VST3_Wrapper_759a2528.o: ../../../../Frameworks/JuceModules/juce_audio_plugin_client/VST3/juce_VST3_Wrapper.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_VST3_Wrapper.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

-include $(OBJECTS:%.o=%.d)
