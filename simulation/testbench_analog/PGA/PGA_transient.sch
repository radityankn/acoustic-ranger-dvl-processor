v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 60 -400 60 -380 {lab=0}
N 130 -400 130 -380 {lab=0}
N 130 -490 130 -460 {lab=vss}
N 60 -490 60 -460 {lab=vdd}
N 60 -710 60 -690 {lab=0}
N 60 -560 60 -540 {lab=0}
N 60 -650 60 -620 {lab=in-}
N 60 -800 60 -770 {lab=in+}
N 640 -580 640 -560 {lab=vss}
N 640 -700 640 -680 {lab=vdd}
N 660 -590 660 -580 {lab=vbias}
N 540 -730 580 -730 {lab=#net1}
N 580 -730 600 -730 {lab=#net1}
N 420 -730 480 -730 {lab=in+}
N 190 -400 190 -380 {lab=0}
N 190 -490 190 -460 {lab=vref}
N 530 -610 530 -590 {lab=#net2}
N 530 -530 530 -490 {lab=vref}
N 510 -610 530 -610 {lab=#net2}
N 420 -610 450 -610 {lab=in-}
N 660 -580 660 -560 {lab=vbias}
N 660 -560 700 -560 {lab=vbias}
N 260 -490 260 -460 {lab=vbias}
N 260 -400 260 -380 {lab=0}
N 60 -210 60 -190 {lab=0}
N 60 -300 60 -270 {lab=2}
N 240 -210 240 -190 {lab=0}
N 240 -300 240 -270 {lab=10}
N 420 -210 420 -190 {lab=0}
N 420 -300 420 -270 {lab=50}
N 600 -930 600 -730 {lab=#net1}
N 680 -630 840 -630 {lab=out}
N 760 -930 760 -630 {lab=out}
N 560 -900 620 -900 {lab=50}
N 560 -880 620 -880 {lab=10}
N 560 -860 620 -860 {lab=2}
N 680 -990 680 -970 {lab=vdd}
N 680 -830 680 -810 {lab=vss}
N 530 -650 530 -610 {lab=#net2}
N 530 -650 600 -650 {lab=#net2}
N 560 -610 600 -610 {lab=#net1}
N 560 -730 560 -610 {lab=#net1}
C {vsource.sym} 60 -430 0 0 {name=V5 value=3.3 savecurrent=false}
C {vsource.sym} 130 -430 0 0 {name=V6 value=0 savecurrent=false}
C {gnd.sym} 130 -380 0 0 {name=l9 lab=0}
C {gnd.sym} 60 -380 0 0 {name=l10 lab=0}
C {lab_wire.sym} 60 -490 0 0 {name=p27 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 130 -490 0 0 {name=p28 sig_type=std_logic lab=vss}
C {gnd.sym} 60 -540 0 0 {name=l1 lab=0}
C {gnd.sym} 60 -690 0 0 {name=l2 lab=0}
C {lab_wire.sym} 60 -800 0 0 {name=p6 sig_type=std_logic lab=in+}
C {lab_wire.sym} 60 -650 0 0 {name=p7 sig_type=std_logic lab=in-}
C {vsource.sym} 60 -590 0 0 {name=V8 value="sin(1.65 0.02 250k 0 0 0)" savecurrent=false}
C {vsource.sym} 60 -740 0 0 {name=V1 value="sin(1.65 0.01 250k 0 0 180)" savecurrent=false}
C {res.sym} 510 -730 1 1 {name=R1
value=1k
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 640 -560 0 0 {name=p4 sig_type=std_logic lab=vss}
C {lab_wire.sym} 640 -700 0 0 {name=p5 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 810 -630 0 0 {name=p9 sig_type=std_logic lab=out}
C {lab_wire.sym} 440 -730 2 1 {name=p10 sig_type=std_logic lab=in+}
C {vsource.sym} 190 -430 0 0 {name=V2 value=1.65 savecurrent=false}
C {gnd.sym} 190 -380 0 0 {name=l3 lab=0}
C {lab_wire.sym} 190 -490 0 0 {name=p1 sig_type=std_logic lab=vref}
C {lab_wire.sym} 530 -500 2 1 {name=p2 sig_type=std_logic lab=vref}
C {res.sym} 530 -560 2 1 {name=R3
value=5k
footprint=1206
device=resistor
m=1}
C {res.sym} 480 -610 1 1 {name=R4
value=1k
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 430 -610 2 1 {name=p3 sig_type=std_logic lab=in-}
C {vsource.sym} 260 -430 0 0 {name=V3 value=2.27 savecurrent=false}
C {lab_wire.sym} 260 -490 0 0 {name=p8 sig_type=std_logic lab=vbias}
C {gnd.sym} 260 -380 0 0 {name=l4 lab=0}
C {lab_wire.sym} 700 -560 0 0 {name=p11 sig_type=std_logic lab=vbias}
C {acoustic_ranger_2026/two-stage_miller_OTA.sym} 650 -580 0 0 {name=x1}
C {devices/code_shown.sym} 20 -1280 0 0 {name=NGSPICE1 only_toplevel=true
value="



.control
	
	tran 100n 90u
	plot v(in+) v(in-) v(out)
	
	*plot v(2) 
	*plot v(10) 
	*plot v(50) 
	*plot v(8)
 

	*show m.xm7.m0 m.xm6.m0

	*ac dec 20 1 1g
	*plot db(v(out)/v(in-))
	*plot (180/3.14159) * cph(v(out)/v(in-))
	

.endc
"
}
C {devices/code_shown.sym} 30 -80 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {vsource.sym} 60 -240 0 0 {name=V4 value="pulse(0 3.3 0 1n 1n 30u 100u)" savecurrent=false}
C {gnd.sym} 60 -190 0 0 {name=l5 lab=0}
C {lab_wire.sym} 60 -300 0 0 {name=p12 sig_type=std_logic lab=2}
C {vsource.sym} 240 -240 0 0 {name=V7 value="pulse(0 3.3 30u 1n 1n 30u 100u)" savecurrent=false}
C {gnd.sym} 240 -190 0 0 {name=l6 lab=0}
C {lab_wire.sym} 240 -300 0 0 {name=p13 sig_type=std_logic lab=10}
C {vsource.sym} 420 -240 0 0 {name=V9 value="pulse(0 3.3 60u 1n 1n 30u 100u)" savecurrent=false}
C {gnd.sym} 420 -190 0 0 {name=l7 lab=0}
C {lab_wire.sym} 420 -300 0 0 {name=p14 sig_type=std_logic lab=50}
C {Binary_Resistor_Bank.sym} 720 -810 0 0 {name=x2}
C {lab_wire.sym} 580 -900 0 0 {name=p15 sig_type=std_logic lab=50}
C {lab_wire.sym} 580 -880 0 0 {name=p16 sig_type=std_logic lab=10}
C {lab_wire.sym} 580 -860 0 0 {name=p17 sig_type=std_logic lab=2}
C {lab_wire.sym} 680 -990 0 0 {name=p18 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 680 -810 0 0 {name=p19 sig_type=std_logic lab=vss}
