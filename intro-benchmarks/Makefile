LD_FLAGS=
DEPS=-L../src/harness/dilig -Wl,-rpath=../src/harness/dilig -l:binding_stdout.so

all: progs traces

progs:	01.run 02.run 03.run 04.run 05.run 06.run 07.run 08.run
traces:	01.out 02.out 03.out 04.out 05.out 06.out 07.out 08.out

%.run: %.c
	$(CC) $(LD_FLAGS) $(CFLAGS) -o $@ $< $(DEPS)

%.out: %.run
	./$<>$@
	
clean:
	rm -rf *.o *.so *.run *.out
