# AI NIC End-to-End Test

Standalone test project that verifies all 10 AI NIC RDMA counter tracks are
written to both the Perfetto trace and the ROCpd database by rocprofiler-systems.

## Prerequisites

- `rocprofiler-systems` installed (or built from the `develop` branch)
- `rocprof-sys-sample` on PATH, or `ROCPROFSYS_BUILD_DIR` pointing to the build
- `amd-smi` installed (must support AI NIC RDMA metrics)
- `wget` on PATH (used as the profiled workload)
- Python 3 + pytest (`pip install -r requirements.txt`)
- Real AI NIC hardware (Pensando Pollara), OR `SMI_NIC_SYSFS_ROOT` set to a
  fake sysfs root created by `setup_ainic_sim.sh`

## Running against installed rocprofiler-systems

```bash
# If rocprof-sys-sample is already on PATH (e.g. from /opt/rocm/bin):
pytest test_ainic_perf.py -v -m ainic

# If using a custom build directory:
ROCPROFSYS_BUILD_DIR=/path/to/rocprofiler-systems/build \
    pytest test_ainic_perf.py -v -m ainic
```

## Running with the AI NIC simulator (no hardware required)

### Terminal 1 ? start the simulator
```bash
# Path to setup_ainic_sim.sh from the rocm-systems amdsmi repo:
cd /path/to/rocm-systems/projects/amdsmi/tests/ai-nic-sim
./setup_ainic_sim.sh
# Copy the printed: export SMI_NIC_SYSFS_ROOT=/tmp/ainic-sim-XXXXX
```

### Terminal 2 ? run the test
```bash
export SMI_NIC_SYSFS_ROOT=/tmp/ainic-sim-XXXXX
export ROCPROFSYS_BUILD_DIR=/path/to/rocprofiler-systems/build
pytest test_ainic_perf.py -v -m ainic
```

## What the test verifies

| Check | Details |
|-------|---------|
| Perfetto trace | All 10 AI NIC RDMA counter track names present in `.proto` file |
| ROCpd database | All 10 AI NIC track names present in SQLite `.db` file |

### The 10 RDMA tracks
- `ainic_rx_rdma_ucast_bytes`
- `ainic_tx_rdma_ucast_bytes`
- `ainic_rx_rdma_ucast_pkts`
- `ainic_tx_rdma_ucast_pkts`
- `ainic_rx_rdma_cnp_pkts`
- `ainic_tx_rdma_cnp_pkts`
- `ainic_tx_rdma_ack_timeout`
- `ainic_resp_tx_pkt_seq_err`
- `ainic_req_rx_pkt_seq_err`
- `ainic_req_rx_impl_nak_seq_err`
