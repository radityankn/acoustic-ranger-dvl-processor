v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -70 -340 -70 -310 {lab=VDD}
N 80 -340 80 -310 {lab=n2}
N 430 -120 430 0 {lab=VSS}
N -70 0 -70 130 {lab=VSS}
N 390 -340 390 -310 {lab=VDD}
N 390 -230 430 -230 {lab=out}
N 230 -340 230 -310 {lab=VDD}
N -200 -200 -180 -200 {lab=in}
N -180 -200 -180 -30 {lab=in}
N -180 -30 -110 -30 {lab=in}
N -70 -140 -70 -60 {lab=n1}
N -70 -30 -40 -30 {lab=VSS}
N -40 -30 -40 40 {lab=VSS}
N -70 40 -40 40 {lab=VSS}
N 280 -100 280 -60 {lab=outc}
N -180 -30 -180 -20 {lab=in}
N -180 -20 -180 -10 {lab=in}
N -180 -10 -180 -0 {lab=in}
N -180 0 -180 10 {lab=in}
N -180 10 -180 20 {lab=in}
N -180 20 -180 30 {lab=in}
N -180 30 -180 40 {lab=in}
N -180 40 -180 50 {lab=in}
N -180 50 -180 60 {lab=in}
N -180 60 -180 170 {lab=in}
N 240 -30 240 170 {lab=in}
N 280 0 280 20 {lab=n1}
N 280 -30 310 -30 {lab=VSS}
N 190 -280 190 -150 {lab=outc}
N 190 -150 380 -150 {lab=outc}
N 280 -150 280 -100 {lab=outc}
N 270 -150 280 -150 {lab=outc}
N 230 -250 230 -230 {lab=n1}
N 230 -280 260 -280 {lab=VSS}
N -70 -250 -70 -230 {lab=n2}
N -180 -280 -180 -200 {lab=in}
N -180 -280 -110 -280 {lab=in}
N -70 -280 -60 -280 {lab=VDD}
N -60 -280 -50 -280 {lab=VDD}
N -50 -290 -50 -280 {lab=VDD}
N -50 -300 -50 -290 {lab=VDD}
N -50 -310 -50 -300 {lab=VDD}
N -50 -320 -50 -310 {lab=VDD}
N -60 -320 -50 -320 {lab=VDD}
N -70 -320 -60 -320 {lab=VDD}
N 80 -250 80 -150 {lab=outc}
N 80 -150 190 -150 {lab=outc}
N -180 -200 40 -200 {lab=in}
N 40 -280 40 -200 {lab=in}
N 80 -280 110 -280 {lab=VDD}
N 80 0 80 120 {lab=VSS}
N 40 -150 40 -30 {lab=outc}
N 40 -150 80 -150 {lab=outc}
N 80 -80 80 -60 {lab=n2}
N 80 -30 110 -30 {lab=VDD}
N 350 -280 350 -150 {lab=outc}
N 390 -250 390 -230 {lab=out}
N 390 -280 410 -280 {lab=VDD}
N 410 -320 410 -280 {lab=VDD}
N 390 -320 410 -320 {lab=VDD}
N 430 -150 450 -150 {lab=VSS}
N 450 -150 450 -100 {lab=VSS}
N 430 -100 450 -100 {lab=VSS}
N 430 -200 430 -180 {lab=out}
N -180 170 230 170 {lab=in}
N 230 170 240 170 {lab=in}
N 380 -150 390 -150 {lab=outc}
N 430 -230 430 -200 {lab=out}
C {symbols/pfet_03v3.sym} -90 -280 0 0 {name=XM4
W=2.0e-6
L=2e-6
nf=1
m=1
model=pfet_03v3
spiceprefix=X}
C {symbols/pfet_03v3.sym} 60 -280 0 0 {name=XM5
W=2.0e-6
L=2e-6
nf=1
m=1
model=pfet_03v3
spiceprefix=X}
C {symbols/pfet_03v3.sym} 60 -30 0 0 {name=XM6
W=1.3e-6
L=2e-6
nf=1
m=1
model=pfet_03v3
spiceprefix=X}
C {symbols/nfet_03v3.sym} -90 -30 0 0 {name=XM1
W=1.0e-6
L=2e-6
nf=1
m=1
model=nfet_03v3
spiceprefix=X}
C {symbols/nfet_03v3.sym} 260 -30 0 0 {name=XM2
W=1.0e-6
L=2e-6
nf=1
m=1
model=nfet_03v3
spiceprefix=X}
C {symbols/nfet_03v3.sym} 210 -280 0 0 {name=XM3
W=0.7e-6
L=2e-6
nf=1
m=1
model=nfet_03v3
spiceprefix=X}
C {symbols/pfet_03v3.sym} 370 -280 0 0 {name=XM7
W=4.0e-6
L=0.5e-6
nf=1
m=1
model=pfet_03v3
spiceprefix=X}
C {symbols/nfet_03v3.sym} 410 -150 0 0 {name=XM8
W=2.0e-6
L=0.5e-6
nf=1
m=1
model=nfet_03v3
spiceprefix=X}
C {ipin.sym} -200 -200 0 0 {name=p1 lab=in}
C {opin.sym} 430 -230 0 0 {name=p2 lab=out}
C {vdd.sym} -70 -340 0 0 {name=l1 lab=VDD}
C {vdd.sym} 110 -280 0 0 {name=l2 lab=VDD}
C {vdd.sym} 390 -340 0 0 {name=l3 lab=VDD}
C {gnd.sym} -70 130 0 0 {name=l4 lab=VSS}
C {gnd.sym} 430 0 0 0 {name=l5 lab=VSS}
C {lab_pin.sym} -70 -230 0 1 {name=p3 sig_type=std_logic lab=n2}
C {lab_pin.sym} 280 -100 0 0 {name=p4 sig_type=std_logic lab=outc}
C {lab_pin.sym} -70 -110 0 0 {name=p5 sig_type=std_logic lab=n1}
C {title.sym} -200 230 0 0 {name=l10 author="Team Acoustic Ranger" rev=1.0 title="Schmitt Trigger DVL - GF180MCU 3.3V"}
C {vdd.sym} 230 -340 0 0 {name=l7 lab=VDD}
C {lab_pin.sym} 280 20 0 0 {name=p6 sig_type=std_logic lab=n1}
C {gnd.sym} 310 -30 0 0 {name=l8 lab=VSS}
C {lab_pin.sym} 230 -230 0 0 {name=p7 sig_type=std_logic lab=n1}
C {gnd.sym} 260 -280 0 0 {name=l9 lab=VSS}
C {lab_pin.sym} 80 -340 0 1 {name=p8 sig_type=std_logic lab=n2}
C {gnd.sym} 80 120 0 0 {name=l11 lab=VSS}
C {lab_pin.sym} 80 -80 0 1 {name=p9 sig_type=std_logic lab=n2}
C {vdd.sym} 110 -30 0 0 {name=l12 lab=VDD}
