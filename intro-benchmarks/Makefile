LD_FLAGS=
DEPS=-L../src/harness/dilig -Wl,-rpath=../src/harness/dilig -l:binding_stdout.so

all: progs traces

FILES=01.c 02.c 03.c 04.c 05.c 06.c 07.c 08.c
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
