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
