# Docker Samba Server

A lightweight Samba server running in Docker with support for custom users, groups, and passwords.

## Features

- Debian-based minimal image
- Dynamic user and group creation from configuration files
- Flexible Samba configuration
- Easy deployment with make commands

## Quick Start

### Build the image

```bash
make build
```

### Run the container

```bash
make run
```

### View logs

```bash
make logs
```

### Stop the container

```bash
make stop
```

### Push image to registry

```bash
make push
```

## Configuration

### Directory Structure

```text
.
├── src/
│   ├── Dockerfile          # Docker image definition
│   ├── entrypoint.sh       # Startup script
│   └── smb.conf            # Samba configuration
└── users/
    ├── groups.txt          # Group definitions
    ├── users.txt           # User definitions
    └── pass.txt            # User passwords
```

### File Formats

#### users/groups.txt

Defines groups with GID (Group ID). Format: `groupname:gid`

```text
share:1001
admins:1002
```

#### users/users.txt

Defines users with UID (User ID) and GID (Group ID). Format: `username:uid:gid`

```text
user:1000:1001
admin:1001:1002
```

#### users/pass.txt

Sets Samba passwords for users. Format: `username:password`

```text
user:SecurePassword123!
admin:AnotherSecurePass456!
```

### Samba Configuration

Edit [src/smb.conf](src/smb.conf) to customize your Samba server settings:

- **workgroup**: Windows workgroup name
- **hosts allow**: IP ranges allowed to connect
- **[data] section**: Share configuration
  - **path**: Path inside container (mounted volume)
  - **writable**: Write permissions
  - **guest ok**: Allow guest access

### Customizing Mount Points

Edit the [Makefile](Makefile:14) to change the data directory:

```makefile
-v /share:/data \
```

Change `/share` to your desired host path.

## Image Registry

The default image is published to GitHub Container Registry:

```text
ghcr.io/hlesey/samba-server:1.0
```

## License

MIT License - See [LICENSE](LICENSE) file for details.
