#include <xc.inc>

extrn	Motors_setup, Forward, Backward, Turn_left, Turn_right,Stop, Standby
global  Sens_setup,  Check_left, Check_right, Compare
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Reserve one byte for black condition value and white condition value	       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
psect	udata_acs
black_cond:	ds 1
air_cond:	ds 1
left_sensorH:	ds 1
right_sensorH:	ds 1
left_sensorL:	ds 1
right_sensorL:	ds 1
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;The code that is used for reflectrive sensors				       ;	
;The reflective sensors output voltage which magnitude is dependent on         ;
;reflectance								       ;
;Internal ADC is used to convert voltage magnitude to binary		       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
psect	sens_code, class=CODE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
;This section sets up ADC converters for pins AN2(RA2) and AN3(RA3)	       ;
;AN2 is connected to left sensot output					       ;	
;AN3 is connected to right sensor output				       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ADC_Setup1:
    movlw	00000100B		    ;Make AN2 analog pin
    movwf	ANCON0, A			    
    movlw	00001001B		    ;Enable ADC, use AN2, voltage references are Avss and AVdd
    movwf	ADCON0, A
    movlw	10110110B		    ;16 Tad, Fosc/64, right justified AD result
    movwf	ADCON1, A
    return
ADC_Setup2:
    movlw	00001000B		    ;Make AN3 analog pin
    movwf	ANCON0, A			    
    movlw	00001101B		    ;Enable ADC, use AN3, voltage references are Avss and AVdd
    movwf	ADCON0, A		    
    movlw	10110110B		    ;16 Tad, Fosc/64, right justified AD result
    movwf	ADCON1, A
    return
ADC_Read:
    bsf		ADCON0, 1, A		    ;Start conversion by setting GO bit in ADCON0
adc_loop:
    btfsc	ADCON0, 1, A		    ;Check to see if finished
    bra		adc_loop
    return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;This section checks the results of the ADC in ADRESH/ADRESL to determine      ;
;the colour of the surface - black, white or neither			       ;
;Before executing the project calibration must be done on sensors	       ;
;because they are very sensitive to distance (1 mm chnage can be significant)  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
Sens_setup:
    bsf		TRISA, PORTA_RA2_POSN, A	    ;Pin RA2==AN2 input
    bsf		TRISA, PORTA_RA3_POSN, A	    ;Pin RA3==AN3 input
    movlw	0x02			    ;Sensors output 0x02 if black surface 
    movwf	black_cond, A		   
    movlw	0x03			    ;Sensors output 0x03 or higher when air
    movwf	air_cond, A			    
    return
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Converting analogue to digital from the left sensor and storing values	       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Check_left:
    call	ADC_Setup1		    ;Setup ADC
    call	ADC_Read		    ;Turn on ADC
    movff	ADRESH, left_sensorH
    movff	ADRESL, left_sensorL
    return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Converting analogue to digital from the right sensor and storing values       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Check_right:
    call	ADC_Setup2		    ;Setup ADC
    call	ADC_Read		    ;Turn on ADC
    movff	ADRESH, right_sensorH
    movff	ADRESL, right_sensorL
    return
    
Compare:
    call	Forward
    movlw	0x02
    cpfsgt	left_sensorH
    call	Turn_right
    movlw	0x01
    cpfsgt	right_sensorH
    call	Turn_left
    return
    
    
   

    
    
    
    
    
    

    
end
