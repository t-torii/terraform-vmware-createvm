#!bin/bash

set -eu

cat << EOF > instance-$1.sh
resource "vsphere_virtual_machine" "instance-$1" {
  name             = "\${var.vmname}"
  resource_pool_id = "\${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "\${data.vsphere_datastore.datastore.id}"

  num_cpus = \${var.cpu}
  memory   = \${var.mem}
  guest_id = "\${data.vsphere_virtual_machine.template.guest_id}"

  network_interface {
    network_id   = "\${data.vsphere_network.network.id}"
    adapter_type = "\${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "\${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "\${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "\${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "\${data.vsphere_virtual_machine.template.id}"

    customize {
      linux_options {
        host_name = "\${var.vmname}"
        domain    = "\${var.vmdomain}"
      }

      network_interface {
        ipv4_address = "\${var.ipaddress}"
        ipv4_netmask = 24
      }

      ipv4_gateway    = "10.32.210.1"
      dns_server_list = ["10.32.208.101"]
    }
  }
}
EOF
