LD_FLAGS=
DEPS=-L../src/harness/dilig -Wl,-rpath=../src/harness/dilig -l:binding_stdout.so

all: progs traces

FILES=add.c cegar1.c dilig25.c multiply.c square.c
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
