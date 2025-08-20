# ProxmoxMediaServerInitConfig

Configure a Media server folder tree on Proxmox

**This scripts create the mounts on the host, formatting them!!***

```
bash -c "$(wget -qLO - https://github.com/agostinilabsrl/ProxmoxMediaServerInitConfig/raw/main/host/diskconfiguration.sh)"
```

**To later add the mounted folder to a new LXC container, run this script instead** - **SAFE**

```
bash -c "$(wget -qLO - https://github.com/agostinilabsrl/ProxmoxMediaServerInitConfig/raw/main/host/diskmounter.sh)"
```

**Configuration**

Once the mount are done both on the host and all needed containers different strategies can be applied to manage the read/write permissions.
In our case we choose to map the UID of the CTs to the host and set permissions on the host directly. To follow this path, for each container were you mounted the disks edit (from the host shell) the file **/etc/pve/lxc/<CT_ID>.conf** adding to the bottom the mapping:

```
lxc.idmap: u 0 0 1
lxc.idmap: g 0 0 1
lxc.idmap: u 1 100000 65535
lxc.idmap: g 1 100000 65535
```
