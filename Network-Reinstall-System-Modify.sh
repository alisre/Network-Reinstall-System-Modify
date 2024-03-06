#!/bin/bash

## License: GPL
## The CXT Version of one-click network reinstallation system Magic revision.
## It can reinstall CentOS, Rocky, Debian, Ubuntu, Oracle and other General Operating Systems (continuously added) via the network in one click.
## It can reinstall Windwos 2022, 2019, 2016, 2012R2, Windows 10, 11 and other Windows systems (continuously added) via the network in one click.
## Support GRUB or GRUB2 for installing a clean minimal system.
## Technical support is provided by the CXT (CXTHHHHH.com). (based on the original Version of Vicer)

## Magic Modify Version author:
## Default root password: cxthhhhh.com
## WebSite: https://cxthhhhh.com
## Written By CXT (CXTHHHHH.com)

## Original Version author:
## Blog: https://moeclub.org
## Written By MoeClub.org (Vicer)

CXTaddLine="$1"
CXTaddVER=""
CXTisUEFI=""
CXTmyipapi=""
CXTisCN="No"

if [[ $EUID -ne 0 ]]; then
    clear
    echo "错误: 重装脚本必须使用root权限执行" 1>&2
    echo "Error: This Reinstall script must be run as root!" 1>&2
    exit 1
fi

echo -e "\n\n\n"
clear
echo -e "\n"
echo "---------------------------------------------------------------------------------------------------------------------"
echo -e "\033[33m 一键网络重装系统 - 魔改版 版本：V5.3.0 更新：2022年07月18日 \033[0m"
echo -e "\033[33m Network-Reinstall-System-Modify Tools V5.3.0 2022/07/18 \033[0m"
echo "---------------------------------------------------------------------------------------------------------------------"
echo -e "\033[33m 一键网络重装系统 - 魔改版（适用于Linux / Windows） \033[0m"
echo -e "\033[33m 系统需求: 任何带有GRUB或GRUB2的Linux操作系统即可运行, 当前推荐安装的系统为： Rocky8/Debian11/Ubuntu22 \033[0m"
echo -e "\n"
echo -e "\033[33m [Magic Modify] Reinstall the system (any Windows / Linux) requires only network and one click \033[0m"
echo -e "\033[33m System requirements: Any Linux system with GRUB or GRUB2, recommended Rocky8/Debian11/Ubuntu22 \033[0m"
echo -e "\n"
echo -e "\033[33m 官方更新地址（Official update address）：CXT - Enjoy Life | 生活、技术、交友、分享 \033[0m"
echo -e "\033[33m https://cxthhhhh.com/Network-Reinstall-System-Modify \033[0m"
echo "---------------------------------------------------------------------------------------------------------------------"
echo " 默认密码: autosre.xyz"
echo " Default password: autosre.xyz"
echo "---------------------------------------------------------------------------------------------------------------------"
echo -e "\n"
sleep 6s

echo "---------------------------------------------------------------------------------------------------------------------"
echo " 对当前系统环境进行处理. . ."
echo " Pre-environment preparation. . ."
echo "---------------------------------------------------------------------------------------------------------------------"
echo -e "\n"
sleep 2s

if [ -f "/usr/bin/apt-get" ];then
	isDebian=`cat /etc/issue|grep Debian`
	if [ "$isDebian" != "" ];then
		echo '当前系统 是 Debian'
		echo 'Current system is Debian'
		apt-get install -y xz-utils openssl gawk file wget curl
		apt install -y xz-utils openssl gawk file wget curl
		sleep 3s
	else
		echo '当前系统 是 Ubuntu'
		echo 'Current system is Ubuntu'
		apt-get install -y xz-utils openssl gawk file wget curl
		apt install -y xz-utils openssl gawk file wget curl
		sleep 3s
	fi
else
    echo '当前系统 是 CentOS/Rocky/Oracle/RHEL'
    echo 'Current system is CentOS/Rocky/Oracle/RHEL'
    yum install -y xz openssl gawk file wget curl
    dnf install -y xz openssl gawk file wget curl
    sleep 3s
fi

echo "---------------------------------------------------------------------------------------------------------------------"
echo " 对当前系统环境进行处理. . .  【OK】"
echo " Pre-environment preparation. . .  【OK】"
echo -e "\n"
echo " 检测系统信息. . . "
echo " Detection system information. . . "
echo "---------------------------------------------------------------------------------------------------------------------"
echo -e "\n"
sleep 1s

