### NAS settings

I put the NAS under my desk in my office. The name is "ACTNEM" standing for active nematics. It is connected via an ethernet cable to a router in my office, so supposedly it is in the local network of ESPCI. Below are some key information:
```
Server name: ACTNEM
QuickConnect ID: actnem
IP address: 193.54.88.3
Default gateway: 193.54.88.1
DNS: 193.54.82.20
```

#### 1. Access

- From ESPCI local network (if your IP address is 193.54.88.xxx): https://193.54.88.3:5001/
- From external network: https://quickconnect.to/actnem

Then you need to input your credentials to login the system. I have created an administrator account:
```
username: labdamin
password: ActiveNemat1cs
```

![picture 1](../images/2022/12/sign-in.png)  

After logging in with labadmin, you can head to "Control Panel" -> "User & Group" to create a new user with your preferred username and password. Once created, you can sign out the admin account and sign in with your newly created account. 

NOTE: Do not use the administrator account for daily use of the system.

#### 2. Transfer files

Files can be transferred using "File Station" in the web interface by drag & drop files to shared folders.

![picture 2](../images/2022/12/drop-files.png)  

To download, just right click on the file(s) and select download.

![picture 3](../images/2022/12/download.png)  

#### 3. Map network drive

It is convenient to map the drive to local file systems, so that we can access network files as if they are on my local computer. This can be achieved by SMB protocol. 

![picture 4](../images/2022/12/access-through-smb.png)  

##### Windows 10

On windows computer, we can deploy the mapping by clicking "my PC" in File Explorer and then choose "computer" tab. 

![picture 5](../images/2022/12/win-map-network-drive.png)  

Then click "Map network drive" -> "Map network drive". Choose a letter for the drive, and locate the network drive using "Browse".

![picture 6](../images/2022/12/locate-network-drive.png)  

For example, I choose letter `A:` for the shared folder `\\ACTNEM\bifurcations`, on my local computer it looks like

![picture 7](../images/2022/12/local-view.png)  

##### MacOS

To be tested.