#!/bin/tcsh
source ${PPU_PATH}/./vsim0/vcompile/setup.csh

##############################################################################
# Settings
##############################################################################

set IP=apb_spi_master

##############################################################################
# Check settings
##############################################################################

# check if environment variables are defined
if (! $?MSIM_LIBS_PATH ) then
  echo "${Red} MSIM_LIBS_PATH is not defined ${NC}"
  exit 1
endif

if (! $?IPS_PATH ) then
  echo "${Red} IPS_PATH is not defined ${NC}"
  exit 1
endif

set LIB_NAME="${IP}_lib"
set LIB_PATH="${MSIM_LIBS_PATH}/${LIB_NAME}"
set IP_PATH="${IPS_PATH}/apb/apb_spi_master"
set RTL_PATH="${RTL_PATH}"

##############################################################################
# Preparing library
##############################################################################

echo "${Green}--> Compiling ${IP}... ${NC}"

rm -rf $LIB_PATH

vlib $LIB_PATH
vmap $LIB_NAME $LIB_PATH

##############################################################################
# Compiling RTL
##############################################################################

echo "${Green}Compiling component: ${Brown} apb_spi_master ${NC}"
echo "${Red}"
vlog -quiet -sv -work ${LIB_PATH}    ${IP_PATH}/apb_spi_master.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}    ${IP_PATH}/spi_master_apb_if.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}    ${IP_PATH}/spi_master_clkgen.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}    ${IP_PATH}/spi_master_controller.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}    ${IP_PATH}/spi_master_fifo.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}    ${IP_PATH}/spi_master_rx.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}    ${IP_PATH}/spi_master_tx.sv || goto error

echo "${Cyan}--> ${IP} compilation complete! ${NC}"
exit 0

##############################################################################
# Error handler
##############################################################################

error:
echo "${NC}"
exit 1
