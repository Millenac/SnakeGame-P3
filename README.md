# Snake Game in 16-bit Assembly

This project is an implementation of the classic Snake Game written in 16-bit assembly language. The processor was developed for the Instituto Superior Técnico (IST) in Portugal. The goal of the game is to make the snake grow as much as possible by having it eat fruits and avoiding collisions with the wall and with its own body.

## Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Requirements](#requirements)
- [Setup and Execution](#setup-and-execution)

## Features

- Classic Snake gameplay with directional movement.
- Randomized fruit placement for scoring.

## Project Structure

- `millena_snake.as`: Main assembly source file containing the game logic.
- `assembler.zip`: Contains the assembler tools required to compile the assembly code.
- `p3sim.jar`: Java-based simulator for running the assembled code.
- `manual.pdf`: Documentation for the assembler and simulator.
- `tutorial-p3.pdf`: Tutorial for setting up and using the simulator.

## Requirements

To run this project, you will need:

- Java Runtime Environment (JRE) to execute the `p3sim.jar` simulator.
- A Windows, macOS, or Linux operating system.

## Setup and Execution

### Clone the Repository:

```bash
git clone https://github.com/Millenac/SnakeGame-P3.git
```


### Extract Assembler Tools:
Unzip the `assembler.zip` file to a directory of your choice.

### Assemble the Code:
1. Navigate to the directory containing the assembler tools.
2. Use the assembler to compile `millena_snake.as` into machine code.
3. Refer to `manual.pdf` for detailed instructions on using the assembler.

### Run the Simulator:
1. Ensure you have Java installed on your system.
2. Open a terminal or command prompt.
3. Navigate to the directory containing `p3sim.jar`.
4. Execute the simulator with the assembled machine code:

```bash
java -jar p3sim.jar [assembled_code_file]
```

For detailed usage of the simulator, refer to `tutorial-p3.pdf`.