CXTDTYPE=`fdisk -l | grep -o gpt | head -1`
if [ -n $CXTDTYPE ] && { [ $CXTDTYPE == "gpt" ] || [ $CXTDTYPE == "GPT" ] ;};then
    echo "UEFI..."
    CXTisUEFI="是(True)"
else
    echo "Legacy..."
    CXTisUEFI="否(False)"
fi

case `uname -m` in aarch64|arm64) CXTaddVER="arm64";; x86|i386|i686) CXTaddVER="i386";; x86_64|amd64) CXTaddVER="amd64";; *) CXTaddVER="";; esac

CXTmyipapi=$(wget --no-check-certificate -qO- ipinfo.io | grep "\"country\": \"CN\"")
if [[ "$CXTmyipapi" != "" ]];then
    CXTisCN="Yes"
fi
if [ $CXTisCN != "Yes" ];then
    echo "Core Download（Global）..."
    #wget -O
    wget --no-check-certificate -qO ~/Core_Install.sh 'https://github.com/auto-sre/Network-Reinstall-System-Modify/raw/master/CoreShell/Core_Install_v5.3.sh' && chmod a+x ~/Core_Install.sh
    CentOSMirrors=""
    CentOSVaultMirrors=""
    DebianMirrors=""
    UbuntuMirrors=""
else
    echo "Core Download（CN）..."
    #wget -O
    wget --no-check-certificate -qO ~/Core_Install.sh 'https://mirror.ghproxy.com/https://github.com/auto-sre/Network-Reinstall-System-Modify/raw/master/CoreShell/Core_Install_v5.3.sh' && chmod a+x ~/Core_Install.sh
    CXTrandom=$RANDOM
    if [ $[CXTrandom%2] == "0" ];then
        echo "本次随机使用163源"
        CentOSMirrors="--mirror http://mirrors.163.com/centos"
        CentOSVaultMirrors="--mirror http://mirrors.163.com/centos-vault"
        DebianMirrors="--mirror http://mirrors.163.com/debian"
        UbuntuMirrors="--mirror http://mirrors.163.com/ubuntu"
    else
        echo "本次随机使用清华源"
        CentOSMirrors="--mirror http://mirrors.tuna.tsinghua.edu.cn/centos"
        CentOSVaultMirrors="--mirror http://mirrors.tuna.tsinghua.edu.cn/centos-vault"
        DebianMirrors="--mirror http://mirrors.tuna.tsinghua.edu.cn/debian"
        UbuntuMirrors="--mirror http://mirrors.tuna.tsinghua.edu.cn/ubuntu"
    fi
    CXTaddLine="--ip-dns \"223.5.5.5 119.29.29.29\""

fi

ORG=$(wget --no-check-certificate -qO- ipinfo.io | grep "\"org\":")
if [ $CXTisCN == "Yes" ] && echo $ORG |grep Tencent > /dev/null 2>&1;then
    [ -z $CXTaddLine ] && CXTaddLine="--ip-dns \"183.60.83.19 183.60.82.98\""
    CentOSMirrors="--mirror http://mirrors.tencentyun.com/centos"
    CentOSVaultMirrors="--mirror http://mirrors.tencentyun.com/centos-vault"
    DebianMirrors="--mirror http://mirrors.tencentyun.com/debian"
    UbuntuMirrors="--mirror http://mirrors.tencentyun.com/ubuntu"
elif [ $CXTisCN == "Yes" ] && echo $ORG |grep Alibaba > /dev/null 2>&1 && [ $CXTisCN == "Yes" ];then
    [ -z $CXTaddLine ] && CXTaddLine="--ip-dns \"223.5.5.5 223.6.6.6\""
    CentOSMirrors="--mirror http://mirrors.cloud.aliyuncs.com/centos"
    CentOSVaultMirrors="--mirror http://mirrors.cloud.aliyuncs.com/centos-vault"
    DebianMirrors="--mirror http://mirrors.cloud.aliyuncs.com/debian"
    UbuntuMirrors="--mirror http://mirrors.cloud.aliyuncs.com/ubuntu"
