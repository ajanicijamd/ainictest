# ainictest

Scripts and configuration files for testing AI NIC profiling

[rocprof-sys.cfg](https://github.com/ajanicijamd/ainictest/blob/main/rocprof-sys.cfg)
is an example rocprofiler-systems configuration file. The setting used for AI NIC
is ROCPROFSYS_SAMPLING_AINICS. This parameter defines the list of NICs that we want
to profile.

[setenv.sh](https://github.com/ajanicijamd/ainictest/blob/main/setenv.sh) is a Bash script
that sets environment variables for rocprofiler-systems tools. Note the variable
ROCPROFSYS_CONFIG_FILE that points to the configuration file. In a shell, cd to the
directory where these files are and run setenv.sh to set up the environment:

    . ./setenv.sh

[runtest.sh](https://github.com/ajanicijamd/ainictest/blob/main/runtest.sh) is a Bash
script for running rocprof-sys-sample for profiling. It demonstrates one possible way to
test AI NIC profiling: running rocprof-sys-sample with wget as the program to sample.
The list of NICs is passed to rocprof-sys-sample via --ai-nics. An example command looks
like this:

    rocprof-sys-sample --gpus=0,1 --ai-nics=enp229s0 --device -- wget -O /dev/null --no-check-certificate $URL1 $URL2

where we pass in one NIC (enp229s0) in the parameter.

The list of NICs passed in via variable ROCPROFSYS_SAMPLING_AINICS and command line parameter
--ai-nics can be:

- In the form nic1,nic2,nic3 - comma-separated list of NICs
- all - profile all available NICs
- none - don't profile any NICs

This list of NICs can be specified in three ways, from the lowest to the highest priority:

- In ROCPROFSYS_SAMPLING_AINICS in a configuration file
- In ROCPROFSYS_SAMPLING_AINICS in the environment
- In the command line parameter --ai-nics


## pytest ? End-to-End Track Validation

The [`pytest/`](pytest/) directory contains a self-contained pytest suite that verifies
all 10 AI NIC RDMA counter tracks are correctly written to both the Perfetto trace
(`.proto`) and the ROCpd database (`.db`) by rocprofiler-systems.

This is used to prove that the fix in `cache_policy.hpp` (added in
`rocm-systems` develop on June 16, 2026) is effective: before the fix, 4 of the 10
tracks were silently absent from every output file.

### The 10 RDMA tracks

| Track name | Description |
|---|---|
| `ainic_rx_rdma_ucast_bytes` | Received unicast bytes |
| `ainic_tx_rdma_ucast_bytes` | Transmitted unicast bytes |
| `ainic_rx_rdma_ucast_pkts` | Received unicast packets |
| `ainic_tx_rdma_ucast_pkts` | Transmitted unicast packets |
| `ainic_rx_rdma_cnp_pkts` | Received CNP (congestion) packets |
| `ainic_tx_rdma_cnp_pkts` | Transmitted CNP packets |
| `ainic_tx_rdma_ack_timeout` | Local ACK timeout errors *(previously missing)* |
| `ainic_resp_tx_pkt_seq_err` | Responder packet sequence errors *(previously missing)* |
| `ainic_req_rx_pkt_seq_err` | Requester packet sequence errors *(previously missing)* |
| `ainic_req_rx_impl_nak_seq_err` | Requester implicit NAK sequence errors *(previously missing)* |

### Quick start

```bash
cd pytest
pip install -r requirements.txt

# With rocprof-sys-sample already on PATH (installed from /opt/rocm):
pytest test_ainic_perf.py -v -m ainic

# Or, pointing at a custom build directory:
ROCPROFSYS_BUILD_DIR=/path/to/rocprofiler-systems/build \
    pytest test_ainic_perf.py -v -m ainic
```

See [`pytest/README.md`](pytest/README.md) for full details, including how to run
against the AI NIC simulator (no real hardware required).
