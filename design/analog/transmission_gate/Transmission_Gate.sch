v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 470 -240 510 -240 {lab=en}
N 190 -270 430 -270 {lab=A}
N 190 -210 430 -210 {lab=B}
N 110 -240 150 -240 {lab=en_b}
N 310 -300 310 -270 {lab=A}
N 310 -210 310 -180 {lab=B}
N 380 -240 430 -240 {lab=vss}
N 190 -240 240 -240 {lab=vdd}
C {symbols/pfet_03v3.sym} 170 -240 0 0 {name=M1
L=0.28u
W=20u
nf=10
m=8
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 450 -240 0 1 {name=M2
L=0.28u
W=10u
nf=5
m=8
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {ipin.sym} 110 -240 0 0 {name=p14 lab=en_b}
C {iopin.sym} 310 -300 0 0 {name=p8 lab=A}
C {iopin.sym} 310 -180 0 0 {name=p9 lab=B}
C {title.sym} 170 -40 0 0 {name=l1 author="Muhammad Farhan"}
C {ipin.sym} 510 -240 0 1 {name=p2 lab=en}
C {iopin.sym} 240 -240 0 0 {name=p1 lab=vdd}
C {iopin.sym} 380 -240 0 1 {name=p3 lab=vss}
