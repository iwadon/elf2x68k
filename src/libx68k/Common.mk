CROSS = m68k-xelf-
override CC = $(CROSS)gcc
override AS = $(CROSS)gcc
override LD = $(CROSS)gcc
override AR = $(CROSS)ar
override RANLIB = $(CROSS)ranlib

override CFLAGS = -m68000 -I.
override ASFLAGS = -m68000 -I.
