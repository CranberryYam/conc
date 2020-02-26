check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))

CONCOURSE_URL := "https://concourse.leap.cloud-nbcuniversaltech.com"
CONCOURSE_USER := "concourse"

install_fly:
	$(eval OS_TYPE := $(if $(filter $(shell uname),Darwin), darwin,linux))
	$(shell test -e ./fly || (curl -o ./fly "$(CONCOURSE_URL)/api/v1/cli?arch=amd64&platform=$(OS_TYPE)" && chmod +x ./fly))

configure_fly:
	@:$(call check_defined, CONCOURSE_URL, CONCOURSE_URL required)
	@:$(call check_defined, CONCOURSE_USER, CONCOURSE_USER required)
	@:$(call check_defined, CONCOURSE_PASSWORD, CONCOURSE_PASSWORD required)
	./fly --target leap login --concourse-url $(CONCOURSE_URL) -u $(CONCOURSE_USER) -p $(CONCOURSE_PASSWORD)

fly: install_fly configure_fly
	./fly --target leap $(ARGS)

deploy_pipline: install_fly configure_fly
	./fly --target leap set-pipeline --pipeline henry-conc --config ./pipeline.yaml -n

#export CONCOURSE_PASSWORD=Q9WeWxqvCZh5ID4zh1C/6QNOxydsXRcx