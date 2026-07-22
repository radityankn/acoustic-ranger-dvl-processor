# DVL Coprocessor Control Unit Specification

## 1. Overview

The Control Unit manages the measurement and communication activities of the DVL Coprocessor.

The Control Unit consists of:

- Outer FSM (scheduler/arbitration)
- Measurement FSM
- I2C FSM
- Register Bank

The Measurement FSM controls the TDC measurement sequence.

The I2C FSM controls communication with the external I2C Controller peripheral.

The Outer FSM schedules the Measurement FSM and I2C FSM in a non-blocking manner using round-robin arbitration.

---

## 2. Architecture Overview

```text
                 Outer FSM
                      |
          +-----------+-----------+
          |                       |
          v                       v

          Measurement FSM     I2C FSM
                 |               |
                 v               v

                TDC      I2C Controller

          +-----------+-----------+
                      |
                      v

                 Register Bank
```

---

## 3. Register Map

### Register Map Summary

| Addr | Register | R/W | Owner |
|------|----------|-----|--------|
| 0x00 | CONTROL | R/W | I2C ↔ Measurement |
| 0x01 | STATUS | R | Measurement |
| 0x02 | MEAS_COUNT_0 | R | Measurement |
| 0x03 | MEAS_COUNT_1 | R | Measurement |
| 0x04 | MEAS_COUNT_2 | R | Measurement |
| 0x05 | MEAS_COUNT_3 | R | Measurement |
| 0x06 | PHASE_RESULT | R | Measurement |

### CONTROL Register (0x00)

| Bit | Name | Values | Description |
|------|------|------|------|
| 0 | START | 0 = Idle, 1 = Start | Begin measurement |
| 1 | SOFT_RESET | 0 = Normal, 1 = Reset | Reset Measurement FSM |
| 2 | IRQ_ENABLE | 0 = Disable, 1 = Enable | Enable interrupt output |
| 3 | CLEAR_DONE | 0 = Wait, 1 = Clear | Clear DONE flag |
| 7:4 | RESERVED | 0 | Future use |

### STATUS Register (0x01)

| Bit | Name | Values | Description |
|------|------|------|------|
| 0 | READY | 0/1 | Controller ready |
| 1 | BUSY | 0/1 | Measurement running |
| 2 | DONE | 0/1 | Measurement completed |
| 3 | TDC_READY | 0/1 | TDC available |
| 7:4 | RESERVED | 0 | Future use |

### Result Registers

```text
0x02 -> measurement_count_reg[7:0]
0x03 -> measurement_count_reg[15:8]
0x04 -> measurement_count_reg[23:16]
0x05 -> measurement_count_reg[31:24]
0x06 -> phase_count_reg[7:0]
```

---

## 4. Outer FSM

### States

- IDLE
- READ_FLAGS
- RUN_MEASUREMENT
- RUN_I2C

### Description

The Outer FSM operates as a non-blocking scheduler.

It dispatches execution to the Measurement FSM and I2C FSM according to active requests.

Round-robin arbitration is used when both requests are active simultaneously.

### Inputs

- start
- i2c_request
- i2c_state_done
- measurement_state_done

### Outputs

- run_measurement
- run_i2c

### Internal Variables

- current_state
- next_state
- last_served

### Arbitration Rule

```text
if start = 1 and i2c_request = 1

last_served = 0
    RUN_MEASUREMENT

last_served = 1
    RUN_I2C
```

---

## 5. Measurement FSM

### States

- IDLE
- CHECK_READY
- START_TDC
- WAIT_TDC_DONE
- READ_RESULT
- WRITE_REGS
- WAIT_ACK

### Inputs

| Signal | Source |
|----------|----------|
| start | CONTROL.START |
| soft_reset | CONTROL.SOFT_RESET |
| clear_done | CONTROL.CLEAR_DONE |
| tdc_ready | TDC |
| tdc_done | TDC |

### Outputs

| Signal | Destination |
|----------|----------|
| tdc_start | TDC |
| ready | STATUS.READY |
| busy | STATUS.BUSY |
| done | STATUS.DONE |
| measurement_state_done | Outer FSM |

### Internal Variables

| Variable | Width | Purpose |
|----------|----------|----------|
| current_state | 3 | Current FSM state |
| next_state | 3 | Next FSM state |

### State Flow

```text
IDLE
  |
start = 1
  |
  v

CHECK_READY
  |
tdc_ready = 1
  |
  v

START_TDC
  |
1 cycle pulse
  |
  v

WAIT_TDC_DONE
  |
tdc_done = 1
  |
  v

READ_RESULT
  |
  v

WRITE_REGS
  |
  v

WAIT_ACK
  |
clear_done = 1
  |
  v

IDLE
```

### Global Reset Rule

```text
soft_reset = 1

Forces immediate transition to IDLE
from any state.
```

---

## 6. Interface Signals

### Outer FSM

Inputs:

- start
- i2c_request
- i2c_state_done
- measurement_state_done

Outputs:

- run_measurement
- run_i2c

### Measurement FSM

Inputs:

- start
- soft_reset
- clear_done
- tdc_ready
- tdc_done

Outputs:

- tdc_start
- measurement_state_done
- ready
- busy
- done

---

## 7. Integration Notes

The TDC block is reused from an existing design.

The I2C Controller block is implemented separately and exposes a Wishbone-compatible interface.

The Measurement FSM controls the TDC measurement sequence.

The I2C FSM controls access to the I2C Controller and does not directly implement SDA/SCL protocol handling.

Error handling through Wishbone ERR_O may be integrated in future revisions.

---

## 8. Current Status

### Completed

- Register Map
- Outer FSM Specification
- Outer FSM RTL
- Outer FSM Simulation
- Measurement FSM Specification
- Measurement FSM RTL
- Measurement FSM Simulation

### Next Tasks

- I2C FSM Specification
- I2C FSM RTL
- I2C FSM Simulation

### Pending

- Full Digital Integration
- TDC ↔ FSM ↔ I2C Demonstration
- Top-Level Verification