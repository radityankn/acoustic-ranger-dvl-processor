v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 30 -400 30 -380 {lab=0}
N 100 -400 100 -380 {lab=0}
N 100 -490 100 -460 {lab=vss}
N 30 -490 30 -460 {lab=vdd}
N 640 -230 640 -210 {lab=vss}
N 640 -350 640 -330 {lab=vdd}
N 660 -240 660 -230 {lab=vbias}
N 540 -380 580 -380 {lab=#net1}
N 580 -380 600 -380 {lab=#net1}
N 420 -380 480 -380 {lab=in+}
N 160 -400 160 -380 {lab=0}
N 160 -490 160 -460 {lab=vref}
N 530 -260 530 -240 {lab=#net2}
N 530 -180 530 -140 {lab=vref}
N 510 -260 530 -260 {lab=#net2}
N 420 -260 450 -260 {lab=in-}
N 660 -230 660 -210 {lab=vbias}
N 660 -210 700 -210 {lab=vbias}
N 230 -490 230 -460 {lab=vbias}
N 230 -400 230 -380 {lab=0}
N 600 -580 600 -380 {lab=#net1}
N 680 -280 840 -280 {lab=out50}
N 760 -580 760 -280 {lab=out50}
N 560 -550 620 -550 {lab=vdd}
N 560 -530 620 -530 {lab=vss}
N 560 -510 620 -510 {lab=vss}
N 680 -640 680 -620 {lab=vdd}
N 680 -480 680 -460 {lab=vss}
N 530 -300 530 -260 {lab=#net2}
N 530 -300 600 -300 {lab=#net2}
N 560 -260 600 -260 {lab=#net1}
N 560 -380 560 -260 {lab=#net1}
N 1100 -230 1100 -210 {lab=vss}
N 1100 -350 1100 -330 {lab=vdd}
N 1120 -240 1120 -230 {lab=vbias}
N 1000 -380 1040 -380 {lab=#net3}
N 1040 -380 1060 -380 {lab=#net3}
N 880 -380 940 -380 {lab=in+}
N 990 -260 990 -240 {lab=#net4}
N 990 -180 990 -140 {lab=vref}
N 970 -260 990 -260 {lab=#net4}
N 880 -260 910 -260 {lab=in-}
N 1120 -230 1120 -210 {lab=vbias}
N 1120 -210 1160 -210 {lab=vbias}
N 1060 -580 1060 -380 {lab=#net3}
N 1140 -280 1300 -280 {lab=out10}
N 1220 -580 1220 -280 {lab=out10}
N 1020 -550 1080 -550 {lab=vss}
N 1020 -530 1080 -530 {lab=vdd}
N 1020 -510 1080 -510 {lab=vss}
N 1140 -640 1140 -620 {lab=vdd}
N 1140 -480 1140 -460 {lab=vss}
N 990 -300 990 -260 {lab=#net4}
N 990 -300 1060 -300 {lab=#net4}
N 1020 -260 1060 -260 {lab=#net3}
N 1020 -380 1020 -260 {lab=#net3}
N 1560 -230 1560 -210 {lab=vss}
N 1560 -350 1560 -330 {lab=vdd}
N 1580 -240 1580 -230 {lab=vbias}
N 1460 -380 1500 -380 {lab=#net5}
N 1500 -380 1520 -380 {lab=#net5}
N 1340 -380 1400 -380 {lab=in+}
N 1450 -260 1450 -240 {lab=#net6}
N 1450 -180 1450 -140 {lab=vref}
N 1430 -260 1450 -260 {lab=#net6}
N 1340 -260 1370 -260 {lab=in-}
N 1580 -230 1580 -210 {lab=vbias}
N 1580 -210 1620 -210 {lab=vbias}
N 1520 -580 1520 -380 {lab=#net5}
N 1600 -280 1760 -280 {lab=out2}
N 1680 -580 1680 -280 {lab=out2}
N 1480 -550 1540 -550 {lab=vss}
N 1480 -530 1540 -530 {lab=vss}
N 1480 -510 1540 -510 {lab=vdd}
N 1600 -640 1600 -620 {lab=vdd}
N 1600 -480 1600 -460 {lab=vss}
N 1450 -300 1450 -260 {lab=#net6}
N 1450 -300 1520 -300 {lab=#net6}
N 1480 -260 1520 -260 {lab=#net5}
N 1480 -380 1480 -260 {lab=#net5}
N 40 -750 40 -730 {lab=0}
N 40 -600 40 -580 {lab=0}
N 40 -690 40 -660 {lab=in-}
N 40 -840 40 -810 {lab=in+}
C {vsource.sym} 30 -430 0 0 {name=V5 value=3.3 savecurrent=false}
C {vsource.sym} 100 -430 0 0 {name=V6 value=0 savecurrent=false}
C {gnd.sym} 100 -380 0 0 {name=l9 lab=0}
C {gnd.sym} 30 -380 0 0 {name=l10 lab=0}
C {lab_wire.sym} 30 -490 0 0 {name=p27 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 100 -490 0 0 {name=p28 sig_type=std_logic lab=vss}
C {vsource.sym} 40 -630 0 0 {name=V8 value="dc 1.65 ac -0.5" savecurrent=false}
C {vsource.sym} 40 -780 0 0 {name=V1 value="dc 1.65 ac 0.5" savecurrent=false}
C {res.sym} 510 -380 1 1 {name=R1
value=1k
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 640 -210 0 0 {name=p4 sig_type=std_logic lab=vss}
C {lab_wire.sym} 640 -350 0 0 {name=p5 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 810 -280 0 0 {name=p9 sig_type=std_logic lab=out50}
C {lab_wire.sym} 440 -380 2 1 {name=p10 sig_type=std_logic lab=in+}
C {vsource.sym} 160 -430 0 0 {name=V2 value=1.65 savecurrent=false}
C {gnd.sym} 160 -380 0 0 {name=l3 lab=0}
C {lab_wire.sym} 160 -490 0 0 {name=p1 sig_type=std_logic lab=vref}
C {lab_wire.sym} 530 -150 2 1 {name=p2 sig_type=std_logic lab=vref}
C {res.sym} 530 -210 2 1 {name=R3
value=5k
footprint=1206
device=resistor
m=1}
C {res.sym} 480 -260 1 1 {name=R4
value=1k
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 430 -260 2 1 {name=p3 sig_type=std_logic lab=in-}
C {vsource.sym} 230 -430 0 0 {name=V3 value=2.27 savecurrent=false}
C {lab_wire.sym} 230 -490 0 0 {name=p8 sig_type=std_logic lab=vbias}
C {gnd.sym} 230 -380 0 0 {name=l4 lab=0}
C {lab_wire.sym} 700 -210 0 0 {name=p11 sig_type=std_logic lab=vbias}
C {acoustic_ranger_2026/two-stage_miller_OTA.sym} 650 -230 0 0 {name=x1}
C {devices/code_shown.sym} 280 -1080 0 0 {name=NGSPICE1 only_toplevel=true
value="



.control
	
	*tran 10n 50u
	*plot v(in+) v(in-) v(out2) v(out10) v(out50)
	
	*plot v(2) 
	*plot v(10) 
	*plot v(50) 
	*plot v(8)
 

	*show m.xm7.m0 m.xm6.m0

	ac dec 20 1 1g
	plot db(v(out2)) db(v(out10)) db(v(out50))
	plot ph(v(out2)) ph(v(out10)) ph(v(out50))
	

.endc
"
}
C {devices/code_shown.sym} 0 -80 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {Binary_Resistor_Bank.sym} 720 -460 0 0 {name=x2}
C {lab_wire.sym} 680 -640 0 0 {name=p18 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 680 -460 0 0 {name=p19 sig_type=std_logic lab=vss}
C {lab_wire.sym} 560 -550 0 0 {name=p12 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 560 -530 0 0 {name=p13 sig_type=std_logic lab=vss}
C {lab_wire.sym} 560 -510 0 0 {name=p14 sig_type=std_logic lab=vss}
C {res.sym} 970 -380 1 1 {name=R2
value=1k
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 1100 -210 0 0 {name=p15 sig_type=std_logic lab=vss}
C {lab_wire.sym} 1100 -350 0 0 {name=p16 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1270 -280 0 0 {name=p17 sig_type=std_logic lab=out10}
C {lab_wire.sym} 900 -380 2 1 {name=p20 sig_type=std_logic lab=in+}
C {lab_wire.sym} 990 -150 2 1 {name=p21 sig_type=std_logic lab=vref}
C {res.sym} 990 -210 2 1 {name=R5
value=5k
footprint=1206
device=resistor
m=1}
C {res.sym} 940 -260 1 1 {name=R6
value=1k
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 890 -260 2 1 {name=p22 sig_type=std_logic lab=in-}
C {lab_wire.sym} 1160 -210 0 0 {name=p23 sig_type=std_logic lab=vbias}
C {acoustic_ranger_2026/two-stage_miller_OTA.sym} 1110 -230 0 0 {name=x3}
C {Binary_Resistor_Bank.sym} 1180 -460 0 0 {name=x4}
C {lab_wire.sym} 1140 -640 0 0 {name=p24 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1140 -460 0 0 {name=p25 sig_type=std_logic lab=vss}
C {lab_wire.sym} 1020 -530 0 0 {name=p26 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1020 -550 0 0 {name=p29 sig_type=std_logic lab=vss}
C {lab_wire.sym} 1020 -510 0 0 {name=p30 sig_type=std_logic lab=vss}
C {res.sym} 1430 -380 1 1 {name=R7
value=1k
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 1560 -210 0 0 {name=p31 sig_type=std_logic lab=vss}
C {lab_wire.sym} 1560 -350 0 0 {name=p32 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1730 -280 0 0 {name=p33 sig_type=std_logic lab=out2}
C {lab_wire.sym} 1360 -380 2 1 {name=p34 sig_type=std_logic lab=in+}
C {lab_wire.sym} 1450 -150 2 1 {name=p35 sig_type=std_logic lab=vref}
C {res.sym} 1450 -210 2 1 {name=R8
value=5k
footprint=1206
device=resistor
m=1}
C {res.sym} 1400 -260 1 1 {name=R9
value=1k
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 1350 -260 2 1 {name=p36 sig_type=std_logic lab=in-}
C {lab_wire.sym} 1620 -210 0 0 {name=p37 sig_type=std_logic lab=vbias}
C {acoustic_ranger_2026/two-stage_miller_OTA.sym} 1570 -230 0 0 {name=x5}
C {Binary_Resistor_Bank.sym} 1640 -460 0 0 {name=x6}
C {lab_wire.sym} 1600 -640 0 0 {name=p38 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1600 -460 0 0 {name=p39 sig_type=std_logic lab=vss}
C {lab_wire.sym} 1480 -510 0 0 {name=p40 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1480 -550 0 0 {name=p41 sig_type=std_logic lab=vss}
C {lab_wire.sym} 1480 -530 0 0 {name=p42 sig_type=std_logic lab=vss}
C {gnd.sym} 40 -580 0 0 {name=l5 lab=0}
C {gnd.sym} 40 -730 0 0 {name=l6 lab=0}
C {lab_wire.sym} 40 -840 0 0 {name=p43 sig_type=std_logic lab=in+}
C {lab_wire.sym} 40 -690 0 0 {name=p44 sig_type=std_logic lab=in-}
