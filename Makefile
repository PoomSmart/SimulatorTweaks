TARGET = simulator:clang
DEBUG = 0

include $(THEOS)/makefiles/common.mk

AGGREGATE_NAME = SimulatorTweaks
SUBPROJECTS = CameraEnabler

include $(THEOS_MAKE_PATH)/aggregate.mk

setup:: clean all
	@cp -v $(THEOS_OBJ_DIR)/*.dylib /opt/simject
	@cp -v */*.plist /opt/simject

move:: all
	@cp -v $(THEOS_OBJ_DIR)/*.dylib /opt/simject
	@cp -v */*.plist /opt/simject
