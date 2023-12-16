# PIC - Seven Segment Display Counter
## Brief Descrption
A project for learning purposes in C programming language for **PIC18F** that explores the following features: *interrupts*, *timing*, *input and output ports (I/O)*, and *peripherals* (buttons, LEDs and 7-segment displays).

## Project Requirements
The project should be implemented in C programming language and should perform as follows:

- When a button connected to port **RB0** is pressed, a **seven segment display** connected to **Port D** must count (from 0 to 9 in a loop) with a period of **1s**.
- When a second button, connected to port **RB1**, is pressed, the same **seven segment display** must count (from 0 to 9 in a loop) with a period of **0.25s**.
- The **seven segment display** starts off and the count only starts when any of the buttons are pressed.
- Use the timer **TMR0** with **External Interruption (on the buttons)** to generate the time bases of the count and cause its changes. It is important to highlight that the buttons (keys) considered now are those of the momentary type, that is, you must press and release immediately afterwards because what counts for triggering the interrupt is the edge change.
- The **clock frequency** of the PIC must be **8 MHz** (HS external crystal).

## Guide throught the project
TODO...

### Project organization
### Set everything up
### Complile the source
### Run Simulation

## C Code detailed 
TODO..

## Bill Of Materials
TODO...

## Authors
- Carlos Henrique Craveiro Aquino Veras - 12547187 - @CarlosCraveiro
- Gabriel Franceschi Libardi - 11760739 - @gabriel-libardi
