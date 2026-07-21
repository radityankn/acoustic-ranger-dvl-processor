v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 360 -440 460 -440 {lab=pbias}
N 240 -270 320 -270 {lab=#net5}
N 200 -270 200 -240 {lab=vss}
N 240 -490 320 -490 {lab=pbias}
N 360 -340 360 -300 {lab=pbias}
N 200 -340 200 -300 {lab=#net5}
N 280 -440 360 -440 {lab=pbias}
N 280 -490 280 -440 {lab=pbias}
N 280 -320 280 -270 {lab=#net5}
N 200 -320 280 -320 {lab=#net5}
N 200 -460 200 -440 {lab=#net5}
N 360 -460 360 -440 {lab=pbias}
N 360 -520 360 -490 {lab=vdd}
N 200 -520 200 -490 {lab=vdd}
N 200 -240 200 -140 {lab=vss}
N 200 -140 360 -140 {lab=vss}
N 360 -240 360 -220 {lab=#net6}
N 360 -160 360 -140 {lab=vss}
N 360 -540 360 -520 {lab=vdd}
N 200 -540 360 -540 {lab=vdd}
N 200 -540 200 -520 {lab=vdd}
N 280 -140 280 -120 {lab=vss}
N 280 -560 280 -540 {lab=vdd}
N 360 -440 360 -340 {lab=pbias}
N 200 -440 200 -340 {lab=#net5}
N 360 -270 360 -240 {lab=#net6}
N 280 -320 460 -320 {lab=#net5}
C {iopin.sym} 280 -560 0 0 {name=p1 lab=vdd}
C {iopin.sym} 280 -120 0 0 {name=p2 lab=vss}
C {opin.sym} 460 -440 0 0 {name=p3 lab=pbias}
C {opin.sym} 460 -320 0 0 {name=p4 lab=nbias}
C {title.sym} 160 -40 0 0 {name=l1 author="Muhammad Farhan"}
C {symbols/nfet_03v3.sym} 340 -270 0 0 {name=M6
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
C {symbols/nfet_03v3.sym} 220 -270 0 1 {name=M7
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
C {symbols/pfet_03v3.sym} 340 -490 0 0 {name=M8
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
C {symbols/pfet_03v3.sym} 220 -490 0 1 {name=M9
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
C {res.sym} 360 -190 0 0 {name=R2
value=10k
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 310 -140 0 0 {name=p6 sig_type=std_logic lab=vss}
C {lab_wire.sym} 270 -540 0 0 {name=p7 sig_type=std_logic lab=vdd}
