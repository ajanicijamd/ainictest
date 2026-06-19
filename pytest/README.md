# AI NIC End-to-End Test

Standalone test project that verifies all 10 AI NIC RDMA counter tracks are
written to both the Perfetto trace and the ROCpd database by rocprofiler-systems,
and that PMC descriptions are correctly registered for every counter.

## Prerequisites

- `rocprofiler-systems` v1.7.0+ (built with AI NIC Phase 2 support)
- `ROCPROFSYS_INSTALL_DIR` **or** `ROCPROFSYS_BUILD_DIR` set (see below)
- `amd-smi` installed (must support AI NIC RDMA metrics)
- `wget` on PATH (used as the profiled workload)
- Python 3 + pytest (`pip install -r requirements.txt`)
- Real AI NIC hardware (Pensando Pollara), OR `SMI_NIC_SYSFS_ROOT` set to a
  fake sysfs root created by `setup_ainic_sim.sh`

> **Important:** The test does not fall back to whatever `rocprof-sys-sample`
> happens to be on PATH.  You must explicitly point it at the installation you
> want to test.  This keeps the test hermetic and avoids accidentally passing
> against a system-installed binary that predates the fix.

## Running against an installed rocprofiler-systems

```bash
export ROCPROFSYS_INSTALL_DIR=/opt/rocprofiler-systems   # or wherever cmake --install went
export SMI_NIC_SYSFS_ROOT=/tmp/ainic-sim-XXXXX           # or unset for real hardware
pytest test_ainic_perf.py -v -m ainic
```

## Running against a build directory (without installing)

```bash
export ROCPROFSYS_BUILD_DIR=/path/to/rocprofiler-systems/build/debug
export SMI_NIC_SYSFS_ROOT=/tmp/ainic-sim-XXXXX
pytest test_ainic_perf.py -v -m ainic
```

## Running with the AI NIC simulator (no hardware required)

### Terminal 1 — start the simulator
```bash
# Path to setup_ainic_sim.sh from the rocm-systems amdsmi repo:
cd /path/to/rocm-systems/projects/amdsmi/tests/ai-nic-sim
./setup_ainic_sim.sh
# Copy the printed: export SMI_NIC_SYSFS_ROOT=/tmp/ainic-sim-XXXXX
```

### Terminal 2 — run the test
```bash
export SMI_NIC_SYSFS_ROOT=/tmp/ainic-sim-XXXXX
export ROCPROFSYS_INSTALL_DIR=/opt/rocprofiler-systems
pytest test_ainic_perf.py -v -m ainic
```

## What the test verifies

| Check | Details |
|-------|---------|
| Perfetto trace | All 10 AI NIC RDMA counter track names present in `.proto` file |
| ROCpd string table | All 10 AI NIC track names present in `rocpd_string_*` |
| ROCpd PMC descriptions | All 10 NIC PMC names present in `rocpd_info_pmc_*` — confirms `add_pmc_info()` was called for every counter; absence causes `insert_pmc_event` to silently drop all samples for that counter |

The `rocpd_info_pmc_` check catches the class of bug reported in ROCM-162 v2:
PR #7290 added the four error counters as tracks but omitted the matching
`add_pmc_info()` calls, so `insert_pmc_event()` failed at runtime with:

```
[data_processor.cpp insert_pmc_event][warning] Insert PMC event failed!
Error: non-existing PMC description agent id: <n>, pmc name: nic_tx_rdma_ack_timeout
```

### The 10 RDMA tracks

| Track name | PMC name | Phase |
|---|---|---|
| `ainic_rx_rdma_ucast_bytes` | `nic_rx_ucast_bytes` | Phase 1 |
| `ainic_tx_rdma_ucast_bytes` | `nic_tx_ucast_bytes` | Phase 1 |
| `ainic_rx_rdma_ucast_pkts` | `nic_rx_ucast_pkts` | Phase 1 |
| `ainic_tx_rdma_ucast_pkts` | `nic_tx_ucast_pkts` | Phase 1 |
| `ainic_rx_rdma_cnp_pkts` | `nic_rx_cnp_pkts` | Phase 1 |
| `ainic_tx_rdma_cnp_pkts` | `nic_tx_cnp_pkts` | Phase 1 |
| `ainic_tx_rdma_ack_timeout` | `nic_tx_rdma_ack_timeout` | Phase 2 |
| `ainic_resp_tx_pkt_seq_err` | `nic_resp_tx_pkt_seq_err` | Phase 2 |
| `ainic_req_rx_pkt_seq_err` | `nic_req_rx_pkt_seq_err` | Phase 2 |
| `ainic_req_rx_impl_nak_seq_err` | `nic_req_rx_impl_nak_seq_err` | Phase 2 |
