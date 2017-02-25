CC=gcc
CFLAGS=-m64 -c -g -O0 
ASMBIN=nasm
ASMFLAGS=-f elf64 -l $@.lst
LDFLAGS=-m64
LIBS=-lstdc++ `pkg-config --libs allegro-5.0`
CSRC=main.cpp
ASMSRC=cieniowanie.asm 
OBJECTS=$(ASMSRC:.asm=.o) $(CSRC:.cpp=.o)
EXECUTABLE=cieniowanieGourauda

all: $(OBJECTS) $(EXECUTABLE)
	
$(EXECUTABLE): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@ $(LIBS)

.cpp.o:
	$(CC) $(CFLAGS) $< -o $@
cieniowanie.o:
	$(ASMBIN) $(ASMFLAGS) cieniowanie.asm -o $@

clean :
	rm -f *.o
	rm -f *.lst
	rm -f cieniowanieGourauda



