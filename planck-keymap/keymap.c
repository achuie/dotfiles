// This is the canonical layout file for the Quantum project. If you want to add another keyboard,
// this is the style you want to emulate.

#include "planck.h"
#include "action_layer.h"
#ifdef AUDIO_ENABLE
  #include "audio.h"
#endif
#include "eeconfig.h"

extern keymap_config_t keymap_config;

// Each layer gets a name for readability, which is then used in the keymap matrix below.
// The underscores don't mean anything - you can have a layer called STUFF or any other name.
// Layer names don't all need to be of the same length, obviously, and you can also skip them
// entirely and just use numbers.
#define _QWERTY 0
#define _COLEMAK 1
#define _DVORAK 2
#define _LOWER 3
#define _RAISE 4
#define _MOUSEC 5
#define _DIRECT 6
#define _ADJUST 16

enum planck_keycodes {
    QWERTY = SAFE_RANGE,
    COLEMAK,
    DVORAK,
    LOWER,
    RAISE,
    MOUSEC,
    DIRECT
};

// Fillers to make layering more clear
#define _______ KC_TRNS
#define XXXXXXX KC_NO

// Tap Dance declarations
enum {
    TD_SCLN_QUOT = 0
};

qk_tap_dance_action_t tap_dance_actions[] = {
    // Tap once for semicolon, twice for quote
    [TD_SCLN_QUOT] = ACTION_TAP_DANCE_DOUBLE(KC_SCLN, KC_QUOT)
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {

/* Qwerty
 *          ,-----------------------------------------------------------------------------------.
 *          | Tab  |   Q  |   W  |   E  |   R  |   T  |   Y  |   U  |   I  |   O  |   P  | Bksp |
 *          |------+------+------+------+------+-------------+------+------+------+------+------|
 *   Esc ---| Ctrl |   A  |   S  |   D  |   F  |   G  |   H  |   J  |   K  |   L  |;(2") |Enter |--- Tap ; 2x for "
 *          |------+------+------+------+------+------|------+------+------+------+------+------|
 *     ( ---|Shift |   Z  |   X  |   C  |   V  |   B  |   N  |   M  |   ,  |   .  |   /  |Shift |--- )
 *          |------+------+------+------+------+------+------+------+------+------+------+------|
 *          |MouseC| GUI  | Alt  |Direct|Lower |    Space    |Raise |Direct| Alt  | GUI  |MouseC|
 *          `-----------------------------------------------------------------------------------'
 *              [      {      <                                                >      }      ]
 */
[_QWERTY] = {
  {KC_TAB,  KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,    KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    KC_BSPC},
  {MT(MOD_LCTL, KC_ESC), KC_A, KC_S, KC_D, KC_F, KC_G, KC_H, KC_J, KC_K, KC_L,   TD(TD_SCLN_QUOT), MT(MOD_LCTL, KC_ENT)},
  {MT(MOD_LSFT, KC_LPRN), KC_Z, KC_X, KC_C, KC_V, KC_B, KC_N, KC_M, KC_COMM, KC_DOT, KC_SLSH, MT(MOD_LSFT, KC_RPRN)},
  {LT(MOUSEC, KC_LBRC), MT(MOD_LGUI, KC_LCBR), MT(MOD_LALT, KC_LABK), DIRECT, LOWER, KC_SPC, KC_SPC, RAISE, DIRECT, MT(MOD_LALT, KC_RABK), MT(MOD_LGUI, KC_RCBR), LT(MOUSEC, KC_RBRC)}
},

/* Colemak
 *          ,-----------------------------------------------------------------------------------.
 *          | Tab  |   Q  |   W  |   F  |   P  |   G  |   J  |   L  |   U  |   Y  |;(2") | Bksp |
 *          |------+------+------+------+------+-------------+------+------+------+------+------|
 *   Esc ---| Ctrl |   A  |   R  |   S  |   T  |   D  |   H  |   N  |   E  |   I  |   O  |Enter |
 *          |------+------+------+------+------+------|------+------+------+------+------+------|
 *     ( ---|Shift |   Z  |   X  |   C  |   V  |   B  |   K  |   M  |   ,  |   .  |   /  |Shift |--- )
 *          |------+------+------+------+------+------+------+------+------+------+------+------|
 *          |MouseC| GUI  | Alt  |Direct|Lower |    Space    |Raise |Direct| Alt  | GUI  |MouseC|
 *          `-----------------------------------------------------------------------------------'
 *              [      {      <                                                >      }      ]
 */
[_COLEMAK] = {
  {KC_TAB,  KC_Q,    KC_W,    KC_F,    KC_P,    KC_G,    KC_J,    KC_L,    KC_U,    KC_Y,    TD(TD_SCLN_QUOT), KC_BSPC},
  {MT(MOD_LCTL, KC_ESC),  KC_A,    KC_R,    KC_S,    KC_T,    KC_D,    KC_H,    KC_N,    KC_E,    KC_I,    KC_O,    MT(MOD_LCTL, KC_ENT)},
  {MT(MOD_LSFT, KC_LPRN),  KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,    KC_K,    KC_M,    KC_COMM, KC_DOT,  KC_SLSH, MT(MOD_LSFT, KC_RPRN)},
  {LT(MOUSEC, KC_LBRC), MT(MOD_LGUI, KC_LCBR), MT(MOD_LALT, KC_LABK), DIRECT, LOWER, KC_SPC, KC_SPC, RAISE, DIRECT, MT(MOD_LALT, KC_RABK), MT(MOD_LGUI, KC_RCBR), LT(MOUSEC, KC_RBRC)}
},

/* Dvorak
 *          ,-----------------------------------------------------------------------------------.
 *          | Tab  |   /  |   ,  |   .  |   P  |   Y  |   F  |   G  |   C  |   R  |   L  | Bksp |
 *          |------+------+------+------+------+-------------+------+------+------+------+------|
 *   Esc ---| Ctrl |   A  |   O  |   E  |   U  |   I  |   D  |   H  |   T  |   N  |   S  |Enter |
 *          |------+------+------+------+------+------|------+------+------+------+------+------|
 *     ( ---|Shift |;(2") |   Q  |   J  |   K  |   X  |   B  |   M  |   W  |   V  |   Z  |Shift |--- )
 *          |------+------+------+------+------+------+------+------+------+------+------+------|
 *          |MouseC| GUI  | Alt  |Direct|Lower |    Space    |Raise |Direct| Alt  | GUI  |MouseC|
 *          `-----------------------------------------------------------------------------------'
 *              [      {      <                                                >      }      ]
 */
[_DVORAK] = {
  {KC_TAB,  KC_SLSH, KC_COMM, KC_DOT,  KC_P,    KC_Y,    KC_F,    KC_G,    KC_C,    KC_R,    KC_L,    KC_BSPC},
  {MT(MOD_LCTL, KC_ESC),  KC_A,    KC_O,    KC_E,    KC_U,    KC_I,    KC_D,    KC_H,    KC_T,    KC_N,    KC_S,    MT(MOD_LCTL, KC_ENT)},
  {MT(MOD_LSFT, KC_LPRN), TD(TD_SCLN_QUOT), KC_Q,    KC_J,    KC_K,    KC_X,    KC_B,    KC_M,    KC_W,    KC_V,    KC_Z,    MT(MOD_LSFT, KC_RPRN)},
  {LT(MOUSEC, KC_LBRC), MT(MOD_LGUI, KC_LCBR), MT(MOD_LALT, KC_LABK), DIRECT, LOWER, KC_SPC, KC_SPC, RAISE, DIRECT, MT(MOD_LALT, KC_RABK), MT(MOD_LGUI, KC_RCBR), LT(MOUSEC, KC_RBRC)}
},

/* Lower
 *          ,-----------------------------------------------------------------------------------.
 *          |   `  |   1  |   2  |   3  |   4  |   5  |   6  |   7  |   8  |   9  |   0  | Del  |
 *          |------+------+------+------+------+-------------+------+------+------+------+------|
 *   Esc ---| Ctrl |  F1  |  F2  |  F3  |  F4  |  F5  |  F6  |      |   -  |   =  |   \  |Enter |
 *          |------+------+------+------+------+------|------+------+------+------+------+------|
 *     ( ---|Shift |  F7  |  F8  |  F9  |  F10 |  F11 |  F12 | Left | Down |  Up  |Right |Shift |--- )
 *          |------+------+------+------+------+------+------+------+------+------+------+------|
 *          |MouseC| GUI  | Alt  |Direct|Lower |    Space    |Raise |Direct| Alt  | GUI  |MouseC|
 *          `-----------------------------------------------------------------------------------'
 *              [      {      <                                                >      }      ]
 */
[_LOWER] = {
  {KC_GRV,  KC_1,    KC_2,    KC_3,    KC_4,    KC_5,    KC_6,    KC_7,    KC_8,    KC_9,    KC_0,    KC_DEL},
  {_______,  KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,   KC_F6, XXXXXXX, KC_MINS, KC_EQL, KC_BSLS, _______},
  {_______, KC_F7,   KC_F8,   KC_F9,   KC_F10,  KC_F11,  KC_F12,  KC_LEFT, KC_DOWN, KC_UP, KC_RGHT, _______},
  {_______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______}
},

/* Raise
 *          ,-----------------------------------------------------------------------------------.
 *          |   ~  |   !  |   @  |   #  |   $  |   %  |   ^  |   &  |   *  |   (  |   )  | Del  |
 *          |------+------+------+------+------+-------------+------+------+------+------+------|
 *   Esc ---| Ctrl |  F1  |  F2  |  F3  |  F4  |  F5  |  F6  |      |   _  |   +  |   |  |Enter |
 *          |------+------+------+------+------+------|------+------+------+------+------+------|
 *     ( ---|Shift |  F7  |  F8  |  F9  |  F10 |  F11 |  F12 | Left | Down |  Up  |Right |Shift |--- )
 *          |------+------+------+------+------+------+------+------+------+------+------+------|
 *          |MouseC| GUI  | Alt  |Direct|Lower |    Space    |Raise |Direct| Alt  | GUI  |MouseC|
 *          `-----------------------------------------------------------------------------------'
 *              [      {      <                                                >      }      ]
 */
[_RAISE] = {
  {KC_TILD, KC_EXLM, KC_AT,   KC_HASH, KC_DLR,  KC_PERC, KC_CIRC, KC_AMPR, KC_ASTR, KC_LPRN, KC_RPRN, KC_BSPC},
  {_______,  KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,   KC_F6,   XXXXXXX, KC_UNDS, KC_PLUS, KC_PIPE, _______},
  {_______, KC_F7,   KC_F8,   KC_F9,   KC_F10,  KC_F11,  KC_F12, KC_LEFT, KC_DOWN, KC_UP, KC_RGHT, _______},
  {_______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______}
},

/* Mouse Cursor
 *          ,-----------------------------------------------------------------------------------.
 *          |      |M Btn2| M Up |M Btn1|M Wh U|      |Scrp1 |Scrp2 |Scrp3 |Scrp4 |Scrp5 |      |
 *          |------+------+------+------+------+------+------+------+------+------+------+------|
 *   Esc ---| Ctrl |M Lft | M Dn |M Rght|M Wh D|      |Scrp6 |Scrp7 |Scrp8 |Scrp9 |Scrp10|Enter |
 *          |------+------+------+------+------+------+------+------+------+------+------+------|
 *     ( ---|Shift |M Wh L|M Btn3|M Wh R|      |      |      |Scrn L|Scrn R|      |      |Shift |--- )
 *          |------+------+------+------+------+------+------+------+------+------+------+------|
 *          |MouseC| GUI  | Alt  |Direct|Lower |    Space    |Raise |Direct| Alt  | GUI  |MouseC|
 *          `-----------------------------------------------------------------------------------'
 *              [      {      <                                                >      }      ]
 */

[_MOUSEC] = {
  {XXXXXXX, KC_BTN2, KC_MS_U, KC_BTN1, KC_WH_U, XXXXXXX, LGUI(LALT(KC_1)), LGUI(LALT(KC_2)), LGUI(LALT(KC_3)), LGUI(LALT(KC_4)), LGUI(LALT(KC_5)), XXXXXXX},
  {_______, KC_MS_L, KC_MS_D, KC_MS_R, KC_WH_D, XXXXXXX, LGUI(LALT(KC_6)), LGUI(LALT(KC_7)), LGUI(LALT(KC_8)), LGUI(LALT(KC_9)), LGUI(LALT(KC_0)), _______},
  {_______, KC_WH_L, KC_BTN3, KC_WH_R, XXXXXXX, XXXXXXX, XXXXXXX, LGUI(LCTL(LALT(KC_LEFT))), LGUI(LCTL(LALT(KC_RGHT))), XXXXXXX, XXXXXXX, _______},
  {_______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______}
},

/* Directional
 *          ,-----------------------------------------------------------------------------------.
 *          |      |      |      |      |      |      |      |      |      |      |      |      |
 *          |------+------+------+------+------+-------------+------+------+------+------+------|
 *   Esc ---| Ctrl | Home | PgDn | PgUp | End  |      |      | Left | Down |  Up  |Right |Enter |
 *          |------+------+------+------+------+------|------+------+------+------+------+------|
 *     ( ---|Shift |      |      |      |      |      |      |      |      |      |      |Shift |--- )
 *          |------+------+------+------+------+------+------+------+------+------+------+------|
 *          |MouseC| GUI  | Alt  |Direct|Lower |    Space    |Raise |Direct| Alt  | GUI  |MouseC|
 *          `-----------------------------------------------------------------------------------'
 *              [      {      <                                                >      }      ]
 */
[_DIRECT] = {
  {XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX},
  {_______, KC_HOME, KC_PGDN, KC_PGUP, KC_END,  XXXXXXX, XXXXXXX, KC_LEFT, KC_DOWN, KC_UP,   KC_RGHT, _______},
  {_______, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, _______},
  {_______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______}
},

/* Adjust (Lower + Raise)
 *          ,-----------------------------------------------------------------------------------.
 *          |Reset |      |      | Hue- | Hue+ |RGBTog|      |Qwerty|Colemk|Dvorak|      |      |
 *          |------+------+------+------+------+------+------+------+------+------+------+------|
 *   Esc ---|      |      |      | Sat- | Sat+ |RGBStp|      |      |      |      |      |Enter |
 *          |------+------+------+------+------+------+------+------+------+------+------+------|
 *     ( ---|      |      |      | Val- | Val+ |      |      |      |      |      |      |Shift |--- )
 *          |------+------+------+------+------+------+------+------+------+------+------+------|
 *          |MouseC| GUI  | Alt  |Direct|Lower |    Space    |Raise |Direct| Alt  | GUI  |MouseC|
 *          `-----------------------------------------------------------------------------------'
 *              [      {      <                                                >      }      ]
 */
[_ADJUST] = {
  {RESET,   XXXXXXX, XXXXXXX, F(3),    F(2),    F(0),    XXXXXXX, QWERTY,  COLEMAK, DVORAK,  XXXXXXX, XXXXXXX},
  {_______, XXXXXXX, XXXXXXX, F(5),    F(4),    F(1),    XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, _______},
  {_______, XXXXXXX, XXXXXXX, F(7),    F(6),    XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, _______},
  {_______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______}
}

};

enum function_id {
    RGBLED_TOGGLE,
    RGBLED_STEP_MODE,
    RGBLED_INCREASE_HUE,
    RGBLED_DECREASE_HUE,
    RGBLED_INCREASE_SAT,
   	RGBLED_DECREASE_SAT,
   	RGBLED_INCREASE_VAL,
   	RGBLED_DECREASE_VAL,
};

const uint16_t PROGMEM fn_actions[] = {
   	[0]  = ACTION_FUNCTION(RGBLED_TOGGLE),
   	[1]  = ACTION_FUNCTION(RGBLED_STEP_MODE),
   	[2]  = ACTION_FUNCTION(RGBLED_INCREASE_HUE),
   	[3]  = ACTION_FUNCTION(RGBLED_DECREASE_HUE),
   	[4]  = ACTION_FUNCTION(RGBLED_INCREASE_SAT),
   	[5]  = ACTION_FUNCTION(RGBLED_DECREASE_SAT),
   	[6]  = ACTION_FUNCTION(RGBLED_INCREASE_VAL),
   	[7]  = ACTION_FUNCTION(RGBLED_DECREASE_VAL),
};

void action_function(keyrecord_t *record, uint8_t id, uint8_t opt) {
    switch (id) {
   		case RGBLED_TOGGLE:
   			//led operations
   			if (record->event.pressed) {
   				rgblight_toggle();
   			}
   
   			break;
   		case RGBLED_INCREASE_HUE:
   			if (record->event.pressed) {
   				rgblight_increase_hue();
   			}
   			break;
   		case RGBLED_DECREASE_HUE:
   			if (record->event.pressed) {
   				rgblight_decrease_hue();
   			}
   			break;
   		case RGBLED_INCREASE_SAT:
   			if (record->event.pressed) {
   				rgblight_increase_sat();
   			}
   			break;
   		case RGBLED_DECREASE_SAT:
   			if (record->event.pressed) {
   				rgblight_decrease_sat();
   			}
   			break;
   		case RGBLED_INCREASE_VAL:
   			if (record->event.pressed) {
   				rgblight_increase_val();
   			}
   			break;
   		case RGBLED_DECREASE_VAL:
   			if (record->event.pressed) {
   				rgblight_decrease_val();
   			}
   			break;
   		case RGBLED_STEP_MODE:
   			if (record->event.pressed) {
   				rgblight_step();
   			}
   			break;
   	}
}

#ifdef AUDIO_ENABLE

float tone_startup[][2]    = SONG(STARTUP_SOUND);
float tone_qwerty[][2]     = SONG(QWERTY_SOUND);
float tone_dvorak[][2]     = SONG(DVORAK_SOUND);
float tone_colemak[][2]    = SONG(COLEMAK_SOUND);
float music_scale[][2]     = SONG(MUSIC_SCALE_SOUND);

float tone_goodbye[][2] = SONG(GOODBYE_SOUND);
#endif


void persistant_default_layer_set(uint16_t default_layer) {
    eeconfig_update_default_layer(default_layer);
    default_layer_set(default_layer);
}

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        case QWERTY:
            if (record->event.pressed) {
#ifdef AUDIO_ENABLE
                PLAY_NOTE_ARRAY(tone_qwerty, false, 0);
#endif
                persistant_default_layer_set(1UL<<_QWERTY);
            }
            return false;
            break;
        case COLEMAK:
            if (record->event.pressed) {
#ifdef AUDIO_ENABLE
                PLAY_NOTE_ARRAY(tone_colemak, false, 0);
#endif
                persistant_default_layer_set(1UL<<_COLEMAK);
            }
            return false;
            break;
        case DVORAK:
            if (record->event.pressed) {
#ifdef AUDIO_ENABLE
                PLAY_NOTE_ARRAY(tone_dvorak, false, 0);
#endif
                persistant_default_layer_set(1UL<<_DVORAK);
            }
            return false;
            break;
        case LOWER:
            if (record->event.pressed) {
                layer_on(_LOWER);
                update_tri_layer(_LOWER, _RAISE, _ADJUST);
            } else {
                layer_off(_LOWER);
                update_tri_layer(_LOWER, _RAISE, _ADJUST);
            }
            return false;
            break;
        case RAISE:
            if (record->event.pressed) {
                layer_on(_RAISE);
                update_tri_layer(_LOWER, _RAISE, _ADJUST);
            } else {
                layer_off(_RAISE);
                update_tri_layer(_LOWER, _RAISE, _ADJUST);
            }
            return false;
            break;
        case MOUSEC:
            if (record->event.pressed) {
                layer_on(_MOUSEC);
            } else {
                layer_off(_MOUSEC);
            }
            return false;
            break;
        case DIRECT:
            if (record->event.pressed) {
                layer_on(_DIRECT);
            } else {
                layer_off(_DIRECT);
            }
            return false;
            break;
    }
    return true;
}

void matrix_init_user(void) {
    #ifdef AUDIO_ENABLE
        startup_user();
    #endif
}

#ifdef AUDIO_ENABLE

void startup_user()
{
    _delay_ms(20); // gets rid of tick
    PLAY_NOTE_ARRAY(tone_startup, false, 0);
}

void shutdown_user()
{
    PLAY_NOTE_ARRAY(tone_goodbye, false, 0);
    _delay_ms(150);
    stop_all_notes();
}

void music_on_user(void)
{
    music_scale_user();
}

void music_scale_user(void)
{
    PLAY_NOTE_ARRAY(music_scale, false, 0);
}

#endif
