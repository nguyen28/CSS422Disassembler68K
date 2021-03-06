************************************
* Instructions Beginning With 0000 *
* ** ADDI                          *
*                                  *
* This subroutine is done!         *
************************************
INSTR0000:
    MOVEM.L     A0-A5/D0-D7,-(SP)
    CLR.L       D7
    
    * verify 2nd set of 4 bits
    LEA         CURRENT_INSTR,A0
    MOVE.W      (A0),D5
    
    MOVE.B      #1,D4
    JSR         BITMASKER
    
    CMP.B       #6,D5
    BNE         NOOP_0000
     
    LEA         ADDI_TXT,A0             ; load the addi text
    MOVE.B      #1,D0                   ; choose buffer
    JSR         PUSHBUFFER              ; push the text to the buffer
    JSR         UPDATE_OPCODE
    
    * prep size info
    ROR.W       #2,D7                   ; type 0 size field, rotate to top
    ADDQ.B      #1,D7                   ; 2 bit size field
    ROR.W       #1,D7                   ; rotate to top
    ADDQ.B      #7,D7                   ; start index = 7
    ROR.W       #4,D7                   ; rotate to top
    ADDQ.B      #1,D7                   ; indicate size needed
    ROR.W       #1,D7                   ; rotate to top
    
    SWAP        D7                      ; swap size info to higher order word
    MOVE.W      (A6),D7                 ; move instruction in
    
    JSR         GET_OP_SIZE
    
    * update ea info
    LEA         EA_NEEDED,A0
    MOVE.B      #1,(A0)
    
    LEA         NUM_OPERANDS,A0
    MOVE.B      #2,(A0)
    BRA         FINISH_0000

NOOP_0000:
    MOVE.B      #1,D0
    JSR         NO_OPCODE    
    BRA         FINISH_0000
    
FINISH_0000:    
    MOVEM.L     (SP)+,A0-A5/D0-D7
    RTS










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
