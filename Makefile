.,PHONY: run

all: run

run: ./build/Main
	./build/Main day01 ./inputs/day01

./build/Main: ./Main.agda ./Lib.agda ./Day01.agda
	agda --compile-dir=./build --compile ./Main.agda

clean:
	rm *\.agdai build/* -r

# agda --compile-dir=./build --compile ./Main.agda && ./build/Main day01 ./inputs/day01Ex
