#include <iostream>

#include <amd_smi/amdsmi.h>

#include <optional>

#include "ainic_stats.hpp"

using namespace std;

int main() {
    auto status = amdsmi_init(AMDSMI_INIT_AMD_GPUS | AMDSMI_INIT_AMD_NICS);
    ai_nic_stats_collector collector;
    collector.update_stats();

    std::size_t count{};

    nic_stats data;
    string nic{"enp229s0"};
    collector.get_data(nic, data);
    cout << "NIC data: " << data.to_string() << endl;

    return 0;
}
