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
  OUTDIR := ../../../PluginsFolder

  ifeq ($(TARGET_ARCH),)
    TARGET_ARCH := -march=native
  endif

  CPPFLAGS := $(DEPFLAGS) -D "LINUX=1" -D "DEBUG=1" -D "_DEBUG=1" -D "_PROTOGEN=1" -D "JUCER_LINUX_MAKE_7346DA2A=1" -D "JUCE_APP_VERSION=1.0.0" -D "JUCE_APP_VERSION_HEX=0x10000" -I /usr/include -I /usr/include/freetype2 -I ../../../SDKs/vstsdk2.4_minimal -I ../../JuceLibraryCode -I ../../../JuceModules
  CFLAGS += $(CPPFLAGS) $(TARGET_ARCH) -g -ggdb -fPIC -O0
  CXXFLAGS += $(CFLAGS)
  LDFLAGS += $(TARGET_ARCH) -L$(BINDIR) -L$(LIBDIR) -shared -L/usr/X11R6/lib/ -lX11 -lXext -lXinerama -lasound -ldl -lfreetype -lpthread -lrt 
  LDDEPS :=
  RESFLAGS :=  -D "LINUX=1" -D "DEBUG=1" -D "_DEBUG=1" -D "_PROTOGEN=1" -D "JUCER_LINUX_MAKE_7346DA2A=1" -D "JUCE_APP_VERSION=1.0.0" -D "JUCE_APP_VERSION_HEX=0x10000" -I /usr/include -I /usr/include/freetype2 -I ../../../SDKs/vstsdk2.4_minimal -I ../../JuceLibraryCode -I ../../../JuceModules
  TARGET := Lua\ Protoplug\ Gen.so
  BLDCMD = $(CXX) -o $(OUTDIR)/$(TARGET) $(OBJECTS) $(LDFLAGS) $(RESOURCES) $(TARGET_ARCH)
  CLEANCMD = rm -rf $(OUTDIR)/$(TARGET) $(OBJDIR)
endif

ifeq ($(CONFIG),Release)
  BINDIR := build
  LIBDIR := build
  OBJDIR := build/intermediate/Release
  OUTDIR := ../../../PluginsFolder

  ifeq ($(TARGET_ARCH),)
    TARGET_ARCH := -march=native
  endif

  CPPFLAGS := $(DEPFLAGS) -D "LINUX=1" -D "NDEBUG=1" -D "_PROTOGEN=1" -D "JUCER_LINUX_MAKE_7346DA2A=1" -D "JUCE_APP_VERSION=1.0.0" -D "JUCE_APP_VERSION_HEX=0x10000" -I /usr/include -I /usr/include/freetype2 -I ../../../SDKs/vstsdk2.4_minimal -I ../../JuceLibraryCode -I ../../../JuceModules
  CFLAGS += $(CPPFLAGS) $(TARGET_ARCH) -fPIC -O3
  CXXFLAGS += $(CFLAGS)
  LDFLAGS += $(TARGET_ARCH) -L$(BINDIR) -L$(LIBDIR) -shared -fvisibility=hidden -L/usr/X11R6/lib/ -lX11 -lXext -lXinerama -lasound -ldl -lfreetype -lpthread -lrt 
  LDDEPS :=
  RESFLAGS :=  -D "LINUX=1" -D "NDEBUG=1" -D "_PROTOGEN=1" -D "JUCER_LINUX_MAKE_7346DA2A=1" -D "JUCE_APP_VERSION=1.0.0" -D "JUCE_APP_VERSION_HEX=0x10000" -I /usr/include -I /usr/include/freetype2 -I ../../../SDKs/vstsdk2.4_minimal -I ../../JuceLibraryCode -I ../../../JuceModules
  TARGET := Lua\ Protoplug\ Gen.so
  BLDCMD = $(CXX) -o $(OUTDIR)/$(TARGET) $(OBJECTS) $(LDFLAGS) $(RESOURCES) $(TARGET_ARCH)
  CLEANCMD = rm -rf $(OUTDIR)/$(TARGET) $(OBJDIR)
endif

