# Compiler and flags
CXX = g++
CXXFLAGS = -O3 -Wall
OMPFLAGS = -fopenmp
SIMDFLAGS = -mavx2

# Directories
BIN_DIR = exe_bin
PART1_DIR = Part_1
PART2_DIR = Part_2
PART3_DIR = Part_3
PART4_DIR = Part_4

# Create bin directory if it doesn't exist
$(shell mkdir -p $(BIN_DIR))

# All targets
.PHONY: all part1 part2 part3 part4 clean help
.PHONY: pi_sequential pi_atomic pi_critical pi_reduce pi_split_array
.PHONY: vector_sequential vector_openmp vector_simd
.PHONY: fib_sequential fib_openmp
.PHONY: matrix_sequential matrix_openmp matrix_float matrix_half

all: part1 part2 part3 part4

# ========== PART 1: Pi Calculation ==========
part1: $(BIN_DIR)/tp_openmp_part_1_pi_sequential \
       $(BIN_DIR)/tp_openmp_part_1_pi_impl_atomic \
       $(BIN_DIR)/tp_openmp_part_1_pi_impl_critical \
       $(BIN_DIR)/tp_openmp_part_1_pi_impl_reduce \
       $(BIN_DIR)/tp_openmp_part_1_pi_impl_split_array

# Individual targets for Part 1
pi_sequential: $(BIN_DIR)/tp_openmp_part_1_pi_sequential
pi_atomic: $(BIN_DIR)/tp_openmp_part_1_pi_impl_atomic
pi_critical: $(BIN_DIR)/tp_openmp_part_1_pi_impl_critical
pi_reduce: $(BIN_DIR)/tp_openmp_part_1_pi_impl_reduce
pi_split_array: $(BIN_DIR)/tp_openmp_part_1_pi_impl_split_array

$(BIN_DIR)/tp_openmp_part_1_pi_sequential: $(PART1_DIR)/tp_openmp_part_1_pi_sequential.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

$(BIN_DIR)/tp_openmp_part_1_pi_impl_atomic: $(PART1_DIR)/tp_openmp_part_1_pi_impl_atomic.cpp
	$(CXX) $(CXXFLAGS) $(OMPFLAGS) $< -o $@

$(BIN_DIR)/tp_openmp_part_1_pi_impl_critical: $(PART1_DIR)/tp_openmp_part_1_pi_impl_critical.cpp
	$(CXX) $(CXXFLAGS) $(OMPFLAGS) $< -o $@

$(BIN_DIR)/tp_openmp_part_1_pi_impl_reduce: $(PART1_DIR)/tp_openmp_part_1_pi_impl_reduce.cpp
	$(CXX) $(CXXFLAGS) $(OMPFLAGS) $< -o $@

$(BIN_DIR)/tp_openmp_part_1_pi_impl_split_array: $(PART1_DIR)/tp_openmp_part_1_pi_impl_split_array.cpp
	$(CXX) $(CXXFLAGS) $(OMPFLAGS) $< -o $@

# ========== PART 2: Vector Operations ==========
part2: $(BIN_DIR)/tp_openmp_part_2_sequential \
       $(BIN_DIR)/tp_openmp_part_2_open_mp \
       $(BIN_DIR)/tp_openmp_part_2_simd

# Individual targets for Part 2
vector_sequential: $(BIN_DIR)/tp_openmp_part_2_sequential
vector_openmp: $(BIN_DIR)/tp_openmp_part_2_open_mp
vector_simd: $(BIN_DIR)/tp_openmp_part_2_simd

$(BIN_DIR)/tp_openmp_part_2_sequential: $(PART2_DIR)/tp_openmp_part_2_vector_sequential.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

$(BIN_DIR)/tp_openmp_part_2_open_mp: $(PART2_DIR)/tp_openmp_part_2_vector_openmp.cpp
	$(CXX) $(CXXFLAGS) $(OMPFLAGS) $< -o $@

$(BIN_DIR)/tp_openmp_part_2_simd: $(PART2_DIR)/tp_openmp_part_2_vector_simd.cpp
	$(CXX) $(CXXFLAGS) $(SIMDFLAGS) $< -o $@

# ========== PART 3: Fibonacci ==========
part3: $(BIN_DIR)/tp_openmp_part_3_fib_sequential \
       $(BIN_DIR)/tp_openmp_part_3_fib_openmp

