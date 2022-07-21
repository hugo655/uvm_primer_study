export XCELIUM_ROOT="/home/EDA_tools/cds/XCELIUM2009"
export PATH="${PATH}:${XCELIUM_ROOT}/tools/bin"
export UVMHOME="${XCELIUM_ROOT}/tools/methodology/UVM/CDNS-1.1d"

xrun -64 -uvmhome $UVMHOME ../aux/uvm_setup.sv
