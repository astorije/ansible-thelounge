[![Build Status](https://travis-ci.org/astorije/ansible-lounge.svg?branch=master)](https://travis-ci.org/astorije/ansible-lounge)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

# Ansible role for The Lounge

Ansible role to install [The Lounge](https://thelounge.github.io/), a self-hosted web IRC
client.

What this role does:

- Uses [Supervisor](http://supervisord.org/) or `systemd` to run The Lounge in the background (supervisord will be installed when selected)
- Installs [NodeSource's Node.js 4.x LTS](https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions)
- Installs [The Lounge v2.4.0](https://github.com/thelounge/lounge/blob/master/CHANGELOG.md)
- Creates a system user to own the `lounge` process
- Configures The Lounge [as a private server](https://theloungegithub.io/docs/server/configuration.html#public) to enable user login
- Configures users as defined in your playbook variables, each with logging support
- Starts The Lounge server as a [Supervisor](http://supervisord.org/) program

Note that this playbook will also install
[esprima](https://www.npmjs.com/package/esprima) and
[jsonlint](https://www.npmjs.com/package/jsonlint) npm packages to check syntax
of configuration files.

## Requirements

This role should be compatible with Ansible 2.2 or higher.

It was written for Debian and Ubuntu distributions.

## Role variables

### `lounge_debug`

Sets debug mode for available keys.

This variable is **optional** and all its keys default to `false`.

#### Example

```yaml
lounge_debug:
  irc_framework: true
  raw: true
```

### `lounge_port`

Sets the port that `lounge` is listening on.

This variable is **optional** and defaults to `9000`.

### `lounge_prefetch`

Enables or disables link and image prefetching for clients of this instance.

This variable is **optional** and defaults to `false`.

### `lounge_theme`

Sets the visual style to apply to The Lounge, among those offered with the software.

This variable is **optional** and defaults to `example`.

#### Example

```yaml
# Options are: crypto, example (default), morning, zenburn
lounge_theme: morning
```

### `lounge_users`

Lists all users allowed to access The Lounge using their credentials.

This variable is **required**.

**Warning:** The playbook will fail if you do not specify at least one user,
which is how The Lounge behaves itself.

**Warning:** At the moment, user configuration files are only created if they do
not exist, so changing passwords does not get reflected when provisioning. Use
the web interface (since v1.3.0) to change passwords.

#### Example

```yaml
lounge_users:
  - user: WiZ
    hashed_password: $2a$04$g8xA7UYVGXwtMp1fJIyINerlXjzieA/lva9O3rUWV2KEpLTjhdVD6 # "password"
  - ...
```

Passwords are hashed using [`bcrypt`](https://en.wikipedia.org/wiki/Bcrypt). To
generate a password using the [bcryptjs](https://www.npmjs.com/package/bcryptjs)
npm package, run the following commands:

```bash
npm install bcryptjs
 node node_modules/bcryptjs/bin/bcrypt "my password"
```

(Note that the `bcrypt` command is prefixed with a whitespace to
[not be saved in your `bash` history](http://askubuntu.com/a/15929/166928),
if configured accordingly).

### `lounge_init_system`

Sets the software that is used to start `lounge`.

This variable is **optional** can be set to `systemd` or `supervisord` (default).

### `lounge_version`

Installs a specific version of The Lounge. It must be one of [the official
releases](https://github.com/thelounge/lounge/releases).

This variable is **optional** and defaults to the stable version detailed above.

#### Example

```yaml
lounge_version: "2.0.0-pre.1"
```

## Example playbook

Go to the [test playbook](tests/test.yml) to see an example playbook using this
role.

## Development environment

Install [Vagrant](https://www.vagrantup.com/) and
[VirtualBox](https://www.virtualbox.org/) using your favorite package manager
and run:

```bash
vagrant up
```

This will spin up a minimal virtual machine and provision it with a test
playbook using that role.

If that step succeeds, syntax of the role is correct and all tasks are
successful on a bare machine. It does not test the specifics of the role
however, that you need to check yourself by connecting to the VM:

```bash
vagrant ssh
```

To provision the virtual machine again, run the following:

```bash
vagrant up # Unnecessary if the VM is already running
vagrant provision
```

You should then be able to access The Lounge at <http://localhost:9000/>, and connect
with the following test credentials:
  - Username: **WiZ**
  - Password: **password**

You can also run the tests against the VM with:

```bash
./tests/tests.sh
```

Lastly, once you are done with changes, you can run one of the following:

```bash
vagrant halt -f # Shuts down the VM for later re-use
vagrant destroy -f # Destroys the VM entirely
```

This role is
[backed by Travis CI](https://travis-ci.org/astorije/ansible-lounge).
It uses the same test playbook to ensure that, for every push:

- Syntax is correct
- The role and playbook run fine
- The role is idempotent (running it twice in a row results in un-changed states
  only)
