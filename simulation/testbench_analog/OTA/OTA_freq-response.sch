v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 140 -250 140 -230 {lab=0}
N 140 -340 140 -310 {lab=in+}
N 190 -250 190 -230 {lab=0}
N 190 -340 190 -310 {lab=vdd}
N 240 -250 240 -230 {lab=0}
N 240 -340 240 -310 {lab=vss}
N 660 -260 660 -220 {lab=vss}
N 660 -400 660 -360 {lab=vdd}
N 700 -310 720 -310 {lab=out}
N 600 -440 720 -440 {lab=in-}
N 600 -330 620 -330 {lab=in+}
N 720 -310 800 -310 {lab=out}
N 800 -330 800 -310 {lab=out}
N 800 -310 800 -290 {lab=out}
N 800 -230 800 -200 {lab=vss}
N 660 -200 800 -200 {lab=vss}
N 660 -220 660 -200 {lab=vss}
N 720 -440 800 -440 {lab=in-}
N 800 -440 800 -390 {lab=in-}
N 600 -290 620 -290 {lab=in-}
N 680 -270 680 -240 {lab=vbias}
N 680 -240 750 -240 {lab=vbias}
N 570 -290 600 -290 {lab=in-}
N 570 -440 570 -290 {lab=in-}
N 570 -440 600 -440 {lab=in-}
N 400 -270 430 -270 {lab=vbias}
N 340 -340 340 -320 {lab=vdd}
N 340 -200 340 -180 {lab=vss}
C {vsource.sym} 140 -280 0 0 {name=V3 value=1.65 savecurrent=false}
C {gnd.sym} 140 -230 0 0 {name=l4 lab=0}
C {lab_wire.sym} 140 -340 0 0 {name=p3 sig_type=std_logic lab=in+}
C {vsource.sym} 190 -280 0 0 {name=V1 value=3.3 savecurrent=false}
C {gnd.sym} 190 -230 0 0 {name=l1 lab=0}
C {lab_wire.sym} 190 -340 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {vsource.sym} 240 -280 0 0 {name=V2 value=0 savecurrent=false}
C {gnd.sym} 240 -230 0 0 {name=l2 lab=0}
C {lab_wire.sym} 240 -340 0 0 {name=p5 sig_type=std_logic lab=vss}
C {devices/code_shown.sym} 10 -700 0 0 {name=NGSPICE1 only_toplevel=true
value="



.control
	
	*tran 1u 1m
	*plot v(net2) v(net4) v(net5) v(in-) 
	*plot v(net2) v(net3)

	*show m.xm1.m0 m.xm2.m0

	ac dec 20 1 1g
	plot db(v(out)/v(in-))
	plot (180/3.14159) * cph(v(out)/v(in-))
	

.endc
"
}
C {devices/code_shown.sym} 10 -80 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice fs
"}
C {acoustic_ranger_2026/two-stage_miller_OTA.sym} 670 -260 0 0 {name=x1}
C {lab_wire.sym} 770 -200 0 0 {name=p1 sig_type=std_logic lab=vss}
C {lab_wire.sym} 660 -400 0 0 {name=p2 sig_type=std_logic lab=vdd}
C {vsource.sym} 800 -360 0 0 {name=V4 value="ac 1" savecurrent=false}
C {lab_wire.sym} 600 -290 0 0 {name=p6 sig_type=std_logic lab=in-}
C {lab_wire.sym} 600 -330 0 0 {name=p7 sig_type=std_logic lab=in+}
C {lab_wire.sym} 760 -310 0 0 {name=p8 sig_type=std_logic lab=out}
C {capa.sym} 800 -260 0 0 {name=C1
m=1
value=500f
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 740 -240 0 0 {name=p10 sig_type=std_logic lab=vbias}
C {lab_wire.sym} 420 -270 0 1 {name=p11 sig_type=std_logic lab=vbias}
C {acoustic-ranger-dvl-processor/design/analog/beta multiplier/beta_multiplier.sym} 160 -140 0 0 {name=x7}
C {lab_wire.sym} 340 -340 0 0 {name=p12 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 340 -180 0 0 {name=p13 sig_type=std_logic lab=vss}
