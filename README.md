# ansible-mac

A quiet, orderly system for a silicon world.

Ansible playbook for managing a personal macOS environment, structured following Ansible best practices.

## Project Structure

```
ansible-mac/
├── ansible.cfg              # Ansible configuration
├── site.yml                 # Main entry point
├── inventory/
│   ├── hosts.yml            # Host definitions
│   └── group_vars/
│       └── all.yml          # Variables for all hosts
├── playbooks/
│   ├── setup.yml            # Initial setup playbook
│   └── maintenance.yml      # Update/upgrade playbook
├── roles/
│   ├── directories/         # Creates user directories
│   │   ├── tasks/main.yml
│   │   ├── defaults/main.yml
│   │   └── meta/main.yml
│   ├── homebrew/            # Manages Homebrew packages
│   │   ├── tasks/main.yml
│   │   ├── defaults/main.yml
│   │   ├── handlers/main.yml
│   │   └── meta/main.yml
│   └── git_repos/           # Clones git repositories
│       ├── tasks/main.yml
│       ├── defaults/main.yml
│       └── meta/main.yml
└── requirements.yml         # Ansible Galaxy dependencies
```

## Key Concepts

### Roles
Self-contained units that group related tasks, variables, and handlers:
- **directories** - Creates essential directories (`~/code`, `~/work`, etc.)
- **homebrew** - Installs and manages Homebrew packages and casks
- **git_repos** - Clones and updates git repositories

### Variable Precedence
Variables can be defined at multiple levels (lowest to highest precedence):
1. `roles/*/defaults/main.yml` - Role defaults (easily overridden)
2. `inventory/group_vars/all.yml` - Group variables
3. `inventory/host_vars/<host>.yml` - Host-specific variables
4. Command line (`-e "var=value"`)

### Playbooks
- `site.yml` - Main entry point, runs all roles
- `playbooks/setup.yml` - Initial machine setup
- `playbooks/maintenance.yml` - Updates and upgrades

## Prerequisites

- macOS with [Homebrew](https://brew.sh) installed
- Python 3.12+
- [uv](https://github.com/astral-sh/uv) for dependency management

## Setup

```bash
# Install Python dependencies
uv sync

# Install required Ansible collections
uv run ansible-galaxy collection install -r requirements.yml
```

## Usage

### Full Setup
```bash
make run          # Run site.yml (all roles)
make setup        # Run setup playbook
```

### Maintenance
```bash
make maint        # Update and upgrade all packages
```

### Specific Tasks
```bash
make brew         # Install Homebrew packages only
make dirs         # Create directories only
make git          # Clone/update git repos only
```

### Using Tags
```bash
make run TAGS=brew,dirs
```

### Direct Ansible Commands
```bash
uv run ansible-playbook site.yml
uv run ansible-playbook site.yml --tags brew
uv run ansible-playbook playbooks/maintenance.yml
```

## Configuration

Edit `inventory/group_vars/all.yml` to customize:

```yaml
brew_packages:
  - git
  - fzf
  - nvim
  - stow

cask_packages:
  - firefox
  - visual-studio-code

directories:
  - ~/code
  - ~/work
  - ~/personal

git_repos:
  - repo: https://github.com/user/dotfiles.git
    dest: ~/dotfiles
```

## Extending

### Adding a New Role
```bash
mkdir -p roles/myrole/{tasks,defaults,handlers,meta}
```

Create `roles/myrole/tasks/main.yml`:
```yaml
---
- name: My task
  ansible.builtin.debug:
    msg: "Hello from myrole"
```

Add to `site.yml`:
```yaml
roles:
  - role: myrole
    tags: [mytag]
```

### Adding Host-Specific Variables
```bash
mkdir -p inventory/host_vars
```

Create `inventory/host_vars/localhost.yml` for machine-specific overrides.

## Linting

```bash
make lint
```
