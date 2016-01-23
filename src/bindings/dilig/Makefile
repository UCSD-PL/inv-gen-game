all: binding.so

binding.so:	binding.c
	gcc -shared -fPIC -o binding.so binding.c

clean:
	rm -rf *.o *.so