elif [ $CXTisCN == "Yes" ] && echo $ORG |grep Huawei > /dev/null 2>&1;then
    ResIp=$(grep "nameserver " /etc/resolv.conf|grep -v '127.0.0'|head -1|awk '{print $2}')
    if [ -z $ResIp ] ;then
       ResIp=$(grep "nameserver " /run/systemd/resolve/resolv.conf|grep -v '127.0.0'|head -1|awk '{print $2}')
    fi
    CXTaddLine="--ip-dns $ResIp"
    CentOSMirrors="--mirror https://mirrors.huaweicloud.com/centos"
    CentOSVaultMirrors="--mirror https://mirrors.huaweicloud.com/centos-vault"
    DebianMirrors="--mirror https://mirrors.huaweicloud.com/debian"
    UbuntuMirrors="--mirror https://mirrors.huaweicloud.com/ubuntu"
fi

echo "---------------------------------------------------------------------------------------------------------------------"
echo " 系统信息如下. . .  【OK】"
echo " System information is as follows. . .  【OK】"
echo -e "\n"
echo "你的系统架构是：$CXTaddVER"
echo "Your system firmware architecture is: $CXTaddVER"
echo -e "\n"
echo "你的设备启动类型是UEFI：$CXTisUEFI"
echo "Your device Startup type is UEFI: $CXTisUEFI"
echo -e "\n"
echo "使用大陆加速：$CXTisCN"
echo "Accelerating Chinese mainland with CDN: $CXTisCN"
echo -e "\n"
echo " 启动系统安装. . . "
echo " Start system installation. . . "
echo "---------------------------------------------------------------------------------------------------------------------"
echo -e "\n"
sleep 3s

if [ $CXTaddVER == "arm64" ];then
echo "打印ARM64菜单"
echo -e "\n"
clear
echo -e "\n\n\n"
clear
echo -e "\n"
echo "                                                           "
echo "================================================================"
echo "=                                                              ="
echo "=           一键网络重装系统 - 魔改版（ARM64安装）                ="
echo "=        Network-Reinstall-System-Modify (Graphical Install)   ="
echo "=                                                              ="
echo "=             V5.3.0             https://www.cxthhhhh.com      ="
echo "=                                                              ="
echo "================================================================"
echo "                                                                "
echo "您想安装哪个系统(Which System want to Install): "
echo "                                                                "
  echo "   1) AlmaLinux 9(ARM64)"
  echo "   2) CentOS 7(ARM64)【Recommend】"
  echo "   3) Debian 11(ARM64)【Recommend】"
  echo "   4) Debian 10(ARM64)"
  echo "   5) Fedora 36(ARM64)"
  echo "   6) Oracle 9(ARM64)"
  echo "   7) Rocky 9(ARM64)【Recommend】"
  echo "   8) Rocky 8(ARM64)"
  echo "   9) Ubuntu 22(ARM64)【Recommend】"
  echo "   10) Ubuntu 20(ARM64)"
  echo "   99) 更多系统(More System)"
  echo "   100) 裸机系统部署平台(高级用户)"
  echo "   100) Bare-metal System Deployment Platform(Advanced Users)"
  echo "   0) Exit"
  echo -ne "\n请选择(Your option): "
  echo "                                                                "
  read N
  case $N in
    1) echo -e "\nInstall...AlmaLinux 9(ARM64)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v arm64 -dd "https://odc.cxthhhhh.com/d/SyStem/AlmaLinux/AlmaLinux_9_ARM64_UEFI_NetInstallation_Stable_1.6.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    2) echo -e "\nInstall...CentOS 7(ARM64)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v arm64 -dd "https://odc.cxthhhhh.com/d/SyStem/CentOS/CentOS_7.X_ARM64_UEFI_NetInstallation_Final_v9.11.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    3) echo -e "\nInstall...Debian 11(ARM64)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -d 11 -a -v arm64 "$DebianMirrors" "$CXTaddLine" ;;
    4) echo -e "\nInstall...Debian 10(ARM64)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -d 10 -a -v arm64 "$DebianMirrors" "$CXTaddLine" ;;
    5) echo -e "\nInstall...Fedora 36(ARM64)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v arm64 -dd "https://odc.cxthhhhh.com/d/SyStem/Fedora/Fedora_36.X_ARM64_UEFI_NetInatallation_Stable_v1.6.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    6) echo -e "\nInstall...Oracle 9(ARM64)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v arm64 -dd "https://odc.cxthhhhh.com/d/SyStem/Oracle/Oracle_9.X_ARM64_UEFI_NetInstallation_Stable_v1.7.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    7) echo -e "\nInstall...Rocky 9(ARM64)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v arm64 -dd "https://odc.cxthhhhh.com/d/SyStem/Oracle/Oracle_9.X_ARM64_UEFI_NetInstallation_Stable_v1.7.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    8) echo -e "\nInstall...Rocky 8(ARM64)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v arm64 -dd "https://odc.cxthhhhh.com/d/SyStem/Rocky/Rocky_8.X_ARM64_UEFI_NetInstallation_Stable_v6.11.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    9) echo -e "\nInstall...Ubuntu 22(ARM64)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -u 22.04 -a -v arm64 "$UbuntuMirrors"  "$CXTaddLine" ;;
    10) echo -e "\nInstall...Ubuntu 20(ARM64)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -u 20.04 -a -v arm64 "$UbuntuMirrors"  "$CXTaddLine" ;;
    99) echo "更多系统前往CXT博客及ODC查看。https://www.cxthhhhh.com"; exit 1;;
    100) echo -e "\nInstall...Bare-metal System Deployment Platform(Advanced Users)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v arm64 -dd "https://odc.cxthhhhh.com/d/SyStem/Bare-metal_System_Deployment_Platform/CXT_Bare-metal_System_Deployment_Platform_v3.6.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    0) exit 0;;
    *) echo "Wrong input!"; exit 1;;
    esac
