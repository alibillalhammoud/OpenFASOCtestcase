# # Floorplan information - core boundary coordinates, std. cell row height,
# # minimum track pitch as defined in LEF


# # POWER or GROUND #Std. cell rails starting with power or ground rails at the bottom of the core area
# set ::rails_start_with "POWER" ;

# # POWER or GROUND #Upper metal stripes starting with power or ground rails at the left/bottom of the core area
# set ::stripes_start_with "POWER" ;

# # Power nets
# set ::power_nets "VDD"
# set ::ground_nets "VSS"


# set pdngen::global_connections {
#   VDD {
#     {inst_name .* pin_name VPWR}
#     {inst_name .* pin_name VPB}
#   }
#   VSS {
#     {inst_name .* pin_name VGND}
#     {inst_name .* pin_name VNB}
#   }
# }
# ##===> Power grid strategy
# # Ensure pitches and offsets will make the stripes fall on track

# pdngen::specify_grid stdcell {
#     name grid
#     rails {
#         met1 {width 0.48 offset 0}
#     }
#     straps {
#         met4 {width 1.600 pitch 27.140 offset 13.570}
#         met5 {width 1.600 pitch 27.200 offset 13.600}
#     }
#     connect {{met1 met4} {met4 met5}}
# }

# pdngen::specify_grid macro {
#     orient {R0 R180 MX MY}
#     power_pins "VPWR"
#     ground_pins "VGND"
#     blockages "li1 met1 met2 met3 met4"
#     connect {{met4_PIN_ver met5}}
# }

# # Need a different strategy for rotated rams to connect to rotated pins
# # No clear way to do this for a 5 metal layer process
# pdngen::specify_grid macro {
#     orient {R90 R270 MXR90 MYR90}
#     power_pins "VPWR"
#     ground_pins "VGND"
#     blockages "li1 met1 met2 met3 met4"
#     connect {{met4_PIN_hor met5}}
# }
####################################
# global connections
####################################
add_global_connection -defer_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDD$} -power
add_global_connection -defer_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDDPE$}
add_global_connection -defer_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDDCE$}
add_global_connection -defer_connection -net {VDD} -inst_pattern {.*} -pin_pattern {VPWR}
add_global_connection -defer_connection -net {VDD} -inst_pattern {.*} -pin_pattern {VPB}
add_global_connection -defer_connection -net {VSS} -inst_pattern {.*} -pin_pattern {^VSS$} -ground
add_global_connection -defer_connection -net {VSS} -inst_pattern {.*} -pin_pattern {^VSSE$}
add_global_connection -defer_connection -net {VSS} -inst_pattern {.*} -pin_pattern {VGND}
add_global_connection -defer_connection -net {VSS} -inst_pattern {.*} -pin_pattern {VNB}
global_connect
####################################
# voltage domains
####################################
set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}
####################################
# standard cell grid
####################################
define_pdn_grid -name {grid} -voltage_domains {CORE}
add_pdn_stripe -grid {grid} -layer {met1} -width {0.48} -pitch {5.44} -offset {0} -followpins
add_pdn_stripe -grid {grid} -layer {met4} -width {1.600} -pitch {27.140} -offset {13.570}
add_pdn_stripe -grid {grid} -layer {met5} -width {1.600} -pitch {27.200} -offset {13.600}
add_pdn_connect -grid {grid} -layers {met1 met4}
add_pdn_connect -grid {grid} -layers {met4 met5}
####################################
# macro grids
####################################
####################################
# grid for: CORE_macro_grid_1
####################################
define_pdn_grid -name {CORE_macro_grid_1} -voltage_domains {CORE} -macro -orient {R0 R180 MX MY} -halo {2.0 2.0 2.0 2.0} -default -grid_over_boundary
add_pdn_connect -grid {CORE_macro_grid_1} -layers {met4 met5}
####################################
# grid for: CORE_macro_grid_2
####################################
define_pdn_grid -name {CORE_macro_grid_2} -voltage_domains {CORE} -macro -orient {R90 R270 MXR90 MYR90} -halo {2.0 2.0 2.0 2.0} -default -grid_over_boundary
add_pdn_connect -grid {CORE_macro_grid_2} -layers {met4 met5}
Footer
© 2022 GitHub, Inc.
Footer navigation
Terms