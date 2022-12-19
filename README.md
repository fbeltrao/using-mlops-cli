# Sample project using ML Ops cli

This is a sample project that use the [ML Ops cli](./https://github.com/fbeltrao/mlops-cli). It can auto-update the tooling through the usage of `make init`.

## How it works

Using makefile `init` target, we get the latest version of the cli into the git ignored folder `.mlops`. The makefile optionally includes it `-include .mlops/makefile`.

Upon `make init` we use git sparse-checkout to only get the folder we want from cli repository:

```plain
.PHONY: -setup-mlops
ifeq ($(OS),Windows_NT)
-setup-mlops:
	@echo Running ML Ops setup...
	@if exist mlops-temp\ rmdir mlops-temp /S /Q
	@if exist .mlops\ rmdir .mlops /S /Q
	@git clone $(MLOPS_REPO_URL) --no-checkout --quiet --depth 1 mlops-temp
	@cd mlops-temp && git sparse-checkout init --cone && git sparse-checkout set .mlops && git checkout $(MLOPS_REPO_VERSION) --quiet
	@mkdir .mlops && xcopy mlops-temp\.mlops .mlops\ /E/H/Y/Q && rmdir mlops-temp /S /Q && echo Done! ✅
else
-setup-mlops:
	@echo -n Running ML Ops setup...
	@rm .mlops-temp -rf && rm .mlops -rf
	@git clone $(MLOPS_REPO_URL) --no-checkout --quiet --depth 1 .mlops-temp
	@cd .mlops-temp && git sparse-checkout init --cone && git sparse-checkout set .mlops && git checkout $(MLOPS_REPO_VERSION) --quiet
	@mkdir -p .mlops && cp -r .mlops-temp/.mlops . && rm .mlops-temp -rf && echo " Done! ✅"
endif
```

For a fast `init` target we check if the `.mlops` directory exists, skipping it in case we find it.
