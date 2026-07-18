v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 1060 -400 1080 -400 {lab=#net1}
N 1060 -640 1080 -640 {lab=#net2}
N 1060 -880 1080 -880 {lab=#net3}
N 860 -700 940 -700 {lab=vdd}
N 860 -580 940 -580 {lab=vss}
N 860 -460 940 -460 {lab=vdd}
N 860 -340 940 -340 {lab=vss}
N 860 -820 940 -820 {lab=vss}
N 860 -940 940 -940 {lab=vdd}
N 980 -700 1020 -700 {lab=10}
N 980 -580 1020 -580 {lab=10b}
N 980 -460 1020 -460 {lab=2}
N 980 -340 1020 -340 {lab=2b}
N 980 -820 1020 -820 {lab=50b}
N 980 -940 1020 -940 {lab=50}
N 740 -800 740 -780 {lab=vss}
N 740 -900 740 -860 {lab=50b}
N 700 -930 700 -830 {lab=50}
N 740 -980 740 -960 {lab=vdd}
N 740 -830 740 -800 {lab=vss}
N 740 -960 740 -930 {lab=vdd}
N 740 -880 780 -880 {lab=50b}
N 660 -880 700 -880 {lab=50}
N 740 -560 740 -540 {lab=vss}
N 740 -660 740 -620 {lab=10b}
N 700 -690 700 -590 {lab=10}
N 740 -740 740 -720 {lab=vdd}
N 740 -590 740 -560 {lab=vss}
N 740 -720 740 -690 {lab=vdd}
N 740 -640 780 -640 {lab=10b}
N 660 -640 700 -640 {lab=10}
N 740 -320 740 -300 {lab=vss}
N 740 -420 740 -380 {lab=2b}
N 700 -450 700 -350 {lab=2}
N 740 -500 740 -480 {lab=vdd}
N 740 -350 740 -320 {lab=vss}
N 740 -480 740 -450 {lab=vdd}
N 740 -400 780 -400 {lab=2b}
N 660 -400 700 -400 {lab=2}
N 900 -640 900 -400 {lab=A}
N 900 -880 900 -640 {lab=A}
N 1140 -640 1140 -400 {lab=B}
N 1140 -880 1140 -640 {lab=B}
N 860 -640 900 -640 {lab=A}
N 1140 -640 1180 -640 {lab=B}
C {Transmission_Gate.sym} 1000 -280 0 0 {name=x9}
C {res.sym} 1110 -400 3 1 {name=R5
value=2k
footprint=1206
device=resistor
m=1}
C {Transmission_Gate.sym} 1000 -520 0 0 {name=x10}
C {res.sym} 1110 -640 3 1 {name=R6
value=10k
footprint=1206
device=resistor
m=1}
C {Transmission_Gate.sym} 1000 -760 0 0 {name=x11}
C {res.sym} 1110 -880 3 1 {name=R7
value=50k
footprint=1206
device=resistor
m=1}
C {iopin.sym} 860 -640 0 1 {name=p5 lab=A}
C {iopin.sym} 1180 -640 0 0 {name=p6 lab=B}
C {lab_wire.sym} 890 -940 0 0 {name=p7 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 890 -700 0 0 {name=p10 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 890 -460 0 0 {name=p17 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 890 -580 0 0 {name=p18 sig_type=std_logic lab=vss}
C {lab_wire.sym} 890 -340 0 0 {name=p19 sig_type=std_logic lab=vss}
C {lab_wire.sym} 890 -820 0 0 {name=p20 sig_type=std_logic lab=vss}
C {lab_wire.sym} 1020 -940 0 1 {name=p21 sig_type=std_logic lab=50}
C {lab_wire.sym} 1020 -820 0 1 {name=p22 sig_type=std_logic lab=50b}
C {lab_wire.sym} 1020 -700 0 1 {name=p23 sig_type=std_logic lab=10}
C {lab_wire.sym} 1020 -580 0 1 {name=p24 sig_type=std_logic lab=10b}
C {lab_wire.sym} 1020 -460 0 1 {name=p25 sig_type=std_logic lab=2}
C {lab_wire.sym} 1020 -340 0 1 {name=p26 sig_type=std_logic lab=2b}
C {symbols/pfet_03v3.sym} 720 -930 0 0 {name=M9
L=0.28u
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
C {symbols/nfet_03v3.sym} 720 -830 0 0 {name=M10
L=0.28u
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
C {lab_wire.sym} 740 -980 0 0 {name=p27 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 740 -780 0 0 {name=p28 sig_type=std_logic lab=vss}
C {lab_wire.sym} 750 -880 0 1 {name=p29 sig_type=std_logic lab=50b}
C {symbols/pfet_03v3.sym} 720 -690 0 0 {name=M11
L=0.28u
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
C {symbols/nfet_03v3.sym} 720 -590 0 0 {name=M12
L=0.28u
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
C {lab_wire.sym} 750 -640 0 1 {name=p32 sig_type=std_logic lab=10b}
C {symbols/pfet_03v3.sym} 720 -450 0 0 {name=M13
L=0.28u
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
C {symbols/nfet_03v3.sym} 720 -350 0 0 {name=M14
L=0.28u
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
C {lab_wire.sym} 740 -500 0 0 {name=p33 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 740 -300 0 0 {name=p34 sig_type=std_logic lab=vss}
C {lab_wire.sym} 750 -400 0 1 {name=p35 sig_type=std_logic lab=2b}
C {ipin.sym} 660 -400 0 0 {name=p36 lab=2}
C {ipin.sym} 660 -640 0 0 {name=p37 lab=10}
C {ipin.sym} 660 -880 0 0 {name=p38 lab=50}
C {iopin.sym} 670 -1020 0 1 {name=p1 lab=vdd}
C {iopin.sym} 670 -1000 0 1 {name=p2 lab=vss}
C {lab_wire.sym} 740 -740 0 0 {name=p3 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 740 -550 0 0 {name=p4 sig_type=std_logic lab=vss}
