Purpose: a sample project to build a VIB file for VMware ESXi.  The utilities needed to create these are all common Linux commandline tools.


Outputs:
* creates a VIB
* installs the VIB on ESXi boxes directly


Customization:
* the `roles/ensure_vib/vars/main.yml` contains all of the VIB variables
* some additional environmental variables are kept in the `environmental_vars.yml` file 
* an example inventory is provided that can be updated
  * otherwise update `build_and_deploy_vib.yml` with your own groups
* ESXi credentials can be kept in a vault file called `esxi_creds_vault.yml`: `esxi_user` (usually root), `esxi_password`
  * if you want to name the vault file something else, update `vars_files` in `build_and_deploy_vib.yml`


Example Run Command:
`ansible-playbook build_and_deploy_vib.yml -i /path/to/inventory --ansible-vault-file=/path/to/vaultpass.file` 


Notes on maintenance mode:
* maintenance mode is required to set the software acceptance level to Community to deploy a custom VIB (that has not been signed by VMware)
* the deploy playbook looks for this and sets the software acceptance to CommunitySupport if specified in the descriptor.xml file (`vars/main.yml`)
* there are 2 scripts included with the deploy role that will set find all poweredon VM's to suspended and then resume only those that it suspended
  * these scripts are only triggered for use if the software acceptance level needs to be set OR you set `var_vib_maintenance_mode: true` in the `vars/main.yml`
* if vCenter is deployed and you wish to rely on DRS to evacuate (vMotion) instead of suspending VM's, set the `var_do_not_suspend_vms: true` which will prevent the above scripts from running


Caveats:
* does not use the upgrade command, if the version is different it removes the prior and replaces it with a new VIB
* some of the relationship tags in the descriptor file are only marginally supported (no loops)
* does not currently support multiple playloads in a single VIB
* creates a "throw-away" cert/key pair because ESXi wants a pkcs7 file even if Community-supported VIB's don't require them
* not all files on ESXi can be replaced by a Community-supported VIB, check documentation for which can
 

Helpful troubleshooting commands:
- `ar vx filename.vib`
- `esxcli software vib remove --vibname=vibname`
- `esxcli software vib install -v /tmp/vibname.vib`
- `esxcli system maintenanceMode get`
- `esxcli system maintenanceMode set --enable true`
- `esxcli system maintenanceMode set --enable false`


Reference URLs:
- http://download3.vmware.com/software/vmw-tools/vibauthor/vibauthor.pdf
- https://blogs.vmware.com/vsphere/2011/09/whats-in-a-vib.html
- http://www.yellow-bricks.com/2011/11/29/how-to-create-your-own-vib-files/
- https://communities.vmware.com/thread/511708

