#include <xc.inc>

global  Delay
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Reserve bytes for delay bits: high and low				       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
psect	udata_acs
high_delay_bit:	    ds 1
low_delay_bit:	    ds 1
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;This module involves a delay routine for approx 10 ms				       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
psect	delays_code,class=CODE
   
Delay:
    movlw	0x0A
    movwf	high_delay_bit, A
    movwf	low_delay_bit, A
    call	bigdelay
    return
bigdelay:
    movlw	0x0
loop:
    decf	low_delay_bit, f, A
    subwfb	high_delay_bit, f, A
    bc		loop
    return
    


