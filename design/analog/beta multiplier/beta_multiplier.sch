v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 170 -320 250 -320 {lab=nbias}
N 130 -320 130 -290 {lab=vss}
N 170 -540 250 -540 {lab=pbias}
N 290 -390 290 -350 {lab=pbias}
N 130 -390 130 -350 {lab=nbias}
N 210 -490 290 -490 {lab=pbias}
N 210 -540 210 -490 {lab=pbias}
N 210 -370 210 -320 {lab=nbias}
N 130 -370 210 -370 {lab=nbias}
N 130 -510 130 -490 {lab=nbias}
N 290 -510 290 -490 {lab=pbias}
N 290 -570 290 -540 {lab=vdd}
N 130 -570 130 -540 {lab=vdd}
N 130 -290 130 -190 {lab=vss}
N 130 -190 290 -190 {lab=vss}
N 290 -290 290 -270 {lab=#net1}
N 290 -210 290 -190 {lab=vss}
N 290 -590 290 -570 {lab=vdd}
N 130 -590 290 -590 {lab=vdd}
N 130 -590 130 -570 {lab=vdd}
N 210 -190 210 -170 {lab=vss}
N 210 -610 210 -590 {lab=vdd}
N 290 -490 290 -390 {lab=pbias}
N 130 -490 130 -390 {lab=nbias}
N 290 -320 290 -290 {lab=#net1}
N 210 -370 390 -370 {lab=nbias}
N 410 -240 410 -210 {lab=vss}
N 410 -210 410 -190 {lab=vss}
N 410 -350 410 -270 {lab=pbias}
N 290 -350 410 -350 {lab=pbias}
N 290 -190 410 -190 {lab=vss}
N 520 -370 520 -260 {lab=nbias}
N 560 -400 560 -290 {lab=#net2}
N 560 -590 560 -460 {lab=vdd}
N 560 -260 560 -230 {lab=vss}
N 560 -230 560 -190 {lab=vss}
N 410 -190 560 -190 {lab=vss}
N 290 -590 560 -590 {lab=vdd}
N 740 -340 740 -320 {lab=status}
N 740 -330 840 -330 {lab=status}
N 700 -370 700 -290 {lab=#net2}
N 740 -290 740 -260 {lab=vss}
N 740 -400 740 -370 {lab=vdd}
N 740 -430 740 -400 {lab=vdd}
N 740 -260 740 -230 {lab=vss}
N 450 -240 460 -240 {lab=trigger}
N 390 -370 520 -370 {lab=nbias}
N 560 -330 700 -330 {lab=#net2}
C {title.sym} 160 -40 0 0 {name=l1 author="Muhammad Farhan"}
C {iopin.sym} 210 -610 0 0 {name=p5 lab=vdd}
C {iopin.sym} 210 -170 0 0 {name=p8 lab=vss}
C {opin.sym} 290 -470 0 1 {name=p9 lab=pbias}
C {opin.sym} 130 -390 0 0 {name=p10 lab=nbias}
C {symbols/nfet_03v3.sym} 270 -320 0 0 {name=M1
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
C {symbols/nfet_03v3.sym} 150 -320 0 1 {name=M2
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
C {symbols/pfet_03v3.sym} 270 -540 0 0 {name=M3
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
C {symbols/pfet_03v3.sym} 150 -540 0 1 {name=M4
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
C {res.sym} 290 -240 0 0 {name=R1
value=10k
footprint=1206
device=resistor
m=1}
C {symbols/nfet_03v3.sym} 430 -240 0 1 {name=M5
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
C {symbols/nfet_03v3.sym} 540 -260 0 0 {name=M10
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
C {res.sym} 560 -430 0 0 {name=R3
value=10k
footprint=1206
device=resistor
m=1}
C {symbols/nfet_03v3.sym} 720 -290 0 0 {name=M11
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
C {symbols/pfet_03v3.sym} 720 -370 0 0 {name=M12
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
C {lab_wire.sym} 740 -230 0 0 {name=p31 sig_type=std_logic lab=vss}
C {lab_wire.sym} 740 -430 0 0 {name=p32 sig_type=std_logic lab=vdd}
C {opin.sym} 840 -330 0 0 {name=p1 lab=status}
C {ipin.sym} 460 -240 0 1 {name=p2 lab=trigger}
