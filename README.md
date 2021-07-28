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
