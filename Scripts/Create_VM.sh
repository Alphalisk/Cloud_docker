# VM container

## VM 300 aanmaken op Ceph storage (vm-storage)
sudo qm create 300 \
  --name VMDocker \
  --memory 4096 \
  --cores 2 \
  --net0 virtio,bridge=vmbr0 \
  --scsihw virtio-scsi-pci \
  --scsi0 vm-storage:32 \
  --ide2 vm-storage:cloudinit \
  --ostype l26

# echo "💽 Koppel de geüploade schijf"
qm set 300 --scsi0 ${DISK}

## Boot volgorde en disk instellen
sudo qm set 300 --boot c --bootdisk scsi0

## Cloud-init config (voor testomgeving)
sudo qm set 300 --ciuser wpadmin --cipassword securepass --ipconfig0 ip=10.24.13.200/24,gw=10.24.13.1

# echo "🚀 Start VM"
qm start $VMID

# SSH verbinding via certificaat