#ifndef TUI_H
#define TUI_H
#define NCURSES_WIDECHAR 1

#include <ncurses.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <inttypes.h>
#include <errno.h>
#include <fcntl.h>
#include <string.h>
#include <locale.h>
#include <unistd.h>

#define MAIN_OPTIONS "Options"
#define MAIN_START "Start"
#define MAIN_EXIT "Exit"

#define MSG_COLOR 1
#define ICON_COLOR 2

typedef enum tui_screens {
    ERROR_SCREEN = -1,
    EXIT_SCREEN = 0,
    MAIN_SCREEN = 1,
    OPTIONS_SCREEN = 2,
    ENTER_DFU_SCREEN = 3,
    JAILBREAKING_SCREEN = 4,
    ENTER_RECOVERY_SCREEN = 5
} tui_screen_t;

tui_screen_t tui_screen_main();
tui_screen_t tui_screen_options();
tui_screen_t tui_screen_enter_recovery();
tui_screen_t tui_screen_enter_dfu();
tui_screen_t tui_screen_jailbreak();

int redraw_screen();


#endif