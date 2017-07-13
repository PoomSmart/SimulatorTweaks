TARGET = simulator:clang
DEBUG = 0
ARCHS = x86_64 i386
GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FullSettings
FullSettings_FILES = Tweak.xm
FullSettings_PRIVATE_FRAMEWORKS = Preferences
FullSettings_USE_SUBSTRATE = 1

include $(THEOS_MAKE_PATH)/tweak.mk
