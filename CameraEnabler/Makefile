TARGET = simulator:clang
DEBUG = 1
ARCHS = x86_64 i386
GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CameraEnabler
CameraEnabler_FILES = Tweak.xm
CameraEnabler_LIBRARIES = substrate MobileGestalt
CameraEnabler_USE_SUBSTRATE = 1

include $(THEOS_MAKE_PATH)/tweak.mk
