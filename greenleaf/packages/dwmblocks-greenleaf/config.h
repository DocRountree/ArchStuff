#ifndef CONFIG_H
#define CONFIG_H

// Greenleaf status bar (dwmblocks-async). The sb-* scripts print their own
// icons; dwm-greenleaf centres the clock (signal 5) and makes every block
// clickable (statuscmd passes the mouse button as BLOCK_BUTTON).

// String used to delimit block outputs in the status.
#define DELIMITER "   "

// Maximum number of Unicode characters that a block can output.
#define MAX_BLOCK_OUTPUT_LENGTH 45

// Control whether blocks are clickable.
#define CLICKABLE_BLOCKS 1

// Control whether a leading delimiter should be prepended to the status.
#define LEADING_DELIMITER 0

// Control whether a trailing delimiter should be appended to the status.
#define TRAILING_DELIMITER 0

// X(icon, cmd, interval, signal). Empty output hides a block (sb-gpu without
// an NVIDIA GPU, sb-livehint on an installed system).
#define BLOCKS(X)                \
    X("", "sb-livehint", 0, 7)   \
    X("", "sb-cpu", 2, 1)        \
    X("", "sb-gpu", 2, 6)        \
    X("", "sb-memory", 5, 2)     \
    X("", "sb-network", 2, 3)    \
    X("", "sb-volume", 2, 4)     \
    X("", "sb-clock", 1, 5)

#endif  // CONFIG_H
