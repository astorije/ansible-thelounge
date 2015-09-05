[![Build Status](https://travis-ci.org/astorije/ansible-role-shout.svg?branch=master)](https://travis-ci.org/astorije/ansible-role-shout)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

# ansible-role-shout

Ansible role to install [Shout](http://shout-irc.com/), a self-hosted web IRC
client.

What this role does:

- Installs [NodeSource Node.js 0.12](https://nodesource.com/blog/nodejs-v012-iojs-and-the-nodesource-linux-repositories)
- Installs [Shout 0.51.1](https://github.com/erming/shout/blob/master/CHANGELOG.md#0511--2015-04-29)
- Configures Shout [as a private server](http://shout-irc.com/docs/server/configuration.html#public) to enable user login
- Configures users as defined in your playbook variables, each with logging support
- Starts Shout server as a [Supervisor](http://supervisord.org/) program

Note that this playbook will also install
[esprima](https://www.npmjs.com/package/esprima) and
[jsonlint](https://www.npmjs.com/package/jsonlint) npm packages to check syntax
of configuration files.

## Requirements

This role should be compatible with Ansible 1.2 or higher.

It was written for Debian and Ubuntu distributions.

## Role variables

### `shout_users`

Users are defined by a list of the following format:

```yaml
shout_users:
  - user: WiZ
    hashed_password: $2a$04$g8xA7UYVGXwtMp1fJIyINerlXjzieA/lva9O3rUWV2KEpLTjhdVD6 # "password"
  - ...
```

Passwords are hashed using [`bcrypt`](https://en.wikipedia.org/wiki/Bcrypt). To
generate a password using the [bcryptjs](https://www.npmjs.com/package/bcryptjs)
npm package, run the following commands:

```bash
npm install bcryptjs
 node node_modules/bcryptjs/bin/bcrypt myPassword
```

(Note that the `bcrypt` command is prefixed with a whitespace to
[not be saved in your `bash` history](http://askubuntu.com/a/15929/166928),
if configured accordingly).

**Warning:** The playbook will fail if you do not specify at least one user,
which is how Shout behaves itself.

**Warning:** At the moment, user configuration files are only created if they do
not exist, so changing passwords does not get reflected when provisioning.

### `shout_theme`

Sets the visual style to apply to Shout, among those offered with the software.

#### Example:

```yaml
# Options are: crypto, example (default), morning, zenburn
shout_theme: example
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

You should then be able to access Shout at <http://localhost:9000/>, and connect
with the following test credentials:
  - Username: **WiZ**
  - Password: **password**

You can also run the tests against the VM with:

```bash
bash tests/tests.sh
```

Lastly, once you are done with changes, you can run one of the following:

```bash
vagrant halt -f # Shuts down the VM for later re-use
vagrant destroy -f # Destroys the VM entirely
```

This role is
[backed by Travis CI](https://travis-ci.org/astorije/ansible-role-shout).
It uses the same test playbook to ensure that, for every push:

- Syntax is correct
- The role and playbook run fine
- The role is idempotent (running it twice in a row results in un-changed states
  only)
