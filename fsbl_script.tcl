# fsbl_script.tcl - First Stage Bootloader Generation Script for Zynq
# Usage: fsbl_script.tcl <path_to_xsa> <output_directory>

set xsa    [lindex $argv 0]
set outdir [lindex $argv 1]
set fullxsa [file normalize $xsa]
set shortxsa [file tail $fullxsa]

if { $xsa eq "" || $outdir eq "" } {
    puts "ERROR: Usage: fsbl_script.tcl <XSA_FILE> <OUTPUT_DIR>"
    exit 1
}

puts "=== FSBL Generation Started ==="
puts "XSA     : $xsa"
puts "Output  : $outdir"

# Clean previous output
file delete -force $outdir
file mkdir $outdir
file copy $fullxsa $outdir/

cd $outdir
hsi::open_hw_design $shortxsa

hsi::create_sw_design fsbl -proc psu_cortexa53_0 -os standalone
hsi::generate_app -app zynqmp_fsbl -proc psu_cortexa53_0 -dir output -compile

hsi::close_hw_design [hsi::current_hw_design]

puts "=== FSBL Generation Completed Successfully! ==="
puts "Output folder: $outdir"