CC = gcc
CFLAGS = -c -Wall
PROFILE_FLAGS = -fprofile-arcs -ftest-coverage
TST_LIBS = -lcheck -lm -lpthread -lrt 
COV_LIBS = -lgcov -coverage
SRC_DIR= src
TST_DIR= tests
SRC_FILES = $(addprefix $(SRC_DIR)/, *.c) 
TST_FILES = $(addprefix $(TST_DIR)/, *.c)
GCOV = gcovr 
GCONV_FLAGS = -r . --xml


all: coverage.xml

money.o:  $(SRC_FILES) $(addprefix $(SRC_DIR)/, money.h)
	$(CC) $(CFLAGS) $(PROFILE_FLAGS) $(SRC_FILES) 

check_money.o: $(TST_FILES)
	$(CC) $(CFLAGS) $(PROFILE_FLAGS)  $(TST_FILES) 

check_money_tests: money.o check_money.o
	$(CC) money.o check_money.o $(TST_LIBS) $(COV_LIBS) -o check_money_tests

test: check_money_tests
	-LD_LIBRARY_PATH=/usr/local/lib ./check_money_tests
	-LD_LIBRARY_PATH=/usr/local/lib ./check_money_tests
coverage.xml: test
	$(GCOV) $(GCONV_FLAGS) -o coverage.xml

.PHONY: clean all

clean:
	-rm *.o *.html *.gcda *.gcno check_money_tests
