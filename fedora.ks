# Configure installation method

url --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-40&arch=x86_64"
repo --name=google-chrome --install --baseurl="https://dl.google.com/linux/chrome/rpm/stable/x86_64" --cost=0

#version=DEVEL
# System language
lang en_US.UTF-8

# Keyboard layouts
keyboard us

# System timezone
timezone America/New_York

# Root password
rootpw --lock

# Reboot after installation
reboot

# Use network installation
url --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=fedora-38&arch=$basearch

# System authorization information
auth --useshadow --passalgo=sha512

# Use graphical install
graphical

# Firewall configuration
firewall --enabled --service=mdns

# SELinux configuration
selinux --enforcing

# Network information
network --bootproto=dhcp --device=link --activate

# System bootloader configuration
bootloader --location=mbr --boot-drive=sda

# Partition clearing information
clearpart --all --initlabel

# Disk partitioning information
autopart --type=lvm

%packages
@core
@workstation-product
@gnome-desktop
# Preinstalled applications
code
google-chrome-stable
zoom
gh
%end

%post
# Install Visual Studio Code repository
rpm --import https://packages.microsoft.com/keys/microsoft.asc
cat <<EOF > /etc/yum.repos.d/vscode.repo
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

# Enable Google Chrome repository and install
dnf install -y fedora-workstation-repositories
dnf config-manager --set-enabled google-chrome

# Download and install Zoom
wget https://zoom.us/client/latest/zoom_x86_64.rpm
dnf install -y ./zoom_x86_64.rpm

# Install the applications
dnf install -y code google-chrome-stable gh

# Clean up
rm -f ./zoom_x86_64.rpm
%end


# Reboot After Installation
reboot --eject
