v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
L 4 550 -740 600 -660 {}
L 4 580 -670 600 -660 {}
L 4 580 -670 600 -660 {}
L 4 600 -680 600 -660 {}
T {planned to add resistor selection for the programmable gain.
currently waiting on the transmission gate} 300 -790 0 0 0.3 0.3 {}
N 40 -290 40 -270 {lab=0}
N 110 -290 110 -270 {lab=0}
N 110 -380 110 -350 {lab=vss}
N 40 -380 40 -350 {lab=vdd}
N 40 -600 40 -580 {lab=0}
N 40 -450 40 -430 {lab=0}
N 40 -540 40 -510 {lab=in-}
N 40 -690 40 -660 {lab=in+}
N 540 -500 580 -500 {lab=#net1}
N 620 -470 620 -450 {lab=vss}
N 620 -590 620 -570 {lab=vdd}
N 580 -620 580 -540 {lab=#net2}
N 660 -620 660 -520 {lab=out}
N 640 -480 640 -470 {lab=vbias}
N 520 -620 560 -620 {lab=#net2}
N 580 -620 600 -620 {lab=#net2}
N 560 -620 580 -620 {lab=#net2}
N 400 -620 460 -620 {lab=in+}
N 660 -520 730 -520 {lab=out}
N 170 -290 170 -270 {lab=0}
N 170 -380 170 -350 {lab=vref}
N 510 -500 510 -480 {lab=#net1}
N 510 -500 540 -500 {lab=#net1}
N 510 -420 510 -380 {lab=vref}
N 490 -500 510 -500 {lab=#net1}
N 400 -500 430 -500 {lab=in-}
N 640 -470 640 -450 {lab=vbias}
N 640 -450 680 -450 {lab=vbias}
N 240 -380 240 -350 {lab=vbias}
N 240 -290 240 -270 {lab=0}
C {vsource.sym} 40 -320 0 0 {name=V5 value=3.3 savecurrent=false}
C {vsource.sym} 110 -320 0 0 {name=V6 value=0 savecurrent=false}
C {gnd.sym} 110 -270 0 0 {name=l9 lab=0}
C {gnd.sym} 40 -270 0 0 {name=l10 lab=0}
C {lab_wire.sym} 40 -380 0 0 {name=p27 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 110 -380 0 0 {name=p28 sig_type=std_logic lab=vss}
C {gnd.sym} 40 -430 0 0 {name=l1 lab=0}
C {gnd.sym} 40 -580 0 0 {name=l2 lab=0}
C {lab_wire.sym} 40 -690 0 0 {name=p6 sig_type=std_logic lab=in+}
C {lab_wire.sym} 40 -540 0 0 {name=p7 sig_type=std_logic lab=in-}
C {vsource.sym} 40 -480 0 0 {name=V8 value="sin(1.65 0.06 250k 0 0 0)" savecurrent=false}
C {vsource.sym} 40 -630 0 0 {name=V1 value="sin(1.65 0.06 250k 0 0 180)" savecurrent=false}
C {acoustic_ranger_2026/two-stage_miller_OTA.sym} 630 -470 0 0 {name=x1}
C {res.sym} 490 -620 1 1 {name=R1
value=1k
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 620 -450 0 0 {name=p4 sig_type=std_logic lab=vss}
C {lab_wire.sym} 620 -590 0 0 {name=p5 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 730 -520 0 0 {name=p9 sig_type=std_logic lab=out}
C {lab_wire.sym} 420 -620 2 1 {name=p10 sig_type=std_logic lab=in+}
C {vsource.sym} 170 -320 0 0 {name=V2 value=1.1 savecurrent=false}
C {gnd.sym} 170 -270 0 0 {name=l3 lab=0}
C {lab_wire.sym} 170 -380 0 0 {name=p1 sig_type=std_logic lab=vref}
C {lab_wire.sym} 510 -390 2 1 {name=p2 sig_type=std_logic lab=vref}
C {res.sym} 510 -450 2 1 {name=R3
value=5k
footprint=1206
device=resistor
m=1}
C {res.sym} 460 -500 1 1 {name=R4
value=1k
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 410 -500 2 1 {name=p3 sig_type=std_logic lab=in-}
C {res.sym} 630 -620 1 1 {name=R2
value=5k
footprint=1206
device=resistor
m=1}
C {vsource.sym} 240 -320 0 0 {name=V3 value=2.27 savecurrent=false}
C {lab_wire.sym} 240 -380 0 0 {name=p8 sig_type=std_logic lab=vbias}
C {gnd.sym} 240 -270 0 0 {name=l4 lab=0}
C {lab_wire.sym} 680 -450 0 0 {name=p11 sig_type=std_logic lab=vbias}
