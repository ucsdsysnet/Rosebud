#!/bin/bash

# Copyright (c) 2020 Alex Forencich
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

cmd_help() {
    echo "Usage: $(basename $0) <command> [options] [bitfile]"
    echo ""
    echo "Commands:"
    echo "    list    List targets"
    echo "    enum    Enumerate JTAG chain"
    echo "    prog    Program FPGA with bitfile"
    echo "    boot    Reset FPGA"
    echo "    status  Print device status"
    echo ""
    echo "Common options:"
    echo "    --server_url      hardware server URL"
    echo "    --target          target pattern (board, default *)"
    echo "    --target_index    target index (board, default 0)"
    echo "    --device_index    device index (device in chain, default 0)"
    echo ""
    echo "For help with a subcommand, run:"
    echo "$(basename $0) <command> -h|--help"
    echo ""
}

parse_args() {
    server_url="localhost"
    target="*"
    target_index=0
    device_index=0

    while getopts h-: option; do
        case "${option}" in
            -)
                case "${OPTARG}" in
                    server)
                        server_url="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                        ;;
                    server=*)
                        server_url=${OPTARG#*=}
                        ;;
                    target)
                        target="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                        ;;
                    target=*)
                        target=${OPTARG#*=}
                        ;;
                    target_index)
                        target_index="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                        ;;
                    target_index=*)
                        target_index=${OPTARG#*=}
                        ;;
                    device_index)
                        device_index="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                        ;;
                    device_index=*)
                        device_index=${OPTARG#*=}
                        ;;
                    help)
                        cmd_help
                        exit 0
                        ;;
                    *)
                        if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                            echo "Unknown option --${OPTARG}" >&2
                            cmd_help
                            exit 1
                        fi
                        ;;
                esac;;
            h)
                cmd_help
                exit 0
                ;;
        esac
    done
    arg_shift=$((OPTIND -1))
}

cmd_list() {
    parse_args $@
    shift $arg_shift

    tcl=$(mktemp)
    trap "rm -f $tcl" 0 2 3 15

	echo "open_hw_manager" > $tcl
    echo "connect_hw_server -url {$server_url}" >> $tcl
	echo "set list [get_hw_targets {$target}]" >> $tcl
	echo "for { set i 0 } { \$i < [llength \$list] } { incr i } {" >> $tcl
    echo "    set x [lindex \$list \$i]" >> $tcl
	echo "    puts \"Target index \$i: \$x\"" >> $tcl
	echo "}" >> $tcl
	echo "exit" >> $tcl
	vivado -nojournal -nolog -quiet -notrace -mode batch -source $tcl
}

cmd_enum() {
    parse_args $@
    shift $arg_shift

    tcl=$(mktemp)
    trap "rm -f $tcl" 0 2 3 15

    echo "open_hw_manager" > $tcl
    echo "connect_hw_server -url {$server_url}" >> $tcl
    echo "open_hw_target [lindex [get_hw_targets {$target}] $target_index]" >> $tcl
    echo "set list [get_hw_devices]" >> $tcl
    echo "for { set i 0 } { \$i < [llength \$list] } { incr i } {" >> $tcl
    echo "    set x [lindex \$list \$i]" >> $tcl
    echo "    puts \"Index \$i: \$x\"" >> $tcl
    echo "}" >> $tcl
    echo "exit" >> $tcl
    vivado -nojournal -nolog -quiet -notrace -mode batch -source $tcl
}

cmd_prog() {
    parse_args $@
    shift $arg_shift

    bitfile=$1

    if [ -z "$bitfile" ]; then
        echo "Error: bitfile not specified"
        exit 1
    fi

    tcl=$(mktemp)
    trap "rm -f $tcl" 0 2 3 15

	echo "open_hw_manager" > $tcl
    echo "connect_hw_server -url {$server_url}" >> $tcl
    echo "open_hw_target [lindex [get_hw_targets {$target}] $target_index]" >> $tcl
	echo "current_hw_device [lindex [get_hw_devices] $device_index]" >> $tcl
	echo "refresh_hw_device -update_hw_probes false [current_hw_device]" >> $tcl
	echo "set_property PROGRAM.FILE {$bitfile} [current_hw_device]" >> $tcl
	echo "program_hw_devices [current_hw_device]" >> $tcl
	echo "exit" >> $tcl
	vivado -nojournal -nolog -quiet -notrace -mode batch -source $tcl
}

cmd_boot() {
    parse_args $@
    shift $arg_shift

    tcl=$(mktemp)
    trap "rm -f $tcl" 0 2 3 15

    echo "open_hw_manager" > $tcl
    echo "connect_hw_server -url {$server_url}" >> $tcl
    echo "open_hw_target [lindex [get_hw_targets {$target}] $target_index]" >> $tcl
    echo "current_hw_device [lindex [get_hw_devices] $device_index]" >> $tcl
    echo "refresh_hw_device -update_hw_probes false [current_hw_device]" >> $tcl
    echo "boot_hw_device [current_hw_device]" >> $tcl
    echo "exit" >> $tcl
    vivado -nojournal -nolog -quiet -notrace -mode batch -source $tcl
}

cmd_status() {
    parse_args $@
    shift $arg_shift

    tcl=$(mktemp)
    trap "rm -f $tcl" 0 2 3 15

    echo "open_hw_manager" > $tcl
    echo "connect_hw_server -url {$server_url}" >> $tcl
    echo "open_hw_target [lindex [get_hw_targets {$target}] $target_index]" >> $tcl
    echo "current_hw_device [lindex [get_hw_devices] $device_index]" >> $tcl
    echo "refresh_hw_device -update_hw_probes false [current_hw_device]" >> $tcl
    echo "report_property [current_hw_device]" >> $tcl
    echo "set sysmon [get_hw_sysmons -of_objects [current_hw_device]]" >> $tcl
    echo "puts \"Sysmon instance \$sysmon\"" >> $tcl
    echo "set props [list_property \$sysmon {TEMPERATURE}]" >> $tcl
    echo "set props [concat \$props [list_property \$sysmon {VCC*}]]" >> $tcl
    echo "foreach prop \$props {" >> $tcl
    echo "    puts \"\$prop: [get_property \$prop \$sysmon]\"" >> $tcl
    echo "}" >> $tcl
    echo "exit" >> $tcl
    vivado -nojournal -nolog -quiet -notrace -mode batch -source $tcl
}

cmd=$1
case $cmd in
    "" | "-h" | "--help")
        cmd_help
        ;;
    *)
        shift
        if [[ $(type -t "cmd_${cmd}") == 'function' ]]; then
            cmd_${cmd} $@
        else
            echo "Error: '$cmd' is not a known command." >&2
            cmd_help
            exit 1
        fi
        ;;
esac
