# TODO:  Find a better way to separate build configs for ADP vs non-ADP devices
ifneq ($(BOARD_IS_AUTOMOTIVE),true)
LOCAL_PATH := $(call my-dir)

ifneq ($(TARGET_PROVIDES_KEYMASTER),true)

ifneq ($(filter msm8960 msm8226 msm8974 msm8610 msm8084 apq8084 msm8909 msm8916 msm8952 msm8992 msm8994,$(TARGET_BOARD_PLATFORM)),)

keymaster-def := -fvisibility=hidden -Wall
ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
ifneq ($(filter msm8960 msm8226 msm8974 msm8610 msm8084 apq8084,$(TARGET_BOARD_PLATFORM)),)
keymaster-def += -D_ION_HEAP_MASK_COMPATIBILITY_WA
endif
else
ifeq ($(TARGET_BOARD_PLATFORM),msm8084)
keymaster-def += -D_ION_HEAP_MASK_COMPATIBILITY_WA
endif
endif
ifeq ($(TARGET_KEYMASTER_WAIT_FOR_QSEE),true)
keymaster-def += -DWAIT_FOR_QSEE
endif

include $(CLEAR_VARS)

LOCAL_MODULE := keystore.$(TARGET_BOARD_PLATFORM)
LOCAL_LICENSE_KINDS := SPDX-license-identifier-Apache-2.0
LOCAL_LICENSE_CONDITIONS := notice

LOCAL_MODULE_RELATIVE_PATH := hw

LOCAL_SRC_FILES := keymaster_qcom.cpp

LOCAL_C_INCLUDES := \
    $(TARGET_OUT_HEADERS)/common/inc \
    $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include

LOCAL_CFLAGS := $(keymaster-def)
LOCAL_CFLAGS += -Wno-error

LOCAL_SHARED_LIBRARIES := \
        libcrypto \
        liblog \
        libc \
        libdl \
        libcutils \
        libhardware

LOCAL_ADDITIONAL_DEPENDENCIES := \
    $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr \
    $(LOCAL_PATH)/Android.mk

LOCAL_MODULE_TAGS := optional
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_OWNER := qcom

include $(BUILD_SHARED_LIBRARY)

endif # TARGET_BOARD_PLATFORM
endif # TARGET_PROVIDES_KEYMASTER
endif
