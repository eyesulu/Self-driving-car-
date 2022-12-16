#include <xc.inc>

extrn	Sens_setup,  Check_left, Check_right, Compare
extrn	Motors_setup, Forward, Backward, Turn_left, Turn_right,Stop, Standby
extrn	CCP_setup, CCP_Int , CCP_reset, CCP1_count
extrn	Ping_setup, Ping_send_signal, Ping_distance
extrn	Delay

    
psect udata_acs
inst:	ds 1
psect	code, abs
	
rst: 	org	0x0
 	goto	setup
	
int_high:
	org	0x0008
	goto	CCP_Int
	
setup: 
	call	Motors_setup
	call	Sens_setup
	call	Ping_setup
	bcf	TRISG, PORTG_RG4_POSN
	call	Stop
	goto	main

main:	
	btfsc	PORTG, PORTG_RG4_POSN
	goto	Autopilot
	;btfsc	PORTC, PORTC_RC1_POSN
	;goto	Manual
	goto	main
	
Manual:
	btfsc	PORTH, PORTH_RH0_POSN
	call	Forward
	btfsc	PORTA, PORTA_RA4_POSN
	call	Backward
	btfsc	PORTJ, PORTJ_RJ7_POSN
	call	Turn_left
	btfsc	PORTJ, PORTJ_RJ6_POSN
	call	Turn_right
	btfsc	PORTJ, PORTJ_RJ4_POSN
	call	Stop
	goto	main
	
Autopilot:
	call	Check_left
	call	Check_right
	call	Compare
	call	CCP_reset
	call	Ping_send_signal
	call	CCP_setup
	call	Delay
	call	Delay
	call	Delay
	call	Delay
	call	Ping_distance
	goto	main

Pins:
	bcf	TRISG, PORTG_RG4_POSN	    ;IO1 - Autopilot
	bcf	TRISC, PORTC_RC1_POSN	    ;IO2 - Manual
	bcf	TRISH, PORTH_RH0_POSN	    ;IO3 - Forward
	bcf	TRISA, PORTA_RA4_POSN	    ;IO4 - Reverse
	bcf	TRISJ, PORTJ_RJ7_POSN	    ;IO5 - Turn left
	bcf	TRISJ, PORTJ_RJ6_POSN	    ;IO6 - Turn right
	bcf	TRISJ, PORTJ_RJ4_POSN	    ;IO7 - Stop
	return

end
	


