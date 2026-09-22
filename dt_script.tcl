# dt_script.tcl - Device Tree Generation Script for Zynq
# Usage: dt_script.tcl <path_to_xsa> <output_directory>

set xsa    [lindex $argv 0]
set outdir [lindex $argv 1]
set fullxsa [file normalize $xsa]
set shortxsa [file tail $fullxsa]

if { $xsa eq "" || $outdir eq "" } {
    puts "ERROR: Usage: dt_script.tcl <XSA_FILE> <OUTPUT_DIR>"
    exit 1
}

puts "=== Device Tree Generation Started ==="
puts "XSA     : $xsa"
puts "Output  : $outdir"

# Clean previous output
file delete -force $outdir
file mkdir $outdir
file copy $fullxsa $outdir/
file copy $outdir/../system-user.dtsi $outdir

cd $outdir

# Generate Device Tree
hsi::open_hw_design $shortxsa
hsi::set_repo_path "V:/VM_Drive/petalinux-v2024.2/repos/device-tree-xlnx"
hsi::create_sw_design device-tree -os device_tree -proc psu_cortexa53_0

set os [hsi::get_os]
#hsi::set_property CONFIG.include_dtsi ../system-user.dtsi $os
hsi::set_property CONFIG.dt_overlay false $os
hsi::set_property CONFIG.dt_zocl false $os
hsi::set_property CONFIG.dtg_alias true $os
hsi::set_property CONFIG.kernel_version 2024.2 $os
hsi::set_property CONFIG.remove_pl false $os
hsi::set_property CONFIG.bootargs "console=ttyPS0,115200 root=/dev/mmcblk1p2 ro rootwait" $os
hsi::set_property CONFIG.dt_setbaud 115200 $os
hsi::set_property CONFIG.console_device psu_uart_0 $os

hsi::generate_target -dir ./
hsi::close_hw_design [hsi::current_hw_design]


puts "=== Device Tree Generation Completed Successfully! ==="
puts "Output folder: $outdir"