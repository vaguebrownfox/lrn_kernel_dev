# Kernel development

## 0x00 Introduction

-   Basics
-   Commands
    -   assemble:
        ```
        > nasm -f bin boot.asm -o boot.bin
        ```
    -   view assemled instructions:
        ```
        > ndisasm boot.bin
        ```
    -   execute binary
        ```
        > qemu-system-x86_64 -hda ./boot.bin
        ```
    -   write to drive: choose the drive properly!!! dd is a powerful command
        ```
        > sudo dd if=./boot.bin of=/dev/sdc
        ```

## 0x01 Bootloader

-   ### install qemu-system-x86_64: emulator

-   ### simple bootloader

    -   writing a character
    -   writing a message

-   ### improve bootloader

    -   setup segment registers: DS, ES
    -   setup stack and stack pointer

-   ### boot on actual hardware

    -   handle bios parameter block - working on pc!

-   ### custom interrupts

    -   write custom interrupts

-   ### Makefile: automate the build process

    -   create make file
    -   handle assemble
    -   write message after boot sector
    -   fill zeros to create another sector in the virtual hard-disk (boot.bin)
