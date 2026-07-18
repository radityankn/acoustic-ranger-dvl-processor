v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 540 -290 540 -270 {lab=vss}
N 540 -410 540 -390 {lab=vdd}
N 560 -300 560 -290 {lab=vbias}
N 440 -440 480 -440 {lab=#net1}
N 480 -440 500 -440 {lab=#net1}
N 320 -440 380 -440 {lab=in+}
N 430 -320 430 -300 {lab=#net2}
N 430 -240 430 -200 {lab=vref}
N 410 -320 430 -320 {lab=#net2}
N 320 -320 350 -320 {lab=in-}
N 560 -290 560 -270 {lab=vbias}
N 560 -270 600 -270 {lab=vbias}
N 500 -640 500 -440 {lab=#net1}
N 580 -340 740 -340 {lab=out}
N 660 -640 660 -340 {lab=out}
N 460 -610 520 -610 {lab=50}
N 460 -590 520 -590 {lab=10}
N 460 -570 520 -570 {lab=2}
N 580 -700 580 -680 {lab=vdd}
N 580 -540 580 -520 {lab=vss}
N 430 -360 430 -320 {lab=#net2}
N 430 -360 500 -360 {lab=#net2}
N 460 -320 500 -320 {lab=#net1}
N 460 -440 460 -320 {lab=#net1}
C {res.sym} 410 -440 1 1 {name=R1
value=1k
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 540 -270 0 0 {name=p4 sig_type=std_logic lab=vss}
C {lab_wire.sym} 540 -410 0 0 {name=p5 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 710 -340 0 0 {name=p9 sig_type=std_logic lab=out}
C {lab_wire.sym} 340 -440 2 1 {name=p10 sig_type=std_logic lab=in+}
C {lab_wire.sym} 430 -210 2 1 {name=p2 sig_type=std_logic lab=vref}
C {res.sym} 430 -270 2 1 {name=R3
value=5k
footprint=1206
device=resistor
m=1}
C {res.sym} 380 -320 1 1 {name=R4
value=1k
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 330 -320 2 1 {name=p3 sig_type=std_logic lab=in-}
C {lab_wire.sym} 600 -270 0 0 {name=p11 sig_type=std_logic lab=vbias}
C {acoustic_ranger_2026/two-stage_miller_OTA.sym} 550 -290 0 0 {name=x1}
C {Binary_Resistor_Bank.sym} 620 -520 0 0 {name=x2}
C {lab_wire.sym} 480 -610 0 0 {name=p15 sig_type=std_logic lab=50}
C {lab_wire.sym} 480 -590 0 0 {name=p16 sig_type=std_logic lab=10}
C {lab_wire.sym} 480 -570 0 0 {name=p17 sig_type=std_logic lab=2}
C {lab_wire.sym} 580 -700 0 0 {name=p18 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 580 -520 0 0 {name=p19 sig_type=std_logic lab=vss}
C {opin.sym} 300 -580 0 0 {name=p21 lab=out}
C {ipin.sym} 180 -640 0 0 {name=p1 lab=in+}
C {iopin.sym} 220 -620 0 0 {name=p24 lab=vss}
C {ipin.sym} 180 -620 0 0 {name=p6 lab=in-}
C {iopin.sym} 220 -640 0 0 {name=p7 lab=vdd}
C {iopin.sym} 300 -640 0 0 {name=p8 lab=vref}
C {iopin.sym} 300 -620 0 0 {name=p12 lab=vbias}
C {ipin.sym} 240 -580 0 0 {name=p13 lab=2}
C {ipin.sym} 240 -560 0 0 {name=p14 lab=10}
C {ipin.sym} 240 -540 0 0 {name=p20 lab=50}
