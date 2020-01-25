# Preprocessor Brainfuck Interpreter

This project contains a compiler for brainfuck programs written in Bash,
targeting the C preprocessor as its runtime environment.

## How to use

1. Generate the headers

```
$ make
```

2. Compile your program into `main.h`, and provide the file used as input

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
