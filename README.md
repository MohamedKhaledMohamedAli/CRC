# CRC (Cyclic Redundancy Check)
Implemented the CRC using LFSR (Linear Feedback Shift Register) which is:

    A shift register that has some of its outputs together in exclusive-OR or exclusive-NOR configurations to form a feedback path.
    The initial content of the shift register is referred to as seed.

![image](https://github.com/MohamedKhaledMohamedAli/CRC/assets/104237865/fe42cb24-ab98-4099-91ff-f6ab34bda3a7)

Specification

    1. All registers are set to LFSR Seed value using asynchronous active low reset (SEED = 8'hD8)
    2. All outputs are registered
    3. DATA serial bit length vary from 1 byte to 4 bytes (Typically: 1 Byte)
    4. ACTIVE input signal is high during data transmission, low otherwise
    5. CRC 8 bits are shifted serially through CRC output port 
    6. Valid signal is high during CRC bits transmission, otherwise low.
    
Operation:
    
    1. Initialize the shift registers (R7 – R0) to 8'hD8
    2. Shift the data bits into the LFSR in the order of LSB first.
    3. Once the last data bit is shifted into the LFSR, the registers contain the CRC bits 
    4. Shift out the CRC bits in the (R7 – R0) in order, R0 contains the LSB
    
