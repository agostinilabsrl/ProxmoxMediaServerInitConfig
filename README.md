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


