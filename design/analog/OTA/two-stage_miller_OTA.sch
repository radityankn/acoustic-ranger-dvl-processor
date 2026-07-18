v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 460 -340 500 -340 {lab=in+}
N 120 -340 160 -340 {lab=in+}
N 310 -370 420 -370 {lab=#net1}
N 200 -340 420 -340 {lab=vdd}
N 200 -310 200 -220 {lab=#net2}
N 310 -440 310 -370 {lab=#net1}
N 200 -370 310 -370 {lab=#net1}
N 420 -310 420 -220 {lab=#net3}
N 200 -160 420 -160 {lab=vss}
N 200 -190 200 -160 {lab=vss}
N 240 -190 380 -190 {lab=#net2}
N 420 -190 420 -160 {lab=vss}
N 310 -220 310 -190 {lab=#net2}
N 310 -260 310 -220 {lab=#net2}
N 200 -260 310 -260 {lab=#net2}
N 310 -500 630 -500 {lab=vdd}
N 420 -270 590 -270 {lab=#net3}
N 630 -440 630 -300 {lab=out}
N 630 -240 630 -160 {lab=vss}
N 420 -160 630 -160 {lab=vss}
N 630 -370 750 -370 {lab=out}
N 570 -290 570 -270 {lab=#net3}
N 570 -370 570 -350 {lab=out}
N 570 -370 630 -370 {lab=out}
N 630 -270 630 -240 {lab=vss}
N 630 -500 660 -500 {lab=vdd}
N 630 -160 650 -160 {lab=vss}
N 310 -500 310 -470 {lab=vdd}
N 630 -500 630 -470 {lab=vdd}
N 590 -470 590 -460 {lab=bias}
N 270 -460 590 -460 {lab=bias}
N 270 -470 270 -460 {lab=bias}
N 180 -470 270 -470 {lab=bias}
C {symbols/pfet_03v3.sym} 180 -340 0 0 {name=M1
L=1u
W=49.6u
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
C {symbols/pfet_03v3.sym} 440 -340 0 1 {name=M2
L=1u
W=49.6u
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
C {lab_wire.sym} 330 -340 0 0 {name=p12 sig_type=std_logic lab=vdd}
C {ipin.sym} 500 -340 0 1 {name=p14 lab=in+}
C {ipin.sym} 120 -340 0 0 {name=p15 lab=in-}
C {lab_wire.sym} 330 -160 0 0 {name=p2 sig_type=std_logic lab=vss}
C {symbols/nfet_03v3.sym} 400 -190 0 0 {name=M14
L=3u
W=15.4u
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
C {symbols/nfet_03v3.sym} 220 -190 0 1 {name=M15
L=3u
W=15.4u
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
C {symbols/nfet_03v3.sym} 610 -270 0 0 {name=M3
L=500n
W=15.4u
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
C {capa.sym} 570 -320 0 0 {name=C1
m=1
value=150f
footprint=1206
device="ceramic capacitor"}
C {opin.sym} 750 -370 0 0 {name=p10 lab=out}
C {iopin.sym} 660 -500 0 0 {name=p23 lab=vdd}
C {iopin.sym} 650 -160 0 0 {name=p24 lab=vss}
C {ipin.sym} 180 -470 0 0 {name=p1 lab=bias}
C {lab_wire.sym} 370 -500 0 0 {name=p5 sig_type=std_logic lab=vdd}
C {symbols/pfet_03v3.sym} 290 -470 0 0 {name=M4
L=30u
W=63.9u
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
C {symbols/pfet_03v3.sym} 610 -470 0 0 {name=M5
L=30u
W=55.75u
nf=1
m=15
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {title.sym} 170 -40 0 0 {name=l1 author="Muhammad Farhan"}
