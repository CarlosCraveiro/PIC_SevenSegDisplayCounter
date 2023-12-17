SRC=main.c
SRCDIR =src
CC=sdcc
FAMILY=pic16
PROC=18f4550

all: $(SRC:.c=.hex)

$(SRC:.c=.hex): $(SRCDIR)/$(SRC)
	$(CC) --use-non-free --use-crt=crt0.o -m$(FAMILY) -p$(PROC) $^

clean:
	rm -f $(SRC:.c=.asm) $(SRC:.c=.cod) $(SRC:.c=.hex) $(SRC:.c=.lst) $(SRC:.c=.o)

.PHONY: all clean
