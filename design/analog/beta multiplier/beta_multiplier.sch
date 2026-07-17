v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 360 -250 360 -220 {lab=#net1}
N 240 -250 320 -250 {lab=nbias}
N 200 -250 200 -220 {lab=vss}
N 240 -370 320 -370 {lab=pbias}
N 360 -320 360 -280 {lab=pbias}
N 200 -320 200 -280 {lab=nbias}
N 280 -320 360 -320 {lab=pbias}
N 280 -370 280 -320 {lab=pbias}
N 280 -300 280 -250 {lab=nbias}
N 200 -300 280 -300 {lab=nbias}
N 200 -340 200 -320 {lab=nbias}
N 360 -340 360 -320 {lab=pbias}
N 360 -400 360 -370 {lab=vdd}
N 200 -400 200 -370 {lab=vdd}
N 200 -220 200 -120 {lab=vss}
N 200 -120 360 -120 {lab=vss}
N 360 -220 360 -200 {lab=#net1}
N 360 -140 360 -120 {lab=vss}
N 360 -420 360 -400 {lab=vdd}
N 200 -420 360 -420 {lab=vdd}
N 200 -420 200 -400 {lab=vdd}
N 280 -120 280 -100 {lab=vss}
N 280 -440 280 -420 {lab=vdd}
N 360 -320 460 -320 {lab=pbias}
N 280 -300 460 -300 {lab=nbias}
C {symbols/nfet_03v3.sym} 340 -250 0 0 {name=M14
L=10u
W=13.8u
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
C {symbols/nfet_03v3.sym} 220 -250 0 1 {name=M15
L=10u
W=5.71u
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
C {symbols/pfet_03v3.sym} 340 -370 0 0 {name=M16
L=10u
W=40u
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
C {symbols/pfet_03v3.sym} 220 -370 0 1 {name=M17
L=10u
W=40u
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
C {res.sym} 360 -170 0 0 {name=R3
value=9.012k
footprint=1206
device=resistor
m=1}
C {iopin.sym} 280 -440 0 0 {name=p1 lab=vdd}
C {iopin.sym} 280 -100 0 0 {name=p2 lab=vss}
C {opin.sym} 460 -320 0 0 {name=p3 lab=pbias}
C {opin.sym} 460 -300 0 0 {name=p4 lab=nbias}
C {title.sym} 160 -40 0 0 {name=l1 author="Muhammad Farhan"}
