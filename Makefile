include Rules.make

.PHONY:	components components_clean components_linux all clean help linux linux_clean linux_install install u-boot u-boot_clean u-boot_install

#==============================================================================
# Build everything rebuildable.
#==============================================================================
all: components apps

#==============================================================================
# Build components to enable all other build targets.
#==============================================================================
components: components_linux components_ipu
components_linux: linux
components_ipu: ipumm

#==============================================================================
# Install components
#==============================================================================
components_install: linux_install ipumm_install

#==============================================================================
# Clean up the targets built by 'make all'.
#==============================================================================
components_clean: linux_clean ipumm_clean

#==============================================================================
# Build all Demos, Examples and Applications
#==============================================================================
apps: u-boot

#==============================================================================
# Install everything
#==============================================================================
apps_install: u-boot_install

#==============================================================================
# Clean all Demos, Examples and Applications
#==============================================================================
apps_clean: u-boot_clean

#==============================================================================
# Install everything
#==============================================================================
install: components_install apps_install
#==============================================================================
# Clean up all targets.
#==============================================================================
clean: components_clean apps_clean

#==============================================================================
# A help message target.
#==============================================================================
help:
	@echo
	@echo "Available build targets are  :"
	@echo
	@echo "    components_linux               : Build the Linux components"
	@echo "    components_ipu                 : Build the IPU components"
	@echo "    components                     : Build the components for which a rebuild is necessary to enable all other build targets listed below. You must do this at least once upon installation prior to attempting the other targets."
	@echo "    components_clean               : Remove files generated by the 'components' target"
	@echo
	@echo "    apps                           : Build all Examples, Demos and Applications"
	@echo "    apps_clean                     : Remove all files generated by 'apps' target"
	@echo "    install                        : Install all Examples, Demos and Applications the targets in $(EXEC_DIR)"
	@echo
	@echo
	@echo "    linux                          : Build Linux kernel uImage and module"
	@echo "    linux_clean                    : Remove generated Linux kernel files"
	@echo "    linux_install                  : Install kernel binary and  modules"
	@echo
	@echo "    u-boot                         : Build the u-boot boot loader"
	@echo "    u-boot_clean                   : Remove generated u-boot files"
	@echo "    u-boot_install                 : Install the u-boot image"
	@echo
	@echo "    ipumm                          : Build the ipumm firmware"
	@echo "    ipumm_clean                    : Remove generated ipumm files"
	@echo "    ipumm_install                  : Install the ipumm firmware"
	@echo
	@echo
	@echo
	@echo "    all                            : Rebuild everything"
	@echo "    clean                          : Remove all generated files"
	@echo
	@echo "    install                        : Install all the targets in "
	@echo "                            $(EXEC_DIR)"
	@echo

#==============================================================================
# Build the Linux kernel. Also, an explicit cleanup target is defined.
#==============================================================================
linux:
	$(MAKE) -C $(LINUXKERNEL_INSTALL_DIR) $(LINUXKERNEL_BUILD_VARS) $(DEFAULT_LINUXKERNEL_CONFIG)
	$(MAKE) -C $(LINUXKERNEL_INSTALL_DIR) $(LINUXKERNEL_BUILD_VARS) uImage
	$(MAKE) -C $(LINUXKERNEL_INSTALL_DIR) $(LINUXKERNEL_BUILD_VARS) modules
	$(MAKE) -C $(LINUXKERNEL_INSTALL_DIR) $(LINUXKERNEL_BUILD_VARS) $(DEFAULT_DTB_NAME)

linux_clean:
	$(MAKE) -C $(LINUXKERNEL_INSTALL_DIR) mrproper
	$(MAKE) -C $(LINUXKERNEL_INSTALL_DIR) $(LINUXKERNEL_BUILD_VARS) clean

