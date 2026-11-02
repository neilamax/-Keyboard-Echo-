# Memory-Mapped I/O Addresses:
# 0xFFFF0000 -> Keyboard Control (Ready bit is at bit 0)
# 0xFFFF0004 -> Keyboard Data (Contains ASCII character pressed)
# 0xFFFF0008 -> Display Control (Ready bit is at bit 0)
# 0xFFFF000C -> Display Data (Write character here to output it)

.data
# No static data needed for basic echo

.text
.globl main

main:
    # Load 32-bit MMIO base address 
    li    $t0, 0xFFFF0000   # Base address for keyboard and display registers

poll_keyboard:
    # Step 1: Check keyboard ready bit at 0xFFFF0000
    lw    $t1, 0($t0)       # Read keyboard control register
    andi  $t1, $t1, 1       # Mask to check ready bit (bit 0)
    beq   $t1, $zero, poll_keyboard # If not ready, keep polling

    # Step 2: Read character from keyboard data register at 0xFFFF0004
    lw    $t2, 4($t0)       # Read ASCII character into $t2

poll_display:
    # Step 3: Check display ready bit at 0xFFFF0008 before writing
    lw    $t3, 8($t0)       # Read display control register
    andi  $t3, $t3, 1       # Mask to check ready bit (bit 0)
    beq   $t3, $zero, poll_display # If display is busy, keep polling

    # Step 4: Write character to display data register at 0xFFFF000C
    sw    $t2, 12($t0)      # Send character to display screen

    # Step 5: Loop infinitely
    j     poll_keyboard
