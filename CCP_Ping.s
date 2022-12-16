#include <xc.inc>

global  CCP_setup, CCP_Int, CCP_reset, CCP1_count
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Reserve one byte for a count of CCP1 when an interrupt occured		       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
psect udata_acs
CCP1_count:	    ds 1
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;This module includes following routines:				       ;
; - Setting up CCP1 module and setting interrupt to every falling edge	       ;
; - Setting up Timer 1 module						       ;
; - Enabling all global and peripheral interrupts			       ;
; - Interrupt routine which stores CCP1 counter value (CCPR1H) in CCP1_count   ;
; - Dsbaling the CCP1 and Timer 1 modules				       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
psect	ccp_code,class=CODE

CCP_setup:
    bsf		TRISC, PORTC_RC2_POSN, A    ;RC2=CCP1 as input
    movlw	00000100B		    ;Interrupt every falling edge edge
    movwf	ECCP1CON, A			
    bsf		INTCON, 6, A		    ;PEIE is set 
    bsf		INTCON, 7, A		    ;GIE is set
    clrf	RCON, A			    ;Disable IPEN
    clrf	PIR1, A			    ;Clear all interrupt flags
    bsf		PIE1, 2, A		    ;CCP1IE enabled
    clrf	CCPR1L, A		    ;Clear CCP1 count
    clrf	CCPR1H, A
    clrf	TMR1L, A		    ;Clear Timer 1 count
    clrf	TMR1H, A
    movlw	01001001B		    ;Enable Timer 1
    movwf	T1CON, A
    return

CCP_Int:				    ;Interrupt routine
    bcf		PIR1, 0, A		    ;Clear Timer 1 interrupt flag
    btfsc	PIR1, 2, A		    ;Check if it is CCP1IF
    goto	CCP_1
    retfie				    ;Return from interrupt routine
    
CCP_1:
    movff	CCPR1H, CCP1_count, A	    ;Store CCP1 count high byte 
    clrf	PIR1, A			    ;Clear all flags
    clrf	CCPR1L, A		    ;Clear CCP1 count
    clrf	CCPR1H, A
    clrf	TMR1L, A		    ;Clear Timer 1 count
    clrf	TMR1H, A
                retfie
    
CCP_reset:
    clrf	ECCP1CON, A		    ;Disable CCP1
    clrf	PIR1, A			    ;Clear all interrupt flags
    bcf		PIE1, 2, A		    ;CCP1IE disabled
    clrf	CCPR1L, A		    ;Clear CCP1 count
    clrf	CCPR1H, A
    movlw	01001000B		    ;Disable Timer 1
    movwf	T1CON, A
    return
end
  
    
