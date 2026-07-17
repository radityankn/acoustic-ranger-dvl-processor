v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 500 -250 550 -250 {lab=vref}
N 500 -310 550 -310 {lab=vbias}
N 460 -280 500 -280 {lab=in}
N 730 -280 780 -280 {lab=out}
N 610 -360 610 -330 {lab=vdd}
N 610 -230 610 -200 {lab=vss}
N 430 -190 430 -160 {lab=0}
N 430 -280 430 -250 {lab=in}
N 430 -280 460 -280 {lab=in}
N 90 -230 90 -190 {lab=0}
N 30 -230 30 -190 {lab=0}
N 90 -330 90 -290 {lab=vss}
N 30 -330 30 -290 {lab=vdd}
N 150 -230 150 -190 {lab=0}
N 150 -330 150 -290 {lab=vbias}
N 220 -230 220 -190 {lab=0}
N 220 -330 220 -290 {lab=vref}
C {BPF.sym} 610 -190 0 0 {name=x1}
C {lab_wire.sym} 610 -200 0 0 {name=p6 sig_type=std_logic lab=vss}
C {lab_wire.sym} 610 -360 0 0 {name=p1 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 770 -280 0 0 {name=p2 sig_type=std_logic lab=out}
C {lab_wire.sym} 480 -280 0 0 {name=p3 sig_type=std_logic lab=in}
C {lab_wire.sym} 510 -310 0 0 {name=p4 sig_type=std_logic lab=vbias}
C {lab_wire.sym} 510 -250 2 1 {name=p5 sig_type=std_logic lab=vref}
C {devices/code_shown.sym} 0 -80 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {devices/code_shown.sym} 0 -680 0 0 {name=NGSPICE1 only_toplevel=true
value="



.control
	
	*tran 10n 50u
	*plot v(in) v(out)

	*show m.xm10.m0 m.xm1.m0

	ac dec 50 1 10g
	plot db(v(out))
	plot ph(v(out))
	

.endc
"
}
C {gnd.sym} 430 -160 0 0 {name=l14 lab=0}
C {vsource.sym} 430 -220 0 0 {name=V3 value="ac 1" savecurrent=false}
C {vsource.sym} 30 -260 0 0 {name=V1 value=3.3 savecurrent=false}
C {vsource.sym} 90 -260 0 0 {name=V2 value=0 savecurrent=false}
C {gnd.sym} 90 -190 0 0 {name=l3 lab=0}
C {gnd.sym} 30 -190 0 0 {name=l4 lab=0}
C {lab_wire.sym} 30 -330 0 0 {name=p7 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 90 -330 0 0 {name=p8 sig_type=std_logic lab=vss}
C {vsource.sym} 150 -260 0 0 {name=V4 value=2.27 savecurrent=false}
C {gnd.sym} 150 -190 0 0 {name=l5 lab=0}
C {lab_wire.sym} 150 -330 0 0 {name=p9 sig_type=std_logic lab=vbias}
C {vsource.sym} 220 -260 0 0 {name=V5 value=1.65 savecurrent=false}
C {gnd.sym} 220 -190 0 0 {name=l7 lab=0}
C {lab_wire.sym} 220 -330 0 0 {name=p10 sig_type=std_logic lab=vref}
