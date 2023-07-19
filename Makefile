
CXX = clang++

# define any compile-time flags
CXXFLAGS	:= -std=c++20 -Wall -Wextra -g

LFLAGS =

# output directory
OUTPUT	:= build
OBJDIR  := $(OUTPUT)/obj

# source directory
SRC		:= src

# include directory
INCLUDE	:= include

# lib directory
LIB		:= lib

ifeq ($(OS),Windows_NT)
MAIN	:= main.exe
SOURCEDIRS	:= $(SRC)
INCLUDEDIRS	:= $(INCLUDE)
LIBDIRS		:= $(LIB)
FIXPATH = $(subst /,\,$1)
RM			:= del /q /f
MD	:= mkdir
else
MAIN	:= main
SOURCEDIRS	:= $(shell find $(SRC) -type d)
INCLUDEDIRS	:= $(shell find $(INCLUDE) -type d)
LIBDIRS		:= $(shell find $(LIB) -type d)
FIXPATH = $1
RM = rm -f
MD	:= mkdir -p
endif

# Define all header includes
INCLUDES	:= $(patsubst %,-I%, $(INCLUDEDIRS:%/=%))

# Add all C/C++ libs
LIBS		:= $(patsubst %,-L%, $(LIBDIRS:%/=%))

# Add all .cpp files
SOURCES		:= $(wildcard $(patsubst %,%/*.cpp, $(SOURCEDIRS)))

# Define all object files
OBJECTS		:= $(OBJDIR)/$(notdir $(SOURCES:.cpp=.o))

# Define all dependency output files
DEPS		:= $(OBJDIR)/$(notdir $(OBJECTS:.o=.d))


OUTPUTMAIN	:= $(call FIXPATH,$(OUTPUT)/$(MAIN))

all: $(OUTPUT) $(MAIN)
	@printf "\033[0;32mExecuting all done\033[0m\n"

$(OUTPUT):
	$(MD) $(OUTPUT)
	$(MD) $(OBJDIR)

$(MAIN): $(OBJECTS)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -o $(OUTPUTMAIN) $(OBJECTS) $(LFLAGS) $(LIBS)

# include all .d files
-include $(DEPS)

$(OBJECTS): $(SOURCES)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c -MMD $<  -o $@

.PHONY: clean
clean:
	$(RM) -rf $(OUTPUT)

run: all
	./$(OUTPUTMAIN)
	@printf "\033[0;32mExecuting $(OUTPUTMAIN) done\033[0m\n"
