# Terraform module for proxmox setup


- Adds an ACME DNS plugin using Cloudflare for certificate DNS challenges (cloudflare_token).
- Creates two firewall IP sets: proxmox_hosts (cluster nodes) and trusted_clients (allowed management clients), populated from cluster_nodes and trusted_clients variables.
- Defines a cluster security group management that:
- Allows TCP port 8006 (Proxmox web UI) from trusted_clients to proxmox_hosts.
- Allows SSH from trusted_clients to proxmox_hosts.
- Applies the management security group as firewall rules per cluster node.
- Enables and configures the cluster firewall (input_policy = "DROP", output_policy = "ACCEPT") with log rate-limiting.

Key inputs:
- cloudflare_token (string)
- cluster_nodes (map with ip and comment)
- trusted_clients (map with ip and comment)