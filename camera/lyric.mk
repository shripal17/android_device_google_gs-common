PRODUCT_SOONG_NAMESPACES += \
    hardware/google/camera

$(call soong_config_set,lyric,use_lyric_camera_hal,true)
$(call soong_config_set,google3a_config,gcam_awb,true)
$(call soong_config_set,google3a_config,ghawb_truetone,true)

# Flag controls whether Lyric apex can be located in the dist-directory.
$(call soong_config_set, lyric, dist_lyric_apex, $(RELEASE_PIXEL_DIST_LYRIC_APEX))

# Select GCH backend.
# TODO(b/192681010): This dependency inversion should be removed.
ifneq ($(wildcard vendor/google/services/LyricCameraHAL/src),)
$(call soong_config_set,gch,hwl_library,lyric)
endif

# Use build-time flag to select whether to build from source
# or ingest prebuilt-apex.  We would want the development teams
# using release configuration: (trunk-staging) to build from source.
# All shipping releases will switch to prebuilts (trunk+)
# if this condition is not true, then build from source.

ifneq ($(RELEASE_PIXEL_CAMERA_ENABLE_PREBUILT),true)

PRODUCT_SOONG_NAMESPACES += \
    vendor/google/camera \
    vendor/google/camera/google_3a/libs_v4 \
    vendor/google/camera/rlsservice

# TODO(b/257379485): 3A is incrementally enabling cuttlefish build for native
# code coverage support, temporary require separate namespace for folders that
# can be built successfully.
PRODUCT_SOONG_NAMESPACES += \
    vendor/google/camera/common/g3_shared \
    vendor/google/camera/google_3a/libs_v4/g3ABase \
    vendor/google/camera/google_3a/libs_v4/gABC/native_coverage \
    vendor/google/camera/google_3a/libs_v4/gAF \
    vendor/google/camera/google_3a/libs_v4/gafd \
    vendor/google/camera/google_3a/libs_v4/gHAWB/native_coverage

# Calibration tool for debug builds
PRODUCT_PACKAGES_ENG += tarasque_test
PRODUCT_PACKAGES_ENG += ProtoCalibGenerator
endif  # RELEASE_PIXEL_CAMERA_ENABLE_PREBUILT check

# Init-time log settings for Google 3A
PRODUCT_PACKAGES += libg3a_standalone_gabc_rc
PRODUCT_PACKAGES += libg3a_standalone_gaf_rc
PRODUCT_PACKAGES += libg3a_standalone_ghawb_rc

# Vendor APEX which contains the camera HAL
PRODUCT_PACKAGES += com.google.pixel.camera.hal
PRODUCT_PACKAGES += init.camera.set-interrupts-ownership
PRODUCT_PACKAGES += lyric_preview_dis_xml

DEVICE_PRODUCT_COMPATIBILITY_MATRIX_FILE += \
    device/google/gs-common/camera/device_framework_matrix_product.xml

DEVICE_MATRIX_FILE += \
    device/google/gs-common/camera/compatibility_matrix.xml

# sepolicy dir is added in dump.mk.
# Make doesn't deduplicate sepolicy dirs, so including it here causes build errors.
