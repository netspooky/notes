# Shellcode Tricks

From 2021-07-02

* Solid reference https://www.felixcloutier.com/x86/index.html
* Hex Calculator https://n0.lol/hc/
* WinREPL for x86 Assembly https://github.com/zerosum0x0/WinREPL/releases/
* Online Assembler https://defuse.ca/online-x86-assembler.htm

## Avoiding bad chars

### Shifting left to avoid bad chars

Let's say you want to put 0x400 in EAX

Doing it like this yields null bytes

    b8 00 04 00 00          mov  eax, 0x400
    66 b8 00 04             mov  ax, 0x400 

So you could do it like:

    xor eax, eax
    inc eax
    shl eax, 0x0A

But this yields a potential bad char: 0xA

Shift past the bounds of EAX and end up on the same spot by adding 32 (0x20) to your shift parameter. This works because we know that EAX is 32 bits, so adding 32 will land you in the same location.

If you have a 0x1 in EAX

    xor eax, eax
    inc eax

Any of these will give you the 0x400 you are looking for

    shl eax, 0x2a
    shl eax, 0x4a
    shl eax, 0x6a
    etc..

- SHR shifts things out of the register, so it won't work for this
- There's other ways to do this with ROR/ROL
- Shift Reference: https://www.felixcloutier.com/x86/sal:sar:shl:shr
- Similar effects can be done with multiplication instructions if needed

### Chaining SHL

You can also chain shifts and increment operations together too, this can be used to build a complex values.

Let's say we want 0x0A0D in EAX, to use shifts, we need to look at these values in binary

    0x0A     0x0D
    00001010 00001101

We can then take the distance between the 1's and calculate how many shifts we need to do

       0x0A────0x0D────
       0000101000001101
    2 ─────┴─┘     ││ │
    6 ───────┴─────┘│ │
    1 ─────────────┴┘ │
    2 ──────────────┴─┘

Apply this by repeatedly incrementing and shifting left:

    ;-------------; OPCODE ; EAX Value --------------------------; Description ------
    xor eax, eax  ; 31c0   ; 00000000 00000000 00000000 00000000 ; Clear EAX
    inc eax       ; 40     ; 00000000 00000000 00000000 00000001 ; Increment
    shl eax, 0x2  ; c1e002 ; 00000000 00000000 00000000 00000100 ; Shifting by 2 bits
    inc eax       ; 40     ; 00000000 00000000 00000000 00000101 ; Increment
    shl eax, 0x6  ; c1e006 ; 00000000 00000000 00000001 01000000 ; Shifting by 6 bits
    inc eax       ; 40     ; 00000000 00000000 00000001 01000001 ; Increment
    shl eax, 0x1  ; d1e0   ; 00000000 00000000 00000010 10000010 ; Shifting by 1 bit
    inc eax       ; 40     ; 00000000 00000000 00000010 10000011 ; Increment
    shl eax, 0x2  ; c1e002 ; 00000000 00000000 00001010 00001100 ; Shifting by 2 bits
    inc eax       ; 40     ; 00000000 00000000 00001010 00001101 ; Increment

We can use the previous trick of adding 32 (0x20) to our shift value to avoid bad chars

    ;-------------; OPCODE ; EAX Value --------------------------; Description ------
    xor eax, eax  ; 31c0   ; 00000000 00000000 00000000 00000000 ; Clear EAX
    inc eax       ; 40     ; 00000000 00000000 00000000 00000001 ; Increment
    shl eax, 0x42 ; c1e042 ; 00000000 00000000 00000000 00000100 ; Shifting by 2 bits
    inc eax       ; 40     ; 00000000 00000000 00000000 00000101 ; Increment
    shl eax, 0x26 ; c1e026 ; 00000000 00000000 00000001 01000000 ; Shifting by 6 bits
    inc eax       ; 40     ; 00000000 00000000 00000001 01000001 ; Increment
    shl eax, 0x41 ; c1e041 ; 00000000 00000000 00000010 10000010 ; Shifting by 1 bit
    inc eax       ; 40     ; 00000000 00000000 00000010 10000011 ; Increment
    shl eax, 0x62 ; c1e062 ; 00000000 00000000 00001010 00001100 ; Shifting by 2 bits
    inc eax       ; 40     ; 00000000 00000000 00001010 00001101 ; Increment

### Add and Sub

Let's say you want 0x0A0D in EAX, but these are both bad chars, use the constant 0x1111 to armor it, then subtract the same value to restore.

    mov ax, 0x1B1E
    sub ax, 0x1111

### Logical Operations

You can avoid bad chars by using bitmasks and logical instructions too

In all of the examples, we want to put 0x0A0D in EAX

XOR (A good online XOR calculator http://xor.pw/)

    mov ax, 0x3037
    xor ax, 0x3a3a

NOT

    mov ax, 0xf5f2
    not ax

OR

    00001000 00001000 [0x0808]
    00000010 00000101 [0x0205]
    -------------------------- ORing keeps 1 if either or both bits is set to 1
    00001010 00001101 [0x0A0D]
    
    mov ax, 0x0808
    or  ax, 0x0205

AND 

    01011010 01001111 [0x5A4F]
    00101011 00111101 [0x2B3D]
    -------------------------- ANDing only keeps 1 if both bits are set to 1
    00001010 00001101 [0x0A0D]
    
    mov ax, 0x5A4F
    and ax, 0x2B3D

## Optimizing for Size

### Clearing Registers

[cdq](https://www.felixcloutier.com/x86/cwd:cdq:cqo) - Sign extends EAX to EDX:EAX, so `xor eax, eax` and then `cdq` will make EDX and EAX both 0 in only 3 bytes.

[mul](https://www.felixcloutier.com/x86/mul) - With only one operand specified, mul assumes that the destination is EAX, so it stores the result in EDX:EAX.

    xor ecx, ecx ; 0
    mul ecx      ; Effectively edx_eax = ecx * eax, now all equal 0

### Filling Multiple registers

* [pusha](https://www.felixcloutier.com/x86/pusha:pushad)
* [popa](https://www.felixcloutier.com/x86/popa:popad)
