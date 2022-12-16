#include <xc.inc>
    
extrn	CCP1_count
extrn	Motors_setup, Forward, Backward, Turn_left, Turn_right,Stop, Standby, Start_motors
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Reserve one byte for a threshold distance value			       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
psect	udata_acs
dist_cond:	ds 1

global	Ping_setup, Ping_send_signal, Ping_distance

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;This module includes following routines:				       ;
; - Setting up the PING and moving distance threshold value to dist_cond       ;
; - Sending a pulse to RE3 and making RE3 an input pin after		       ;
; - Checking the distance to the nearest object				       ;
;The pulse width sent is approx 5 us					       ;
;If CCP1_count < dist_cond: the nearest object is too close		       ;
;If CCP1_count > dist_cond: the nearest object is far enough		       ;
;0x04 value for dist_cond corresponds to 6.5 cm to the nearest object	       ;
;In the main routine call following routines in that specific order:	       ;
; - call	CCP_reset						       ;
; - call	Ping_send_signal					       ;
; - call	CCP_setup						       ;
; - call	Delay							       ;
; - call	Delay							       ;
; - call	Delay							       ;
; - call	Delay							       ;
; - call	Ping_distance						       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
psect	ping_code,class=CODE
    
Ping_setup:
    movlw	0x06			    ;Moving threshold condition to dist_cond
    movwf	dist_cond, A
    bcf		TRISC, PORTC_RC6_POSN, A    ;RC6 as output for debugging purposes
    return          

Ping_send_signal:
    bcf		TRISE, PORTE_RE3_POSN, A    ;RE3 output
    bcf		PORTE, PORTE_RE3_POSN, A    ;RE3 low
    bsf		PORTE, PORTE_RE3_POSN, A    ;RE3 high
    nop
    nop
    nop
    nop
    bcf		PORTE, PORTE_RE3_POSN, A    ;RE3 low
    bsf		TRISE, PORTE_RE3_POSN, A    ;RE3 input
    return
    
Ping_distance:
    movf	dist_cond, w, A
    cpfsgt	CCP1_count		    ;Compare CCP1_count with dist_cond, skip if >
    goto	stop_r
    goto	run_r			    ;CCP1_count < dist_cond

stop_r:
    call	Standby
    return
 
run_r:
    call	Start_motors
    return

end