elif [ [$CXTisUEFI == "是(True)"] && [ $CXTaddVER != "arm64" ] ];then
echo "打印UEFI菜单"
echo -e "\n"
clear
echo -e "\n\n\n"
clear
echo -e "\n"
echo "                                                           "
echo "================================================================"
echo "=                                                              ="
echo "=           一键网络重装系统 - 魔改版（UEFI安装）                 ="
echo "=        Network-Reinstall-System-Modify (Graphical Install)   ="
echo "=                                                              ="
echo "=             V5.3.0             https://www.cxthhhhh.com      ="
echo "=                                                              ="
echo "================================================================"
echo "                                                                "
echo "您想安装哪个系统(Which System want to Install): "
echo "                                                                "
  echo "   1) CentOS 8(UEFI)"
  echo "   2) Debian 11(UEFI)【Recommend】"
  echo "   3) Debian 10(UEFI)"
  echo "   4) OpenWRT (UEFI)"
  echo "   5) Oracle 9(UEFI)"
  echo "   6) Rocky 9(UEFI)"
  echo "   7) Rocky 8(UEFI)【Recommend】"
  echo "   8) Ubuntu 22(UEFI)【Recommend】"
  echo "   9) Ubuntu 20(UEFI)"
  echo "   21) Windows Server 2022(UEFI)【Recommend】"
  echo "   22) Windows Server 2019(UEFI)"
  echo "   23) Windows Server 2012 R2(UEFI)"
  echo "   99) 更多系统(More System)"
  echo "   100) 裸机系统部署平台(高级用户)"
  echo "   100) Bare-metal System Deployment Platform(Advanced Users)"
  echo "   0) Exit"
  echo -ne "\n请选择(Your option): "
  echo "                                                                "
  read N
  case $N in
    1) echo -e "\nInstall...CentOS 8(UEFI)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v 64 -firmware -dd "https://odc.cxthhhhh.com/d/SyStem/Rocky/Rocky_8.X_x64_UEFI_NetInstallation_Stable_v6.9.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    2) echo -e "\nInstall...Debian 11(UEFI)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ;eval  bash ~/Core_Install.sh -d 11 -a -v 64 -firmware "$DebianMirrors" "$CXTaddLine" ;;
    3) echo -e "\nInstall...Debian 10(UEFI)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -d 10 -a -v 64 -firmware "$DebianMirrors" "$CXTaddLine" ;; 
    4) echo -e "\nInstall...OpenWRT (UEFI)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v 64 -firmware -dd "https://odc.cxthhhhh.com/d/SyStem/OpenWRT-Virtualization-Servers/Stable/openwrt-x86-64-generic-squashfs-combined-efi.img.gz" "$DebianMirrors" "$CXTaddLine" ;;
    5) echo -e "\nInstall...Oracle 9(UEFI)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v 64 -firmware -dd "https://odc.cxthhhhh.com/d/SyStem/Oracle/Oracle_9.X_x64_UEFI_NetInstallation_Stable_v1.9.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    6) echo -e "\nInstall...Rocky 9(UEFI)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v 64 -firmware -dd "https://odc.cxthhhhh.com/d/SyStem/Rocky/Rocky_8.X_x64_UEFI_NetInstallation_Stable_v6.9.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    7) echo -e "\nInstall...Rocky 8(UEFI)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v 64 -firmware -dd "https://odc.cxthhhhh.com/d/SyStem/Rocky/Rocky_8.X_x64_UEFI_NetInstallation_Stable_v6.9.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    8) echo -e "\nInstall...Ubuntu 22(UEFI)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -u 22.04 -a -v 64 -firmware "$UbuntuMirrors"  "$CXTaddLine" ;;
    9) echo -e "\nInstall...Ubuntu 20(UEFI)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -u 20.04 -a -v 64 -firmware "$UbuntuMirrors"  "$CXTaddLine" ;;
    21) echo -e "\nInstall...Windows Server 2022(UEFI)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v 64 -firmware -dd "https://odc.cxthhhhh.com/d/SyStem/Windows_DD_Disks/Disk_Windows_Server_2022_DataCenter_CN_v2.12_UEFI.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    22) echo -e "\nInstall...Windows Server 2019(UEFI)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v 64 -firmware -dd "https://odc.cxthhhhh.com/d/SyStem/Windows_DD_Disks/Disk_Windows_Server_2019_DataCenter_CN_v5.1_UEFI.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    23) echo -e "\nInstall...Windows Server 2012 R2(UEFI)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v 64 -firmware -dd "https://odc.cxthhhhh.com/d/SyStem/Windows_DD_Disks/Disk_Windows_Server_2012R2_DataCenter_CN_v4.29_UEFI.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    99) echo "更多系统前往CXT博客及ODC查看。https://www.cxthhhhh.com"; exit 1;;
    100) echo -e "\nInstall...Bare-metal System Deployment Platform(Advanced Users)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v 64 -firmware -dd "https://odc.cxthhhhh.com/d/SyStem/Bare-metal_System_Deployment_Platform/CXT_Bare-metal_System_Deployment_Platform_v3.6.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    0) exit 0;;
    *) echo "Wrong input!"; exit 1;;
    esac