# Individual targets for Part 3
fib_sequential: $(BIN_DIR)/tp_openmp_part_3_fib_sequential
fib_openmp: $(BIN_DIR)/tp_openmp_part_3_fib_openmp

$(BIN_DIR)/tp_openmp_part_3_fib_sequential: $(PART3_DIR)/tp_openmp_part_3_fib_sequential.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

$(BIN_DIR)/tp_openmp_part_3_fib_openmp: $(PART3_DIR)/tp_openmp_part_3_fib_openmp.cpp
	$(CXX) $(CXXFLAGS) $(OMPFLAGS) $< -o $@

# ========== PART 4: Matrix Multiplication ==========
part4: $(BIN_DIR)/tp_openmp_part_4_sequential \
       $(BIN_DIR)/tp_openmp_part_4_openmp \
       $(BIN_DIR)/tp_openmp_part_4_openmp_float \
       $(BIN_DIR)/tp_openmp_part_4_openmp_half

# Individual targets for Part 4
matrix_sequential: $(BIN_DIR)/tp_openmp_part_4_sequential
matrix_openmp: $(BIN_DIR)/tp_openmp_part_4_openmp
matrix_float: $(BIN_DIR)/tp_openmp_part_4_openmp_float
matrix_half: $(BIN_DIR)/tp_openmp_part_4_openmp_half

$(BIN_DIR)/tp_openmp_part_4_sequential: $(PART4_DIR)/tp_open_part_4_matrix_mult_sequential.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

$(BIN_DIR)/tp_openmp_part_4_openmp: $(PART4_DIR)/tp_open_part_4_matrix_mult_openmp.cpp
	$(CXX) $(CXXFLAGS) $(OMPFLAGS) $< -o $@

$(BIN_DIR)/tp_openmp_part_4_openmp_float: $(PART4_DIR)/tp_open_part_4_matrix_mult_openmp_float.cpp
	$(CXX) $(CXXFLAGS) $(OMPFLAGS) $< -o $@

$(BIN_DIR)/tp_openmp_part_4_openmp_half: $(PART4_DIR)/tp_open_part_4_matrix_mult_openmp_half.cpp
	$(CXX) $(CXXFLAGS) $(OMPFLAGS) $< -o $@

# ========== CLEAN ==========
clean:
	rm -rf $(BIN_DIR)/*

# Help target
help:
	@echo "Available targets:"
	@echo ""
	@echo "Build by Part:"
	@echo "  all     - Compile all parts"
	@echo "  part1   - Compile Part 1 (Pi calculation)"
	@echo "  part2   - Compile Part 2 (Vector operations)"
	@echo "  part3   - Compile Part 3 (Fibonacci)"
	@echo "  part4   - Compile Part 4 (Matrix multiplication)"
	@echo ""
	@echo "Part 1 - Individual Files:"
	@echo "  pi_sequential   - Compile sequential Pi implementation"
	@echo "  pi_atomic       - Compile atomic Pi implementation"
	@echo "  pi_critical     - Compile critical Pi implementation"
	@echo "  pi_reduce       - Compile reduce Pi implementation"
	@echo "  pi_split_array  - Compile split array Pi implementation"
	@echo ""
	@echo "Part 2 - Individual Files:"
	@echo "  vector_sequential - Compile sequential vector operations"
	@echo "  vector_openmp     - Compile OpenMP vector operations"
	@echo "  vector_simd       - Compile SIMD vector operations"
	@echo ""
	@echo "Part 3 - Individual Files:"
	@echo "  fib_sequential - Compile sequential Fibonacci"
	@echo "  fib_openmp     - Compile OpenMP Fibonacci"
	@echo ""
	@echo "Part 4 - Individual Files:"
	@echo "  matrix_sequential - Compile sequential matrix multiplication"
	@echo "  matrix_openmp     - Compile OpenMP matrix multiplication"
	@echo "  matrix_float      - Compile OpenMP matrix multiplication (float)"
	@echo "  matrix_half       - Compile OpenMP matrix multiplication (half precision)"
	@echo ""
	@echo "Utilities:"
	@echo "  clean  - Remove all compiled binaries"
	@echo "  help   - Show this help message"

