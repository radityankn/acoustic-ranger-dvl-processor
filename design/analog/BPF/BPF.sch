v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 850 -560 890 -560 {lab=in}
N 1410 -540 1490 -540 {lab=out}
N 1490 -540 1520 -540 {lab=out}
N 1090 -560 1130 -560 {lab=#net1}
N 1280 -670 1450 -670 {lab=out}
N 1450 -670 1450 -540 {lab=out}
N 990 -440 1130 -440 {lab=vref}
N 1130 -560 1190 -560 {lab=#net1}
N 990 -460 990 -440 {lab=vref}
N 990 -560 990 -520 {lab=#net2}
N 990 -560 1030 -560 {lab=#net2}
N 950 -560 990 -560 {lab=#net2}
N 990 -670 990 -560 {lab=#net2}
N 990 -670 1030 -670 {lab=#net2}
N 1190 -580 1190 -560 {lab=#net1}
N 1190 -670 1190 -640 {lab=out}
N 1090 -670 1190 -670 {lab=out}
N 1190 -670 1280 -670 {lab=out}
N 1520 -540 1560 -540 {lab=out}
N 1130 -440 1230 -440 {lab=vref}
N 1370 -540 1410 -540 {lab=out}
N 1230 -520 1290 -520 {lab=vref}
N 1230 -520 1230 -440 {lab=vref}
N 1190 -560 1290 -560 {lab=#net1}
N 1350 -500 1350 -470 {lab=#net3}
N 1350 -470 1410 -470 {lab=#net3}
N 1330 -490 1330 -440 {lab=vss}
N 1330 -640 1330 -590 {lab=vdd}
C {opin.sym} 1560 -540 0 0 {name=p21 lab=out}
C {res.sym} 920 -560 1 0 {name=R2
value=30k
footprint=1206
device=resistor
m=1}
C {capa.sym} 1060 -670 1 0 {name=C2
m=1
value=20p
footprint=1206
device="ceramic capacitor"}
C {res.sym} 1190 -610 2 0 {name=R3
value=120k
footprint=1206
device=resistor
m=1}
C {res.sym} 990 -490 2 0 {name=R7
value=10k
footprint=1206
device=resistor
m=1}
C {capa.sym} 1060 -560 1 0 {name=C7
m=1
value=20p
footprint=1206
device="ceramic capacitor"}
C {acoustic_ranger_2026/two-stage_miller_OTA.sym} 1340 -490 0 0 {name=x1}
C {ipin.sym} 850 -560 0 0 {name=p15 lab=in}
C {iopin.sym} 1330 -640 0 0 {name=p23 lab=vdd}
C {iopin.sym} 1330 -440 0 0 {name=p24 lab=vss}
C {iopin.sym} 1230 -440 0 0 {name=p1 lab=vref}
C {ipin.sym} 1410 -470 0 1 {name=p2 lab=OTA_bias}
