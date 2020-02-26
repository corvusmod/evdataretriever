#!/bin/bash


JSON=/tmp/caninfo


function cansend {

    mosquitto_pub -h 13.59.237.93 -u evdatar -P evMosquito -t caninfo -m "$caninfo" 2>/dev/null

}


function getmode {

    modetemp=`candump vcan0,0x240:0x7FF -n1 |cut -f10 -d" "`

    case $modetemp in

        85)

            mode="Sport"

            ;;

        89)

            mode="Eco"

            ;;

        91)

            mode="Custom"

            ;;

        *)

            mode="Unknown"

            ;;

    esac

}


function getspeed { 

    speedA=`candump vcan0,0x240:0x7FF -n1 |cut -f12 -d" "`

    speedB=`candump vcan0,0x240:0x7FF -n1 |cut -f13 -d" "`

    speedAdec=$(( 16#$speedA ))

    speedBdec=$(( 16#$speedB ))

    speedBtemp=$(( $speedBdec*256 ))

    speedAB=$(( $speedAdec+$speedBtemp ))

    speed=$(( $speedAB/100 ))

}


function getmotortemp { # en hex

    mtemphex=`candump vcan0,0x281:0x7FF -n1 |cut -f16 -d" "`

    mtemp=$(( 16#$mtemphex ))

}


function getbatt { #en hex

    batthex=`candump vcan0,0x240:0x7FF -n1 |cut -f16 -d" "`

    batt=$(( 16#$batthex ))

}


function getcontroltemp { # en hex

    controltemphex=`candump vcan0,0x381:0x7FF -n1 |cut -f12 -d" "`

    controltemp=$(( 16#$mtemphex ))

}


function getrpm { 

    rpmA=`candump vcan0,0x340:0x7FF -n1 |cut -f14 -d" "`

    rpmB=`candump vcan0,0x340:0x7FF -n1 |cut -f15 -d" "`

    rpmAdec=$(( 16#$rpmA ))

    rpmBdec=$(( 16#$rpmB ))

    rpmBtemp=$(( $rpmBdec*256 ))

    rpms=$(( $rpmAdec+$rpmBtemp ))

}


function getparked {

    parkedtemp=`candump vcan0,0x340:0x7FF -n1 |cut -f16 -d" "`

    case $parkedtemp in

        2C)

            parked="Parked - KillSwitch ON"

            ;;

        2D)

            parked="Parked - KickStand Down"

            ;;

        *)

            parked="Not parked"

            ;;

    esac

}


function getrange {

    rangeA=`candump vcan0,0x440:0x7FF -n1 |cut -f14 -d" "`

    rangeB=`candump vcan0,0x440:0x7FF -n1 |cut -f15 -d" "`

    rangeAdec=$(( 16#$speedA ))

    rangeBdec=$(( 16#$speedB ))

    rangeBtemp=$(( $speedBdec*256 ))

    rangeAB=$(( $speedAdec+$speedBtemp ))

    range=$(( $speedAB/100 ))

}



#Get data


getmode

getspeed

getmotortemp

getbatt

getcontroltemp

getrpm

getparked

getrange


#Create json with data

caninfo=`echo -e "{\n \"mode\": \"$mode\",\n \"speed\": $speed,\n \"mtemp\": $mtemp,\n \"batt\": $batt,\n \"controltemp\": $controltemp,\n \"rpms\": $rpms,\n \"parked\": \"$parked\",\n \"range\": $range\n}"`

echo $caninfo

cansend
