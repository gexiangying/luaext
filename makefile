#BIN = /cygdrive/d/MinGWStudio/MinGw/bin/
BIN = /cygdrive/e/mingw/bin/
CC = $(BIN)gcc 
PRJ = gcad
#CFLAGS = -mno-cygwin
CFLAGS = 
ifeq ($(notrace),1)
C_PROC= 
else
C_PROC = -DENABLE_TRACE
endif
ifeq ($(test),1)
C_PROC += -DENABLE_TEST
endif
INCPATH = -I./include
LIBPATH = -L./lib
LIBS = -lws2_32 -ltrace -lcomctl32 -lopengl32 -lglu32 -llua
#LDFLAGS = -mwindows -mno-cygwin
LDFLAGS = -mwindows
DEPS = $(PRJ).dep
SRCS :=$(wildcard *.c)
HPPS :=$(wildcard *.h)
OBJS :=$(patsubst %.c,%.o,$(SRCS))
RRCS :=$(wildcard *.rc)
RRCS_OBJS :=$(patsubst %.rc,%.res,$(RRCS))
WINDRES = $(BIN)windres
all:$(PRJ).exe $(DEPS) tags
tags:$(SRCS) $(HPPS)
	ctags -R .
$(PRJ).exe:$(OBJS) $(RRCS_OBJS)
	$(CC) -o $@ $(OBJS) $(RRCS_OBJS) $(LIBPATH) $(LIBS) $(LDFLAGS)
%.o:%.c	
	$(CC) $(CFLAGS) $(C_PROC) $(INCPATH) -c $< 
%.res:%.rc
	$(WINDRES) -O COFF -i "$<" -o "$@"
$(DEPS):$(SRCS) $(HPPS)
	$(CC) -MM $(INCPATH) *.c >$(DEPS)
#-@if test ! -r "$(DEPS)";then echo>$(DEPS);fi
#	makedepend  -f$(DEPS)>&/dev/null *.c
-include $(DEPS)
install:
	cp gcad.exe test.lua bin/
clean:
	-@rm *.o *.exe *.dep *.res
