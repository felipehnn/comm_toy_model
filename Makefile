# Compiler and flags
FC = mpif90
FFLAGS = -O2 -Wall
LDFLAGS = 

# Target executable
TARGET = simulation_model.bin
TARGET2 = simulation_model_2.bin

# Source files
SRCS = simulation_model.f90
SRCS2 = simulation_model_2.f90

# Object files (automatically derived from source files)
OBJS = $(SRCS:.f90=.o)
OBJS2 = $(SRCS2:.f90=.o)

# Default target
all: $(TARGET) $(TARGET2)

# Rule to build the target executable
$(TARGET): $(OBJS)
	$(FC) $(FFLAGS) -o $@ $(OBJS) $(LDFLAGS)

$(TARGET2): $(OBJS2)
	$(FC) $(FFLAGS) -o $@ $(OBJS2) $(LDFLAGS)

# Rule to compile Fortran source files into object files
%.o: %.f90
	$(FC) $(FFLAGS) -c $<

# Clean up build files
clean:
	rm -f $(OBJS) $(TARGET)
	rm -f $(OBJS2) $(TARGET2)

# Phony targets (not actual files)
.PHONY: all clean
