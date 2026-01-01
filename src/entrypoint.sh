#!/bin/bash
set -e

GROUPS_FILE="/groups.txt"
USERS_FILE="/users.txt"
PASS_FILE="/pass.txt"

# Create groups from groups.txt
if [ -f "$GROUPS_FILE" ]; then
	echo "Creating groups from $GROUPS_FILE"
	while IFS=: read -r groupname gid; do
		# Skip empty lines
		[ -z "$groupname" ] && continue

		# Check if group already exists
		if getent group "$groupname" > /dev/null 2>&1; then
			echo "Group $groupname already exists"
		else
			groupadd -g "$gid" "$groupname"
			echo "Group created: $groupname (GID: $gid)"
		fi
	done < "$GROUPS_FILE"
fi

# Create users from users.txt
if [ -f "$USERS_FILE" ]; then
	echo "Creating users from $USERS_FILE"
	while IFS=: read -r username uid gid; do
		# Skip empty lines
		[ -z "$username" ] && continue

		# Check if user already exists
		if id "$username" > /dev/null 2>&1; then
			echo "User $username already exists"
		else
			useradd -u "$uid" -g "$gid" -M -s /sbin/nologin "$username"
			echo "User created: $username (UID: $uid, GID: $gid)"
		fi
	done < "$USERS_FILE"
fi

# Set passwords for Samba users from pass.txt
if [ -f "$PASS_FILE" ]; then
	echo "Configuring Samba passwords from $PASS_FILE"
	while IFS=: read -r username password; do
		# Skip empty lines
		[ -z "$username" ] && continue

		# Set Samba password
		(echo "$password"; echo "$password") | smbpasswd -a -s "$username"
		smbpasswd -e "$username"
		echo "Samba password set for: $username"
	done < "$PASS_FILE"
fi

testparm

exec smbd --foreground --no-process-group
