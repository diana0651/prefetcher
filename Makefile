CFLAGS = -msse2 --std gnu99 -O0 -Wall
EXEC = naive_transpose sse_transpose sse_prefetch_transpose

GIT_HOOKS := .git/hooks/pre-commit

all: $(GIT_HOOKS) $(EXECUTABLE)

transpose: main.c
	# $(CC) $(CFLAGS) -D$(subst _transpose,,$@) -o $@ main.c
	$(CC) $(CFLAGS) -DSSE_PREFETCH_TRANSPOSE main.c -o sse_prefetch_transpose
	$(CC) $(CFLAGS) -DSSE_TRANSPOSE main.c -o sse_transpose
	$(CC) $(CFLAGS) -DNAIVE_TRANSPOSE main.c -o naive_transpose

test: $(EXECUTABLE)
	./naive_transpose
	./sse_transpose
	./sse_prefetch_transpose
	# ./avx_transpose
	# ./avx_prefetch_transpose

cache-test: main
	perf stat -e cache-misses,cache-references,instructions,cycles ./naive_transpose  
	perf stat -e cache-misses,cache-references,instructions,cycles ./sse_transpose  
	perf stat -e cache-misses,cache-references,instructions,cycles ./sse_prefetch_transpose 

$(GIT_HOOKS):
	@scripts/install-git-hooks
	@echo

clean:
	$(RM) $(EXEC)
