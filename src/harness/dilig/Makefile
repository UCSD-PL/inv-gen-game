LD_FLAGS=-shared -fPIC

all: binding.so binding_stdout.so

%.so: %.c
	$(CC) $(LD_FLAGS) $(CFLAGS) -o $@ $<
	
clean:
	rm -rf *.o *.so
