# Preprocessor Brainfuck Interpreter

This project contains an interpreter for brainfuck programs that is written
solely in C preprocessor macros.

This implementation only uses simple preprocessor conditionals (`#if some-expression`), preprocessor defines without arguments (`#define FOO some-expression`), and (potentially recursive) inclusion of header files (`#include HEADER`). There exist other (IMO better) implementations of brainfuck for the C preprocessor that use other features, such as token pasting (such as [CPP_COMPLETE](https://github.com/orangeduck/CPP_COMPLETE)).

## How to use

1. Generate the headers

```
$ make
```

2. Encode your program into `main.h`, and provide the file used as input

```
$ ./bf_to_main.sh hello.bf /dev/null > main.h
```

3. Run the brainfuck interpreter

```
$ make run
```

or

```
$ make run DEBUG=1
```

## Note

The preprocessor brainfuck interpreter is very very inefficient and will use
around **16 GIGABYTES** of memory and **15 to 20 minutes of processing time**
while running `hello.bf`.
