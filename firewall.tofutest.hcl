provider "proxmox" {
    endpoint  = "localhost:8006"
    # api_token = var.virtual_environment_api_token
    username  = "root@pam"
    password  = "Test1234"
}

mock_provider "proxmox" {
    # Mock implementation for the bpg/proxmox provider used in tests.
    # This mock echoes back the attributes the module sends when creating
    # resources so asserts can validate expected values.

    # resource "proxmox_virtual_environment_firewall_ipset" {
    #     create = {
    #         id = "ipset-${request.name}"
    #         attributes = request
    #     }
    # }

    # resource "proxmox_virtual_environment_firewall_alias" {
    #     create = {
    #         id = "alias-${request.name}"
    #         attributes = request
    #     }
    # }

    # resource "proxmox_virtual_environment_cluster_firewall_security_group" {
    #     create = {
    #         id = "sg-${request.name}"
    #         attributes = request
    #     }
    # }

    # resource "proxmox_virtual_environment_cluster_firewall" {
    #     create = {
    #         id = "cluster-fw"
    #         attributes = request
    #     }
    # }
}

run "firewall_ipset_proxmox_hosts" {
    command = apply

    variables {
        firewall_aliases = {}
        management_ipset = {
            "admin-ip" = {
                ip      = "10.0.0.0/8"
                comment = "Admin Network"
            }
        }
        firewall_enabled = true
        cloudflare_token = "dummy_token"
    }

    assert {
        condition     = proxmox_virtual_environment_firewall_ipset.proxmox_hosts.name == "proxmox_hosts"
        error_message = "Proxmox hosts IPset name should be 'proxmox_hosts'"
    }

    assert {
        condition     = length(proxmox_virtual_environment_firewall_ipset.proxmox_hosts.cidr) == 2
        error_message = "Should have 2 Proxmox hosts in IPset"
    }

    assert {
        condition     = proxmox_virtual_environment_firewall_ipset.trusted_clients.name == "trusted_clients"
        error_message = "Trusted clients IPset name should be 'trusted_clients'"
    }
}

# run "firewall_aliases" {
#     command = apply

#     variables {
#         cluster_nodes = {
#             "pve-1" = {
#                 ip      = "192.168.1.10"
#                 comment = "Proxmox Node 1"
#             }
#         }
#         firewall_aliases = {
#             "dmz" = {
#                 cidr    = "192.168.2.0/24"
#                 comment = "DMZ Network"
#             }
#             "backup" = {
#                 cidr    = "192.168.3.0/24"
#                 comment = "Backup Network"
#             }
#         }
#         trusted_clients = {}
#         firewall_enabled = true
#         cloudflare_token = "dummy_token"
#     }

#     assert {
#         condition     = length(proxmox_virtual_environment_firewall_alias.firewall_aliases) == 2
#         error_message = "Should have 2 firewall aliases"
#     }
# }

# run "cluster_firewall_security_group" {
#     command = apply

#     variables {
#         cluster_nodes = {
#             "pve-1" = {
#                 ip      = "192.168.1.10"
#                 comment = "Node 1"
#             }
#         }
#         firewall_aliases = {}
#         trusted_clients = {
#             "trusted" = {
#                 ip      = "10.0.0.0/8"
#                 comment = "Trusted"
#             }
#         }
#         firewall_enabled = true
#         cloudflare_token = "dummy_token"
#     }

#     assert {
#         condition     = proxmox_virtual_environment_cluster_firewall_security_group.management.name == "management"
#         error_message = "Security group name should be 'management'"
#     }

#     assert {
#         condition     = length(proxmox_virtual_environment_cluster_firewall_security_group.management.rule) == 2
#         error_message = "Management security group should have 2 rules"
#     }
# }

# run "cluster_firewall_disabled" {
#     command = apply

#     variables {
#         cluster_nodes = {
#             "pve-1" = {
#                 ip      = "192.168.1.10"
#                 comment = "Node 1"
#             }
#         }
#         firewall_aliases = {}
#         trusted_clients = {}
#         firewall_enabled = false
#         cloudflare_token = "dummy_token"
#     }

#     assert {
#         condition     = proxmox_virtual_environment_cluster_firewall.cluster_fw_options.enabled == false
#         error_message = "Firewall should be disabled"
#     }
# }