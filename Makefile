.PHONY: run setup maint lint brew git dirs sync

# Default to running everything
TAGS ?= all

# If TAGS is 'all', run normally. Otherwise, pass the tags flag.
ifeq ($(TAGS),all)
    TAG_FLAG =
else
    TAG_FLAG = --tags $(TAGS)
endif

# Main entry point - runs site.yml
run:
	@echo "Running site.yml"
	@uv run ansible-playbook site.yml $(TAG_FLAG)

# Initial setup
setup:
	@echo "Running setup playbook"
	@uv run ansible-playbook playbooks/setup.yml $(TAG_FLAG)

# Maintenance - updates and upgrades
maint:
	@echo "Running maintenance playbook"
	@uv run ansible-playbook playbooks/maintenance.yml

# Linting
lint:
	@echo "Running Ansible Lint"
	@uv run ansible-lint site.yml playbooks/*.yml roles/*/tasks/*.yml

# Shorthand targets
brew:
	$(MAKE) run TAGS=brew

git:
	$(MAKE) run TAGS=git

dirs:
	$(MAKE) run TAGS=dirs

sync:
	@uv sync
