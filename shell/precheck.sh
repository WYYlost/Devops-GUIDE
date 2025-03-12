#! /bin/bash

handle_error() {
    while true; do
        echo "An error occurred! Do you want to continue running the script? (y/n)"
        read -r choice
        if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
            echo "Continuing the script..."
            break
        elif [[ "$choice" == "n" || "$choice" == "N" ]]; then
            echo "Script terminated."
            exit 1
        else
            echo "Invalid input. Please enter 'y' or 'n'."
        fi
    done
}

print_yellow() {
    echo -e "\033[1;33m$1\033[0m"
}

print_yellow "Step 1:check system srevices ..."

# Check cloud services
services=(
    "cloud-init.service"
    "cloud-init-local.service"
    "cloud-config.service"
    "cloud-final.service"
)

for service in "${services[@]}"; do
    if systemctl list-units --type=service | grep -q "$service"; then
        echo "$service is found, disabling $service..."
        systemctl disable "$service"
        echo "$service disabled"
    else
        echo "$service not found"
    fi
done

# Check NetworkManager
if systemctl list-units --type=service | grep -q "NetworkManager" > /dev/null; then
    echo "NetworkManager found, disabling NetworkManager..."
    systemctl disable NetworkManager && systemctl enable networking
    echo "NetworkManager disabled"
else
    echo "NetworkManager not found"
fi

# Check resolvconf
if systemctl list-units --type=service | grep -q "NetworkManager" > /dev/null; then
    echo "resolvconf found, disabling resolvconf..."
    systemctl stop resolvconf
    systemctl disable resolvconf
    echo "resolvconf disabled"
    # Uninstall resolvconf
    apt-get purge resolvconf
    echo "resolvconf uninstalled"
    # Restart dnsmasq
    /etc/init.d/dnsmasq restart
    echo "dnsmasq restarted"
    # Remove /sbin/resolvconf
    mv /sbin/resolvconf /sbin/resolvconf_bak
    echo "command resolvconf removed"
else
    echo "resolvconf not found"
fi

# Check ufw
if dpkg -l | grep -q ufw; then
    echo "ufw found, disabling ufw..."
    systemctl stop ufw
    systemctl disable ufw
    echo "ufw disabled"
else
    echo "ufw not found"
fi

# Check zenlayer-agent
if [ -f /etc/rc.local ]; then
    echo "/etc/rc.local exists."

    # Check if 'zenlayer-agent' is present in /etc/rc.local
    if grep -q "zenlayer-agent" /etc/rc.local; then
        echo "zenlayer-agent found in /etc/rc.local, commenting out the line(s)..."

        # Comment out the line containing 'zenlayer-agent'
        sed -i '/zenlayer-agent/s/^/#/' /etc/rc.local
        echo "zenlayer-agent has been commented out."
    else
        echo "zenlayer-agent not found in /etc/rc.local."
    fi
else
    echo "/etc/rc.local does not exist."
fi

