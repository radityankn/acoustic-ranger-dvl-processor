v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 280 -240 280 -220 {lab=0}
N 280 -330 280 -300 {lab=vdd}
N 330 -240 330 -220 {lab=0}
N 330 -330 330 -300 {lab=vss}
N 560 -270 590 -270 {lab=vss}
N 590 -390 630 -390 {lab=vdd}
N 590 -270 630 -270 {lab=vss}
N 710 -330 740 -330 {lab=out}
N 500 -390 590 -390 {lab=vdd}
N 740 -330 760 -330 {lab=out}
N 630 -270 760 -270 {lab=vss}
N 220 -240 220 -220 {lab=0}
N 220 -330 220 -300 {lab=in}
N 500 -330 550 -330 {lab=in}
C {Transmission_Gate.sym} 650 -210 0 0 {name=x1}
C {vsource.sym} 280 -270 0 0 {name=V1 value=3.3 savecurrent=false}
C {gnd.sym} 280 -220 0 0 {name=l1 lab=0}
C {lab_wire.sym} 280 -330 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {vsource.sym} 330 -270 0 0 {name=V2 value=0 savecurrent=false}
C {gnd.sym} 330 -220 0 0 {name=l2 lab=0}
C {lab_wire.sym} 330 -330 0 0 {name=p5 sig_type=std_logic lab=vss}
C {lab_wire.sym} 560 -270 0 0 {name=p1 sig_type=std_logic lab=vss}
C {lab_wire.sym} 500 -390 0 0 {name=p2 sig_type=std_logic lab=vdd}
C {vsource.sym} 220 -270 0 0 {name=V3 value="ac 1" savecurrent=false}
C {gnd.sym} 220 -220 0 0 {name=l3 lab=0}
C {lab_wire.sym} 220 -330 0 0 {name=p7 sig_type=std_logic lab=in}
C {lab_wire.sym} 500 -330 0 0 {name=p8 sig_type=std_logic lab=in}
C {devices/code_shown.sym} 0 -70 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {devices/code_shown.sym} 0 -670 0 0 {name=NGSPICE1 only_toplevel=true
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
C {lab_wire.sym} 760 -330 0 0 {name=p3 sig_type=std_logic lab=out}
