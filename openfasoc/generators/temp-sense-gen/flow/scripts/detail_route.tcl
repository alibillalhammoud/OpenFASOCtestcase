if {![info exists standalone] || $standalone} {
  # Read lef
   if [info exists ::env(GENERIC_TECH_LEF)] {
    read_lef $::env(GENERIC_TECH_LEF)
  } else {
    read_lef $::env(TECH_LEF)
  }
  read_lef $::env(SC_LEF)
  if {[info exist ::env(ADDITIONAL_LEFS)]} {
    foreach lef $::env(ADDITIONAL_LEFS) {
      read_lef $lef
    }
  }
  # Read liberty files
  foreach libFile $::env(LIB_FILES) {
    read_liberty $libFile
  }

  # Read design files
  if { [info exists ::env(USE_WXL)]} {
  read_def $::env(RESULTS_DIR)/4_cts.def
  } else {
  read_def $::env(RESULTS_DIR)/5_1_route_gr.def
  }


} else {
  puts "Starting detailed routing"
}

# set_propagated_clock [all_clocks]
set_thread_count $::env(NUM_CORES)

set additional_args ""
if { ![info exists ::env(USE_WXL)]} {
  read_guides $::env(RESULTS_DIR)/route.guide
   }

if { [info exists ::env(dbProcessNode)]} {
  append additional_args " -db_process_node $::env(dbProcessNode)"
}

detailed_route -output_drc $::env(REPORTS_DIR)/5_route_drc.rpt \
               -output_guide $::env(RESULTS_DIR)/output_guide.mod \
               -output_maze $::env(RESULTS_DIR)/maze.log \
               -verbose 1 \
               {*}$additional_args


write_def $::env(RESULTS_DIR)/5_route.def
if {![info exists standalone] || $standalone} {
  exit
}
