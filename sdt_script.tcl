# sdt_script.tcl - System Device Tree Generation Script for Zynq
# Usage: xsct.bat sdt_script.tcl <path_to_xsa> <output_directory>

set xsa    [lindex $argv 0]
set outdir [lindex $argv 1]

if { $xsa eq "" || $outdir eq "" } {
    puts "ERROR: Usage: sdt_script.tcl <XSA_FILE> <OUTPUT_DIR>"
    exit 1
}

puts "=== SDT Generation Started ==="
puts "XSA     : $xsa"
puts "Output  : $outdir"

# Clean previous output
file delete -force $outdir
file mkdir $outdir

# Set parameters (you can put everything in one line)
sdtgen set_dt_param \
	-xsa $xsa \
	-dir $outdir \
	-include_dts ./system-user.dtsi \
	-zocl enable \
	-trace enable \
	-debug enable

# Generate the System Device Tree
sdtgen generate_sdt

#cd $outdir
#exec C:/Xilinx/Vitis/2024.2/gnu/aarch64/nt/aarch64-linux/bin/aarch64-linux-gnu-g++ -nostdinc -undef -x assembler-with-cpp -I. -Iinclude system-top.dts > system.dts

puts "=== SDT Generation Completed Successfully! ==="
puts "Output folder: $outdir"