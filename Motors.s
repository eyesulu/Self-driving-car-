#include <xc.inc>

global  Motors_setup, Forward, Backward, Turn_left, Turn_right,Stop, Standby, Start_motors
    
psect	motors_code,class=CODE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Output A is connected to left motors, Output B is connected to right motors   ;
;The control of motors is performed by clicker 19 DC motor		       ; 
;There are 5 pins assosiated with the clicker: In1, In2, In3, In4, Standby     ;
;We use mikro bus 2 for the clicker					       ;
;In1 = RA1, In2 = RD0, In3 = RG0, In4 = RB2, Standy = RD1		       ;
;The table of direction of motor motion is given in the datasheet	       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Motors_setup:
    bcf	    TRISD, PORTD_RD1_POSN, A	;Standby pin
    bcf	    TRISA, PORTA_RA1_POSN, A	;In1 pin
    bcf	    TRISD, PORTD_RD0_POSN, A	;In2 pin
    bcf	    TRISG, PORTG_RG0_POSN, A	;In3 pin
    bcf	    TRISB, PORTB_RB2_POSN, A	;In4 pin
    bsf	    PORTD, PORTD_RD1_POSN, A	;Make standby high
    return

Forward:
    bsf	    PORTA, PORTA_RA1_POSN, A	;Make In1 high
    bcf	    PORTD, PORTD_RD0_POSN, A	;Make In2 low
    bcf	    PORTG, PORTG_RG0_POSN, A	;Make In3 low
    bsf	    PORTB, PORTB_RB2_POSN, A	;Make In4 high
    return
    
Backward:
    bcf	    PORTA, PORTA_RA1_POSN, A	;Make In1 low
    bsf	    PORTD, PORTD_RD0_POSN, A	;Make In2 high
    bsf	    PORTG, PORTG_RG0_POSN, A	;Make In3 high
    bcf	    PORTB, PORTB_RB2_POSN, A	;Make In4 low
    return

Turn_left:
    bcf	    PORTA, PORTA_RA1_POSN, A	;Make In1 low
    bsf	    PORTD, PORTD_RD0_POSN, A	;Make In2 high
    bcf	    PORTG, PORTG_RG0_POSN, A	;Make In3 low
    bsf	    PORTB, PORTB_RB2_POSN, A	;Make In4 high
    return
    
Turn_right:
    bsf	    PORTA, PORTA_RA1_POSN, A	;Make In1 high
    bcf	    PORTD, PORTD_RD0_POSN, A	;Make In2 low
    bsf	    PORTG, PORTG_RG0_POSN, A	;Make In3 high
    bcf	    PORTB, PORTB_RB2_POSN, A	;Make In4 low
    return

Stop:
    bcf	    PORTA, PORTA_RA1_POSN, A	;Make In1 low
    bcf	    PORTD, PORTD_RD0_POSN, A	;Make In2 low
    bcf	    PORTG, PORTG_RG0_POSN, A	;Make In3 low
    bcf	    PORTB, PORTB_RB2_POSN, A	;Make In4 low
    return

Standby:
    bcf	    PORTD, PORTD_RD1_POSN, A	;Make standby low
    return
    
Start_motors:
    bsf	    PORTD, PORTD_RD1_POSN, A	;Make standby high
    return


