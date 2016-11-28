#ifndef CONFIG_USER_H
#define CONFIG_USER_H

#include "../../config.h"

/* N-key rollover */
#define FORCE_NKRO 1

/* Tap functionality */
#define TAPPING_TERM 200

/* For underglow */
#define RGB_DI_PIN B2     // The pin your RGB strip is wired to
#define RGBLIGHT_TIMER    // Not compatible with audio
#define RGBLED_NUM 12     // Number of LEDs
#define RGBLIGHT_HUE_STEP 10
#define RGBLIGHT_SAT_STEP 17
#define RGBLIGHT_VAL_STEP 17

#endif
