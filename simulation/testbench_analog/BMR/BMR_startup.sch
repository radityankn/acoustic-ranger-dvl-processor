v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 90 -210 90 -190 {lab=0}
N 90 -300 90 -270 {lab=vdd1}
N 30 -210 30 -190 {lab=0}
N 30 -300 30 -270 {lab=vin}
N 170 -510 250 -510 {lab=nbias_real}
N 130 -510 130 -480 {lab=vss}
N 170 -730 250 -730 {lab=pbias_real}
N 290 -580 290 -540 {lab=pbias_real}
N 130 -580 130 -540 {lab=nbias_real}
N 210 -680 290 -680 {lab=pbias_real}
N 210 -730 210 -680 {lab=pbias_real}
N 210 -560 210 -510 {lab=nbias_real}
N 130 -560 210 -560 {lab=nbias_real}
N 130 -700 130 -680 {lab=nbias_real}
N 290 -700 290 -680 {lab=pbias_real}
N 290 -760 290 -730 {lab=vdd1}
N 130 -760 130 -730 {lab=vdd1}
N 130 -480 130 -380 {lab=vss}
N 130 -380 290 -380 {lab=vss}
N 290 -480 290 -460 {lab=#net1}
N 290 -400 290 -380 {lab=vss}
N 290 -780 290 -760 {lab=vdd1}
N 130 -780 290 -780 {lab=vdd1}
N 130 -780 130 -760 {lab=vdd1}
N 290 -680 290 -580 {lab=pbias_real}
N 130 -680 130 -580 {lab=nbias_real}
N 290 -510 290 -480 {lab=#net1}
N 30 -60 30 -40 {lab=0}
N 30 -150 30 -120 {lab=vdd2}
N 90 -60 90 -40 {lab=0}
N 90 -150 90 -120 {lab=vss}
N 1200 -680 1300 -680 {lab=pbias_target}
N 1080 -510 1160 -510 {lab=nbias_target}
N 1040 -510 1040 -480 {lab=vss}
N 1080 -730 1160 -730 {lab=pbias_target}
N 1200 -580 1200 -540 {lab=pbias_target}
N 1040 -580 1040 -540 {lab=nbias_target}
N 1120 -680 1200 -680 {lab=pbias_target}
N 1120 -730 1120 -680 {lab=pbias_target}
N 1120 -560 1120 -510 {lab=nbias_target}
N 1040 -560 1120 -560 {lab=nbias_target}
N 1040 -700 1040 -680 {lab=nbias_target}
N 1200 -700 1200 -680 {lab=pbias_target}
N 1200 -760 1200 -730 {lab=vdd2}
N 1040 -760 1040 -730 {lab=vdd2}
N 1040 -480 1040 -380 {lab=vss}
N 1040 -380 1200 -380 {lab=vss}
N 1200 -480 1200 -460 {lab=#net2}
N 1200 -400 1200 -380 {lab=vss}
N 1200 -780 1200 -760 {lab=vdd2}
N 1040 -780 1200 -780 {lab=vdd2}
N 1040 -780 1040 -760 {lab=vdd2}
N 1200 -680 1200 -580 {lab=pbias_target}
N 1040 -680 1040 -580 {lab=nbias_target}
N 1200 -510 1200 -480 {lab=#net2}
N 1120 -560 1300 -560 {lab=nbias_target}
N 1300 -560 1380 -560 {lab=nbias_target}
N 410 -430 410 -400 {lab=vss}
N 450 -430 490 -430 {lab=pulse}
N 150 -60 150 -40 {lab=0}
N 150 -150 150 -120 {lab=pulse}
N 410 -400 410 -380 {lab=vss}
N 410 -540 410 -460 {lab=pbias_real}
N 290 -540 410 -540 {lab=pbias_real}
N 290 -380 410 -380 {lab=vss}
N 520 -560 520 -450 {lab=nbias_real}
N 560 -590 560 -480 {lab=#net3}
N 560 -780 560 -650 {lab=vdd1}
N 560 -450 560 -420 {lab=vss}
N 560 -420 560 -380 {lab=vss}
N 410 -380 560 -380 {lab=vss}
N 290 -780 560 -780 {lab=vdd1}
N 720 -530 720 -510 {lab=feedback}
N 720 -520 820 -520 {lab=feedback}
N 680 -560 680 -480 {lab=#net3}
N 720 -480 720 -450 {lab=vss}
N 720 -590 720 -560 {lab=vdd1}
N 720 -620 720 -590 {lab=vdd1}
N 720 -450 720 -420 {lab=vss}
N 210 -560 520 -560 {lab=nbias_real}
N 560 -520 680 -520 {lab=#net3}
C {vsource.sym} 90 -240 0 0 {name=V1 value="PWL( 0 0 10u 0 10.5u 3.3)" savecurrent=false}
C {gnd.sym} 90 -190 0 0 {name=l1 lab=0}
C {lab_wire.sym} 90 -300 0 0 {name=p5 sig_type=std_logic lab=vdd1}
C {vsource.sym} 30 -240 0 0 {name=V3 value=1.65 savecurrent=false}
C {gnd.sym} 30 -190 0 0 {name=l3 lab=0}
C {lab_wire.sym} 30 -300 0 0 {name=p7 sig_type=std_logic lab=vin}
C {devices/code_shown.sym} 390 -80 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice fs
"}
C {devices/code_shown.sym} 50 -1130 0 0 {name=NGSPICE1 only_toplevel=true
value="



.control
	
	tran 100n 100u
	
	*plot v(vdd1)
	plot v(nbias_target) v(nbias_real) v(pbias_target) v(pbias_real)
	

	

.endc
"
}
C {opin.sym} 290 -660 0 1 {name=p3 lab=pbias_real}
C {opin.sym} 130 -580 0 0 {name=p4 lab=nbias_real}
C {symbols/nfet_03v3.sym} 270 -510 0 0 {name=M6
L=30u
W=51.28u
nf=1
m=3
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 150 -510 0 1 {name=M7
L=30u
W=22.22u
nf=1
m=3
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 270 -730 0 0 {name=M8
L=30u
W=52.08u
nf=1
m=6
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 150 -730 0 1 {name=M9
L=30u
W=52.08u
nf=1
m=6
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {res.sym} 290 -430 0 0 {name=R2
value=10k
footprint=1206
device=resistor
m=1}
C {vsource.sym} 30 -90 0 0 {name=V4 value=3.3 savecurrent=false}
C {gnd.sym} 30 -40 0 0 {name=l4 lab=0}
C {lab_wire.sym} 30 -150 0 0 {name=p10 sig_type=std_logic lab=vdd2}
C {vsource.sym} 90 -90 0 0 {name=V5 value=0 savecurrent=false}
C {gnd.sym} 90 -40 0 0 {name=l5 lab=0}
C {lab_wire.sym} 90 -150 0 0 {name=p11 sig_type=std_logic lab=vss}
C {opin.sym} 1300 -680 0 0 {name=p13 lab=pbias_target}
C {opin.sym} 1380 -560 0 0 {name=p14 lab=nbias_target}
C {symbols/nfet_03v3.sym} 1180 -510 0 0 {name=M1
L=30u
W=51.28u
nf=1
m=3
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 1060 -510 0 1 {name=M2
L=30u
W=22.22u
nf=1
m=3
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 1180 -730 0 0 {name=M3
L=30u
W=52.08u
nf=1
m=6
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 1060 -730 0 1 {name=M4
L=30u
W=52.08u
nf=1
m=6
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {res.sym} 1200 -430 0 0 {name=R1
value=10k
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 1150 -380 0 0 {name=p15 sig_type=std_logic lab=vss}
C {symbols/nfet_03v3.sym} 430 -430 0 1 {name=M5
L=5u
W=0.28u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 490 -430 0 0 {name=p8 sig_type=std_logic lab=pulse}
C {vsource.sym} 150 -90 0 0 {name=V2 value="pulse(0 3.3 25u 1n 1n 2.56u 250u)" savecurrent=false}
C {gnd.sym} 150 -40 0 0 {name=l2 lab=0}
C {lab_wire.sym} 150 -150 0 0 {name=p9 sig_type=std_logic lab=pulse}
C {symbols/nfet_03v3.sym} 540 -450 0 0 {name=M10
L=0.28u
W=18u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {res.sym} 560 -620 0 0 {name=R3
value=10k
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 820 -520 0 1 {name=p28 sig_type=std_logic lab=feedback}
C {symbols/nfet_03v3.sym} 700 -480 0 0 {name=M11
L=1u
W=1u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 700 -560 0 0 {name=M12
L=1u
W=1u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 720 -420 0 0 {name=p31 sig_type=std_logic lab=vss}
C {lab_wire.sym} 720 -620 0 0 {name=p32 sig_type=std_logic lab=vdd1}
C {lab_wire.sym} 1120 -780 0 0 {name=p1 sig_type=std_logic lab=vdd2}
C {lab_wire.sym} 210 -780 0 0 {name=p2 sig_type=std_logic lab=vdd1}
C {lab_wire.sym} 250 -380 0 0 {name=p6 sig_type=std_logic lab=vss}
