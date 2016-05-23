*-----------------------------------------------------------
* Title      :User input
* Written by :Nguyen
* Date       :
* Description:Get user input, check the address length and jsr to convert2hex
*-----------------------------------------------------------
    
DISPLAY 
    LEA HELLO,A1      *LOAD Welcome message
    MOVE.B #14,D0     * Moves 14 into data register
    TRAP #15          *Prints out wecome message
          
*ask for starting address
STARTA 
    LEA REQSTART,A1   *load start message *A1 has the current starting
    MOVE.B #2,D0      *read string at (A1) and length is returned at D1
    TRAP #15          *Read input length into D1.L
*check length
    CMP.W #6,D1       *Check the length is no more than 24 bits, valid address 00007000-00FFFFFF
    BGT BADLENGTH     *if bad length goes to print error message
    BRA STARTA        *back to ask for new starting address
       
*Must sent to subroutine to be converted to HEX* 
    JSR CONVERT2HEX 

*Error checks    
    CMP #ERRADD,A6         *if address is incorrect then convert2hex will make A6,00000000 invalid address
    BEQ PRINTERR
    MOVEA.L A6,D3   *saves original addy to A6
    LSR.L #1,D3  *Left shift 1 bit, if carry bit's 1= odd, if it's 0=even
    BCS ODD      If odd then error
    MOVE.L A6,START_ADDR
    CMP.L #8,START_ADDR
    BGT PRINTERR
         
*ask for ending address       
ENDA   
    LEA REQEND,A1  *Load end message
    MOVE.B #2,D0   *read string at (A1) and length is returned at D1
    TRAP #15       *Read input into D1.L

*check length
    CMP.W #6,D1    *Check the length is no more than 24 bits, valid address 00007000-00FFFFFF
    BGT BADLENGTH     *if bad length goes to print error message
    BRA ENDA          *back to ask for new ending address

*send ending address to convert to HEX*
    JSR CONVERT2HEX

*Error checks    
    CMP #ERRADD,A6
    BEQ PRINTERR
    MOVE.B A6,D3     *move over to keep D1 unchanged
    LSR.L #1,D3      *Left shift 1 bit, if carry bit's 1= odd, if it's 0=even
    BCS ODDEND
    MOVE.L A6,END_ADDR   *Move A6 to end_address for storage
    CMP.L #8,END_ADDR    *compare the hex to 8 characters
    BGT PRINTERR         *branch to error
       
*check address validity
CHECKADDY
    MOVEA.L START_ADDR,A5  *Move start address to A5 
    CMPA.L   END_ADDR,A5   *Compares starting addy to the ending addy
    BGE END_GT_START    *If D1 (start) > D2 (end) go back for new addresses
       
    BRA PASS2OP         *The checks are done and the ascii to hex convert done
       
ODD
    LEA ODDERR,A1       *prints out odd error message
    MOVE.B #14,D0       
    TRAP #15
    BRA STARTA          *send back to ask for new starting address

ODDEND
    LEA ODDERR,A1       *prints out odd error message
    MOVE.B #14,D0       
    TRAP #15
    BRA ENDA            *send back to ask for new starting address
                
BADLENGTH
    LEA LENGTHERR,A1    *Prints out length error
    MOVE.B #14,D0
    TRAP #15

END_GT_START            *End length occurs before start must restart
    LEA LENGTHERR,A1
    MOVE.B #14,D0
    TRAP #15
    BRA STARTA

PASS2OP                Jump to the OPcode
    JSR OPCODE_BUFFER
    JSR PRINTSTART

AGAIN
    LEA ASKREPEAT,A1
    MOVE.B #2,D0
    TRAP #15
    CMP.B 'yes',(A1)
    JMP STARTA
    CMP.B 'no',(A1)
    JMP GOODBYE

    
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
