# Clock (100 MHz)

set_property PACKAGE_PIN Y9 [get_ports video_clk]

set_property IOSTANDARD LVCMOS25 [get_ports video_clk]

create_clock -period 10 [get_ports video_clk]

# Reset switch (high = reset)

set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS25} [get_ports {rst}]

# VGA sync

set_property -dict {PACKAGE_PIN V4 IOSTANDARD LVCMOS25} [get_ports {hsync}]

set_property -dict {PACKAGE_PIN U6 IOSTANDARD LVCMOS25} [get_ports {vsync}]

# R (swapped with B: board wires these pins to the blue channel)

set_property -dict {PACKAGE_PIN V5 IOSTANDARD LVCMOS25} [get_ports {r_out[3]}]

set_property -dict {PACKAGE_PIN T4 IOSTANDARD LVCMOS25} [get_ports {r_out[2]}]

set_property -dict {PACKAGE_PIN AB7 IOSTANDARD LVCMOS25} [get_ports {r_out[1]}]

set_property -dict {PACKAGE_PIN AB4 IOSTANDARD LVCMOS25} [get_ports {r_out[0]}]

# G

set_property -dict {PACKAGE_PIN AB5 IOSTANDARD LVCMOS25} [get_ports {g_out[3]}]

set_property -dict {PACKAGE_PIN AB1 IOSTANDARD LVCMOS25} [get_ports {g_out[2]}]

set_property -dict {PACKAGE_PIN AB2 IOSTANDARD LVCMOS25} [get_ports {g_out[1]}]

set_property -dict {PACKAGE_PIN AA7 IOSTANDARD LVCMOS25} [get_ports {g_out[0]}]

# B (swapped with R)

set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS25} [get_ports {b_out[3]}]

set_property -dict {PACKAGE_PIN U4 IOSTANDARD LVCMOS25} [get_ports {b_out[2]}]

set_property -dict {PACKAGE_PIN T6 IOSTANDARD LVCMOS25} [get_ports {b_out[1]}]

set_property -dict {PACKAGE_PIN R6 IOSTANDARD LVCMOS25} [get_ports {b_out[0]}]
