v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 220 -370 220 -330 {lab=#net1}
N 220 -270 220 -230 {lab=out}
N 220 -170 220 -130 {lab=#net2}
N 180 -400 180 -100 {lab=in}
N 220 -150 380 -150 {lab=#net2}
N 220 -350 380 -350 {lab=#net1}
N 410 -310 410 -190 {lab=out}
N 220 -250 410 -250 {lab=out}
N 410 -250 510 -250 {lab=out}
N 440 -150 460 -150 {lab=vdd}
N 440 -350 460 -350 {lab=out}
N 410 -150 410 -70 {lab=vss}
N 410 -430 410 -350 {lab=vdd}
N 160 -250 180 -250 {lab=in}
N 220 -430 410 -430 {lab=vdd}
N 220 -70 410 -70 {lab=vss}
N 410 -70 430 -70 {lab=vss}
N 410 -430 430 -430 {lab=vdd}
C {symbols/nfet_03v3.sym} 200 -200 0 0 {name=M1
L=2u
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
C {symbols/pfet_03v3.sym} 200 -300 0 0 {name=M2
L=2u
W=2u
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
C {symbols/nfet_03v3.sym} 200 -100 0 0 {name=M3
L=2u
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
C {symbols/pfet_03v3.sym} 200 -400 0 0 {name=M4
L=2u
W=2u
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
C {symbols/nfet_03v3.sym} 410 -170 1 0 {name=M5
L=2u
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
C {symbols/pfet_03v3.sym} 410 -330 3 0 {name=M6
L=2u
W=2u
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
C {ipin.sym} 160 -250 0 0 {name=p1 lab=in}
C {opin.sym} 510 -250 0 0 {name=p2 lab=out}
C {iopin.sym} 430 -430 0 0 {name=p23 lab=vdd}
C {iopin.sym} 430 -70 0 0 {name=p3 lab=vss}
C {lab_wire.sym} 460 -350 0 1 {name=p8 sig_type=std_logic lab=vss}
C {lab_wire.sym} 460 -150 0 1 {name=p4 sig_type=std_logic lab=vdd}
