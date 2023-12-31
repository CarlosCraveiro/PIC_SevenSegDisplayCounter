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
### Project organization
The project is organized as follows:
```bash
PIC_SevenSegDisplayCounter
├── flake.lock          # Specifies program versions
├── flake.nix           # Main Nix project file
├── LICENSE
├── Makefile            # Project's Makefile
├── README.md
├── shell.nix           # Describes the development enviroment used
├── simu
│   ├── circuit.hex     # Pre-compiled Hex file for the simulation
│   └── circuit.simu    # Simulation File for SimulIDE
└── src
    └── main.c          # Actual Source Code
```
### Set everything up
This project uses [Nix](https://nixos.org/) as a package manager
This is needed even if you want to just test the project.
Ensure you have `nix` installed on your linux distribuition.
```bash
nix --experimental-features 'nix-command flakes'
```
### Just test the project with Flakes without having to Clone the Repo
```bash
nix run github:CarlosCraveiro/PIC_SevenSegDisplayCounter
```

### Complile the source
Next steps will only work if you have clonned this repo.
```bash
cd PIC_SevenSegDisplayCounter/
nix develop .
```
and
```bash
make all
```
or
```bash
nix build .
```

### Run Simulation
Next steps will only work if you have clonned this repo.
```bash
simulide simu/circuit.simu
```
Ensures that your hex file is the one you compiled it. Or...
```bash
nix run .
```

If everything works as expected you should see this schematics:
![Project's Schematics](https://github.com/CarlosCraveiro/PIC_SevenSegDisplayCounter/blob/main/images/ProjectSchematic.png)

## Documentation and Further Explanations 
Additional explanations can be found at the [Project's Wiki](https://github.com/CarlosCraveiro/PIC_SevenSegDisplayCounter/wiki)

## Bill Of Materials
This *BOM* refers to the components used on the SimulIDE simulation `simu/circuit.simu`

- **Push-24** : Push Button
- **Push-25** : Push Button
- **Resistor-33** : Resistor 1 kΩ
- **Resistor-34** : Resistor 1 kΩ
- **ResistorDip-2** : ResistorDip 150 Ω
- **Seven Segment-13** : Seven Segment Display Common Cathode
- **pic18f4550-1** : pic18f4550 microcontroler

## Authors
- Carlos Henrique Craveiro Aquino Veras - 12547187 - @CarlosCraveiro
- Gabriel Franceschi Libardi - 11760739 - @gabriel-libardi