else
echo "打印标准菜单"
echo -e "\n"
clear
echo -e "\n\n\n"
clear
echo -e "\n"
echo "                                                           "
echo "================================================================"
echo "=                                                              ="
echo "=           一键网络重装系统 - 魔改版（BIOS Legacy安装）          ="
echo "=        Network-Reinstall-System-Modify (Graphical Install)   ="
echo "=                                                              ="
echo "=             V5.3.0             https://www.cxthhhhh.com      ="
echo "=                                                              ="
echo "================================================================"
echo "                                                                "
echo "您想安装哪个系统(Which System want to Install): "
echo "                                                                "
  echo "   1) CentOS 9"
  echo "   2) CentOS 8"
  echo "   3) CentOS 7【Recommend】"
  echo "   4) Debian 10"
  echo "   5) Debian 11 【Recommend】"
  echo "   6) Debian 12"
  echo "   7) OpenWRT"
  echo "   8) Oracle 9"
  echo "   9) Rocky 9"
  echo "   10) Rocky 8【Recommend】"
  echo "   11) Ubuntu 22【Recommend】"
  echo "   12) Ubuntu 20"
  echo "   21) Windows Server 2022【Recommend】"
  echo "   22) Windows Server 2019"
  echo "   23) Windows Server 2016"
  echo "   24) Windows Server 2012 R2"
  echo "   99) 更多系统(More System)"
  echo "   100) 裸机系统部署平台(高级用户)"
  echo "   100) Bare-metal System Deployment Platform(Advanced Users)"
  echo "   0) Exit"
  echo -ne "\n请选择(Your option): "
  echo "                                                                "
  read N
  case $N in
    1) echo -e "\nInstall...CentOS 9\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v 64 -dd "https://odc.cxthhhhh.com/d/SyStem/CentOS/CentOS_9.X_x64_Legacy_NetInstallation_Stable_v1.6.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    2) echo -e "\nInstall...CentOS 8\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v 64 -dd "https://odc.cxthhhhh.com/d/SyStem/CentOS/CentOS_8.X_x64_Legacy_NetInstallation_Stable_v6.8.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    3) echo -e "\nInstall...CentOS 7\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v 64 -dd "https://odc.cxthhhhh.com/d/SyStem/CentOS/CentOS_7.X_x64_Legacy_NetInstallation_Final_v9.8.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    4) echo -e "\nInstall...Debian 11\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -d 10 -a -v 64 "$DebianMirrors" "$CXTaddLine" ;;
    5) echo -e "\nInstall...Debian 10\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -d 11 -a -v 64 "$DebianMirrors" "$CXTaddLine" ;; 
    6) echo -e "\nInstall...Debian 10\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -d 12 -a -v 64 "$DebianMirrors" "$CXTaddLine" ;; 
    7) echo -e "\nInstall...OpenWRT\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v 64 -dd "https://odc.cxthhhhh.com/d/SyStem/OpenWRT-Virtualization-Servers/Stable/openwrt-x86-64-generic-squashfs-combined.img.gz" "$DebianMirrors" "$CXTaddLine" ;;
    8) echo -e "\nInstall...Oracle 9\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v 64 -dd "https://odc.cxthhhhh.com/d/SyStem/Oracle/Oracle_9.X_x64_Legacy_NetInstallation_Stable_v1.8.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    9) echo -e "\nInstall...Rocky 9\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v 64 -dd "https://odc.cxthhhhh.com/d/SyStem/Rocky/Rocky_8.X_x64_Legacy_NetInstallation_Stable_v6.8.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    10) echo -e "\nInstall...Rocky 8\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v 64 -dd "https://odc.cxthhhhh.com/d/SyStem/Rocky/Rocky_8.X_x64_Legacy_NetInstallation_Stable_v6.8.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    11) echo -e "\nInstall...Ubuntu 22\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -u 22.04 -a -v 64 "$UbuntuMirrors"  "$CXTaddLine" ;;
    12) echo -e "\nInstall...Ubuntu 20\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -u 20.04 -a -v 64 "$UbuntuMirrors"  "$CXTaddLine" ;;
    21) echo -e "\nInstall...Windows Server 2022\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v 64 -dd "https://odc.cxthhhhh.com/d/SyStem/Windows_DD_Disks/Disk_Windows_Server_2022_DataCenter_CN_v2.12.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    22) echo -e "\nInstall...Windows Server 2019\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v 64 -dd "https://odc.cxthhhhh.com/d/SyStem/Windows_DD_Disks/Disk_Windows_Server_2019_DataCenter_CN_v5.1.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    23) echo -e "\nInstall...Windows Server 2016\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v 64 -dd "https://odc.cxthhhhh.com/d/SyStem/Windows_DD_Disks/Disk_Windows_Server_2016_DataCenter_CN_v4.12.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    24) echo -e "\nInstall...Windows Server 2012 R2\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v 64 -dd "https://odc.cxthhhhh.com/d/SyStem/Windows_DD_Disks/Disk_Windows_Server_2012R2_DataCenter_CN_v4.29.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    99) echo "更多系统前往CXT博客及ODC查看。https://www.cxthhhhh.com"; exit 1;;
    100) echo -e "\nInstall...Bare-metal System Deployment Platform(Advanced Users)\n"; read -s -n1 -p "任意键继续(Press any key to continue...)" ; eval bash ~/Core_Install.sh -a -v 64 -dd "https://odc.cxthhhhh.com/d/SyStem/Bare-metal_System_Deployment_Platform/CXT_Bare-metal_System_Deployment_Platform_v3.6.vhd.gz" "$DebianMirrors" "$CXTaddLine" ;;
    0) exit 0;;
    *) echo "Wrong input!"; exit 1;;
    esac
fi

echo "---------------------------------------------------------------------------------------------------------------------"
echo -e "\033[35m 启动 安装 \033[0m"
echo -e "\033[32m Start Installation \033[0m"
echo "---------------------------------------------------------------------------------------------------------------------"
echo -e "\n"