linux_install:
	install -d $(EXEC_DIR)/boot
	install  $(LINUXKERNEL_INSTALL_DIR)/arch/arm/boot/uImage $(EXEC_DIR)/boot
	install  $(LINUXKERNEL_INSTALL_DIR)/arch/arm/boot/dts/$(DEFAULT_DTB_NAME) $(EXEC_DIR)/boot
	install  $(LINUXKERNEL_INSTALL_DIR)/vmlinux $(EXEC_DIR)/boot
	install  $(LINUXKERNEL_INSTALL_DIR)/System.map $(EXEC_DIR)/boot
	$(MAKE) -C $(LINUXKERNEL_INSTALL_DIR) $(LINUXKERNEL_BUILD_VARS) INSTALL_MOD_PATH=$(EXEC_DIR)/ modules_install

#==============================================================================
# Build u-boot. Also, an explicit cleanup target is defined.
#==============================================================================
u-boot:
	$(MAKE) -C $(UBOOT_INSTALL_DIR) $(UBOOT_BUILD_VARS) $(DEFAULT_UBOOT_CONFIG)
	$(MAKE) -C $(UBOOT_INSTALL_DIR) $(UBOOT_BUILD_VARS)

u-boot_clean:
	$(MAKE) -C $(UBOOT_INSTALL_DIR) $(UBOOT_BUILD_VARS) distclean

u-boot_install:
	install -d $(EXEC_DIR)/boot
	install $(UBOOT_INSTALL_DIR)/MLO $(EXEC_DIR)/boot
	install $(UBOOT_INSTALL_DIR)/u-boot.img $(EXEC_DIR)/boot
	install $(UBOOT_INSTALL_DIR)/u-boot.map $(EXEC_DIR)/boot

#==============================================================================
# Build ipumm. Also, an explicit cleanup target is defined.
#==============================================================================
ipumm:
	sed -i -e "s#^TOOLCHAIN_LONGNAME.*#TOOLCHAIN_LONGNAME = arm-linux-gnueabihf#" ${IPC_INSTALL_DIR}/products.mak
	sed -i -e "s#^KERNEL_INSTALL_DIR.*#KERNEL_INSTALL_DIR = $(LINUXKERNEL_INSTALL_DIR)#" $(IPC_INSTALL_DIR)/products.mak
	sed -i -e "s#^TOOLCHAIN_INSTALL_DIR.*#TOOLCHAIN_INSTALL_DIR = ${TOOLCHAIN_INSTALL_DIR}#" ${IPC_INSTALL_DIR}/products.mak
	sed -i -e "s#^PLATFORM.*#PLATFORM = ${PLATFORM_IPC}#" ${IPC_INSTALL_DIR}/products.mak
	sed -i -e "s#^PREFIX ?=.*#PREFIX = /usr#" ${IPC_INSTALL_DIR}/products.mak
	sed -i -e "s#^ti.targets.arm.elf.M4 .*#ti.targets.arm.elf.M4 = ${TMS470CGTOOLPATH_INSTALL_DIR}#" ${IPC_INSTALL_DIR}/products.mak
	$(MAKE) -C $(IPC_INSTALL_DIR) $(IPC_BUILD_VARS) -f ipc-bios.mak all
	$(MAKE) -C $(IPUMM_INSTALL_DIR) $(IPUMM_BUILD_VARS) $(DEFAULT_IPUMM_CONFIG)
	$(MAKE) -C $(IPUMM_INSTALL_DIR) $(IPUMM_BUILD_VARS)

ipumm_clean:
	$(MAKE) -C $(IPUMM_INSTALL_DIR) $(IPUMM_BUILD_VARS) clean
	$(MAKE) -C $(IPC_INSTALL_DIR) $(IPC_BUILD_VARS) -f ipc-bios.mak clean

ipumm_install:
	install -d $(EXEC_DIR)/lib/firmware
	install  $(IPUMM_INSTALL_DIR)/$(DUCATI_FW_GEN) $(EXEC_DIR)/lib/firmware/$(DUCATI_FW)
