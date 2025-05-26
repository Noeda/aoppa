#
# $Id: Makefile 1111 2009-03-04 07:57:14Z os $
#

OPTIONS  = -D_GNU_SOURCE

CC       = cc
CXX      = c++
CFLAGS   = $(OPTIONS) -g -O2 -Wall -fPIC
CXXFLAGS = $(CFLAGS)
LDFLAGS  = -rdynamic
LIBS     = -ldl
OBJ      = main.o parser.o misc.o
PLUGINS  = input-mmap.so input-gzip.so output-xml.so output-ign.so
SOFLAGS  = -shared

all:	aoppa $(PLUGINS)

aoppa: $(OBJ)
	$(CXX) $(LDFLAGS) -o aoppa $(OBJ) $(LIBS)

clean:
	rm -f $(OBJ) aoppa $(PLUGINS) core

# %%%
# 25May2025 Mikko Hack: Compile parser.o into the plugins as well to fix linker
# issues.
#
# I don't think it's intended to be this way (ideally the code for
# handle_item() would be pulled form the executable that the .so plugins would
# use) but this was quickest and easiest way to make this compile.
# %%%
MIKKO_HACK_SRC_FOR_PLUGINS := parser.cc misc.c

## plugins
input-mmap.so: input-mmap.cc
	$(CXX) $(SOFLAGS) $(CXXFLAGS) $(MIKKO_HACK_SRC_FOR_PLUGINS) -o $@ $?

input-gzip.so: input-gzip.cc
	$(CXX) $(SOFLAGS) $(CXXFLAGS) $(MIKKO_HACK_SRC_FOR_PLUGINS) -o $@ $? -lz

output-xml.so: output-xml.cc
	$(CXX) $(SOFLAGS) $(CXXFLAGS) $(MIKKO_HACK_SRC_FOR_PLUGINS) -o $@ $?

output-ign.so: output-ign.cc
	$(CXX) $(SOFLAGS) $(CXXFLAGS) $(MIKKO_HACK_SRC_FOR_PLUGINS) -o $@ $?
