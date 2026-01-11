# Proxmox Terraform Module
This module is intended to perform basic setup of a proxmox host or cluster. It uses the [bpg/proxmox](https://github.com/bpg/terraform-provider-proxmox) Terraform/OpenTofu provider to create the following list of ressources:
- Adds an ACME DNS plugin using Cloudflare for certificate DNS challenges.
- Creates a list of aliases.
- Creates two firewall IP sets: proxmox_hosts (cluster nodes) and trusted_clients (allowed management clients), populated from cluster_nodes and trusted_clients variables.
- Defines a cluster security group management that:
    - Allows TCP port 8006 (Proxmox web UI) from trusted_clients to proxmox_hosts.
    - Allows SSH from trusted_clients to proxmox_hosts.
- Applies the management security group as firewall rules per cluster node.
- Enables and configures the cluster firewall (input_policy = "DROP", output_policy = "ACCEPT") with log rate-limiting.
    - Firewall state (enabled/disabled) can be managed by input variable. By default, the firewall is disabled to allow rules to be created before enabling firewall.

Key inputs:
- cloudflare_token (string)
- cluster_nodes (map with ip and comment)
- trusted_clients (map with ip and comment)
- firewall_enabled