OBJECTS := \
  $(OBJDIR)/CustomGuiPanel_d34626e.o \
  $(OBJDIR)/Dockable_912c3621.o \
  $(OBJDIR)/HintedFeel_6485c900.o \
  $(OBJDIR)/ProtoWindow_3fc7e6e.o \
  $(OBJDIR)/BinaryDejaVu_b69e6b6c.o \
  $(OBJDIR)/BinarySourceCodePro_c4bd2f3a.o \
  $(OBJDIR)/FreeTypeAmalgam_a9ef28cc.o \
  $(OBJDIR)/vf_FreeTypeFaces_e46f8fb5.o \
  $(OBJDIR)/LuaCodeTokeniser_b9f6b8c5.o \
  $(OBJDIR)/LuaLink_d9d518e2.o \
  $(OBJDIR)/LuaState_47f359f3.o \
  $(OBJDIR)/PluginEditor_ef07f2fa.o \
  $(OBJDIR)/PluginProcessor_319d19ef.o \
  $(OBJDIR)/BinaryData_ce4232d4.o \
  $(OBJDIR)/juce_audio_basics_8162c4a2.o \
  $(OBJDIR)/juce_audio_devices_396f78e0.o \
  $(OBJDIR)/juce_audio_formats_67f0c280.o \
  $(OBJDIR)/juce_audio_processors_40a1dc5a.o \
  $(OBJDIR)/juce_core_737cd184.o \
  $(OBJDIR)/juce_data_structures_1ace0a40.o \
  $(OBJDIR)/juce_events_fb82dbf8.o \
  $(OBJDIR)/juce_graphics_55e8ff5c.o \
  $(OBJDIR)/juce_gui_basics_2de558d8.o \
  $(OBJDIR)/juce_gui_extra_a2f7e060.o \
  $(OBJDIR)/juce_PluginUtilities_13ddfbec.o \
  $(OBJDIR)/juce_VST_Wrapper_b9d882f5.o \

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

$(OBJDIR)/CustomGuiPanel_d34626e.o: ../../../Source/guiclasses/CustomGuiPanel.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling CustomGuiPanel.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/Dockable_912c3621.o: ../../../Source/guiclasses/Dockable.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling Dockable.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/HintedFeel_6485c900.o: ../../../Source/guiclasses/HintedFeel.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling HintedFeel.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/ProtoWindow_3fc7e6e.o: ../../../Source/guiclasses/ProtoWindow.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling ProtoWindow.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/BinaryDejaVu_b69e6b6c.o: ../../../Source/vflib/BinaryDejaVu.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling BinaryDejaVu.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/BinarySourceCodePro_c4bd2f3a.o: ../../../Source/vflib/BinarySourceCodePro.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling BinarySourceCodePro.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/FreeTypeAmalgam_a9ef28cc.o: ../../../Source/vflib/FreeTypeAmalgam.c
	-@mkdir -p $(OBJDIR)
	@echo "Compiling FreeTypeAmalgam.c"
	@$(CC) $(CFLAGS) -o "$@" -c "$<"

$(OBJDIR)/vf_FreeTypeFaces_e46f8fb5.o: ../../../Source/vflib/vf_FreeTypeFaces.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling vf_FreeTypeFaces.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/LuaCodeTokeniser_b9f6b8c5.o: ../../../Source/LuaCodeTokeniser.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling LuaCodeTokeniser.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/LuaLink_d9d518e2.o: ../../../Source/LuaLink.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling LuaLink.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/LuaState_47f359f3.o: ../../../Source/LuaState.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling LuaState.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/PluginEditor_ef07f2fa.o: ../../../Source/PluginEditor.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling PluginEditor.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/PluginProcessor_319d19ef.o: ../../../Source/PluginProcessor.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling PluginProcessor.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/BinaryData_ce4232d4.o: ../../JuceLibraryCode/BinaryData.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling BinaryData.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_audio_basics_8162c4a2.o: ../../../JuceModules/juce_audio_basics/juce_audio_basics.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_audio_basics.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_audio_devices_396f78e0.o: ../../../JuceModules/juce_audio_devices/juce_audio_devices.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_audio_devices.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_audio_formats_67f0c280.o: ../../../JuceModules/juce_audio_formats/juce_audio_formats.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_audio_formats.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_audio_processors_40a1dc5a.o: ../../../JuceModules/juce_audio_processors/juce_audio_processors.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_audio_processors.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_core_737cd184.o: ../../../JuceModules/juce_core/juce_core.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_core.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_data_structures_1ace0a40.o: ../../../JuceModules/juce_data_structures/juce_data_structures.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_data_structures.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_events_fb82dbf8.o: ../../../JuceModules/juce_events/juce_events.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_events.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_graphics_55e8ff5c.o: ../../../JuceModules/juce_graphics/juce_graphics.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_graphics.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_gui_basics_2de558d8.o: ../../../JuceModules/juce_gui_basics/juce_gui_basics.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_gui_basics.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_gui_extra_a2f7e060.o: ../../../JuceModules/juce_gui_extra/juce_gui_extra.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_gui_extra.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_PluginUtilities_13ddfbec.o: ../../../JuceModules/juce_audio_plugin_client/utility/juce_PluginUtilities.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_PluginUtilities.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(OBJDIR)/juce_VST_Wrapper_b9d882f5.o: ../../../JuceModules/juce_audio_plugin_client/VST/juce_VST_Wrapper.cpp
	-@mkdir -p $(OBJDIR)
	@echo "Compiling juce_VST_Wrapper.cpp"
	@$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

-include $(OBJECTS:%.o=%.d)
