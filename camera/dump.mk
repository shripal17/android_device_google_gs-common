BOARD_VENDOR_SEPOLICY_DIRS += device/google/gs-common/camera/sepolicy/

ifneq (,$(filter eng, $(TARGET_BUILD_VARIANT)))
PRODUCT_PACKAGES_DEBUG += dump_camera
endif
