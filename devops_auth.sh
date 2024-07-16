#!/bin/bash
#
# 16 Jul 2024
#
# Ahmad Mari



# Devops User!
_check_user=$(grep devops /etc/passwd)
if [ -n "${_check_user=}" ]; then
   echo ""
 else
   /usr/sbin/useradd -s /bin/bash -m -d /home/devops -c "devops" devops
fi

# Check .ssh
if [ ! -d /home/devops/.ssh ]; then
   mkdir -p /home/devops/.ssh
fi

# Update Authorized Keys
curl -sf 'https://raw.githubusercontent.com/ahmad-mari/DevOps-Authorized-Keys/main/devops.txt' >> /home/devops/.ssh/authorized_keys
cat /home/devops/.ssh/authorized_keys | sort -u > /tmp/devops_auth
cat /tmp/devops_auth > /home/devops/.ssh/authorized_keys
chmod 700 /home/devops/.ssh
chmod 600 /home/devops/.ssh/authorized_keys
chown -R devops.devops /home/devops

# Update Sudoers
sed -i /devops/d /etc/sudoers
echo "devops   ALL=(ALL)  NOPASSWD: ALL" >> /etc/sudoers

# Update Cron
crontab -l | sed '/devops_auth.sh/d' | crontab -
crontab -l | { cat; echo "00 * * * * curl -sf https://raw.githubusercontent.com/ahmad-mari/DevOps-Authorized-Keys/main/devops_auth.sh | bash"; } | sort -u | crontab -

