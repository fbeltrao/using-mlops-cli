-include .mlops/makefile
MLOPS_REPO_URL=https://github.com/fbeltrao/mlops-cli.git
MLOPS_REPO_VERSION=main
include config.env

##################################################################
## Project specific targets
##################################################################
train: init mlops-train

##################################################################
## ML Ops targets (DO NOT MODIFY)
##################################################################
.PHONY: init
updateTools=false
init:
ifneq ($(updateTools),true)
ifneq ($(wildcard .mlops/makefile),)
init:
else
init: -setup-mlops
endif
else
init: -setup-mlops
endif

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