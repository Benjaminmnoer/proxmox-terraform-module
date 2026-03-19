provider "proxmox" {
    endpoint  = "https://localhost:8006"
    # api_token = var.virtual_environment_api_token
    username  = "root@pam"
    password  = "Test1234"
}

run "firewall_ipset_management" {
    command = plan

    variables {
        firewall_aliases = {}
        management_ipset = {
            "admin-network" = {
                ip      = "10.10.100.0/24"
                comment = "Admin Network"
            },
            "dmz" = {
                ip      = "10.10.200.0/24"
                comment = "DMZ Network"
            }
        }
        firewall_enabled = true
        cloudflare_token = "dummy_token"
    }

    assert {
        condition     = proxmox_virtual_environment_firewall_ipset.management.name == "management"
        error_message = "Management IPset name should be 'management'"
    }

    assert {
        condition     = length(proxmox_virtual_environment_firewall_ipset.management.cidr) == 2
        error_message = "Should have 2 Proxmox hosts in IPset"
    }
}

run "firewall_aliases" {
    command = plan

    variables {
        management_ipset = {}
        cluster_nodes = {
            "pve-1" = {
                ip      = "192.168.1.10"
                comment = "Proxmox Node 1"
            }
        }
        firewall_aliases = {
            "dmz" = {
                cidr    = "192.168.2.0/24"
                comment = "DMZ Network"
            }
            "backup" = {
                cidr    = "192.168.3.0/24"
                comment = "Backup Network"
            }
        }
        trusted_clients = {}
        firewall_enabled = true
        cloudflare_token = "dummy_token"
    }

    assert {
        condition     = length(proxmox_virtual_environment_firewall_alias.firewall_aliases) == 2
        error_message = "Should have 2 firewall aliases"
    }
}

run "cluster_firewall_disabled" {
    command = plan

    variables {
        management_ipset = {}
        cluster_nodes = {
            "pve-1" = {
                ip      = "192.168.1.10"
                comment = "Node 1"
            }
        }
        firewall_aliases = {}
        trusted_clients = {}
        firewall_enabled = false
        cloudflare_token = "dummy_token"
    }

    assert {
        condition     = proxmox_virtual_environment_cluster_firewall.cluster_fw_options.enabled == false
        error_message = "Firewall should be disabled"
    }
}