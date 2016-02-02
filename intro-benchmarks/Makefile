LD_FLAGS=
DEPS=-L../src/harness/dilig -Wl,-rpath=../src/harness/dilig -l:binding_stdout.so

all: progs traces

FILES=01.c 02.c 03.c 04.c 05.c 06.c 08.c 10.c 11.c 12.c 13.c 14.c 15.c 16.c 17.c 18.c \
		  19.c 20.c
PROGS=$(FILES:.c=.run)
TRACES=$(FILES:.c=.out)

progs:	$(PROGS)
traces:	$(TRACES)

%.run: %.c
	$(CC) $(LD_FLAGS) $(CFLAGS) -o $@ $< $(DEPS)

%.out: %.run
	./$<>$@
	
clean:
	rm -rf *.o *.so *.run *.out
