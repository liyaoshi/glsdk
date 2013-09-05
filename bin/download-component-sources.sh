#!/bin/sh

#Component Sources versions:
IPC_VERSION="3_00_02_26"		# This will change later
FRAMEWORK_COMP_VERSION="3_24_00_09"
CODEC_ENGINE_VERSION="3_24_00_08"
OSAL_VERSION="1_24_00_09"
XDAIS_VERSION="7_24_00_04"
BIOS_VERSION="6_35_02_45"
XDCTOOLS_VERSION="3_25_02_70"

IPC_WGET_URL="http://downloads.ti.com/dsps/dsps_public_sw/sdo_sb/targetcontent/ipc/$IPC_VERSION/exports/ipc_$IPC_VERSION.zip"
FRAMEWORK_COMP_WGET_URL="http://downloads.ti.com/dsps/dsps_public_sw/sdo_sb/targetcontent/fc/$FRAMEWORK_COMP_VERSION/exports/framework_components_$FRAMEWORK_COMP_VERSION.tar.gz"
CODEC_ENGINE_WGET_URL="http://downloads.ti.com/dsps/dsps_public_sw/sdo_sb/targetcontent/ce/$CODEC_ENGINE_VERSION/exports/codec_engine_$CODEC_ENGINE_VERSION.tar.gz"
OSAL_WGET_URL="http://downloads.ti.com/dsps/dsps_public_sw/sdo_sb/targetcontent/osal/$OSAL_VERSION/exports/osal_$OSAL_VERSION.tar.gz"
XDAIS_WGET_URL="http://downloads.ti.com/dsps/dsps_public_sw/sdo_sb/targetcontent/xdais/$XDAIS_VERSION/exports/xdais_$XDAIS_VERSION.tar.gz"
BIOS_WGET_URL="http://downloads.ti.com/dsps/dsps_public_sw/sdo_sb/targetcontent/bios/sysbios/$BIOS_VERSION/exports/bios_setuplinux_$BIOS_VERSION.bin"
XDCTOOLS_WGET_URL="http://downloads.ti.com/dsps/dsps_public_sw/sdo_sb/targetcontent/rtsc/$XDCTOOLS_VERSION/exports/xdctools_setuplinux_$XDCTOOLS_VERSION.bin"

if [ ! -d "component-sources" ]; then
	mkdir "component-sources"
fi
if [ ! -d "component-sources/ipc_$IPC_VERSION" ]; then
	wget -nc $IPC_WGET_URL
	echo "Extracting IPC..."
	unzip ipc_$IPC_VERSION.zip -d component-sources > /dev/null
	mv ipc*.zip component-sources/
fi
if [ ! -d "component-sources/framework_components_$FRAMEWORK_COMP_VERSION" ]; then
	wget -nc $FRAMEWORK_COMP_WGET_URL
	echo "Extracting framework components..."
	tar -zxf framework_components_$FRAMEWORK_COMP_VERSION.tar.gz -C component-sources/
	mv framework_components*.tar.gz component-sources/
fi
if [ ! -d "component-sources/codec_engine_$CODEC_ENGINE_VERSION" ]; then
	wget -nc $CODEC_ENGINE_WGET_URL
	echo "Extracting codec engine..."
	tar -zxf codec_engine_$CODEC_ENGINE_VERSION.tar.gz -C component-sources/
	mv codec_engine*.tar.gz component-sources/
fi
if [ ! -d "component-sources/osal_$OSAL_VERSION" ]; then
	wget -nc $OSAL_WGET_URL
	echo "Extracting OSAL..."
	tar -zxf osal_$OSAL_VERSION.tar.gz -C component-sources/
	mv osal*.tar.gz component-sources/
fi
if [ ! -d "component-sources/xdais_$XDAIS_VERSION" ]; then
	wget -nc $XDAIS_WGET_URL
	echo "Extracting XDAIS..."
	tar -zxf xdais_$XDAIS_VERSION.tar.gz -C component-sources/
	mv xdais*.tar.gz component-sources/
fi
if [ ! -d "component-sources/bios_$BIOS_VERSION" ]; then
	wget -nc $BIOS_WGET_URL
	echo "Installing BIOS..."
	chmod +x bios_setuplinux_$BIOS_VERSION.bin
	./bios_setuplinux_$BIOS_VERSION.bin --prefix ./component-sources/ --mode unattended
	mv bios_setuplinux*.bin component-sources/
fi
if [ ! -d "component-sources/xdctools_$XDCTOOLS_VERSION" ]; then
	wget -nc $XDCTOOLS_WGET_URL
	echo "Installing XDC tools..."
	chmod +x xdctools_setuplinux_$XDCTOOLS_VERSION.bin
	./xdctools_setuplinux_$XDCTOOLS_VERSION.bin --prefix ./component-sources/ --mode silent
	mv xdctools_setuplinux*.bin component-sources/
fi