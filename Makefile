# Compiler and flags
FC = mpif90
FFLAGS = -O2 -Wall
LDFLAGS = 

# Target executable
TARGET = simulation_model

# Source files
SRCS = simulation_model.f90

# Object files (automatically derived from source files)
OBJS = $(SRCS:.f90=.o)

# Default target
all: $(TARGET)

# Rule to build the target executable
$(TARGET): $(OBJS)
	$(FC) $(FFLAGS) -o $@ $(OBJS) $(LDFLAGS)

# Rule to compile Fortran source files into object files
%.o: %.f90
	$(FC) $(FFLAGS) -c $<

# Clean up build files
clean:
	rm -f $(OBJS) $(TARGET)

# Phony targets (not actual files)
.PHONY: all clean
