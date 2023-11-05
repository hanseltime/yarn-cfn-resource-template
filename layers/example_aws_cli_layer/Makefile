#######################################
# See: https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/building-layers.html
#######################################

# Creates a layer that provides the aws cli binary (for linux x86) in the correct bin path
# Installation adapted from: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
build-AwsCliLayer: install-managed-packages
	curl --fail "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; \
	unzip awscliv2.zip; \
	./aws/install --install-dir $(ARTIFACTS_DIR)/bin/aws-cli --bin-dir $(ARTIFACTS_DIR)/bin; \
	echo "Replace all links with relative links"; \
	cd $(ARTIFACTS_DIR)/bin; \
	find . -type l | while read l; do \
		target="$$(realpath "$$l")"; \
		rm -f $$l; \
		ln -fs "$$(realpath --relative-to="$$(dirname "$$(realpath -s "$$l")")" "$$target")" "$$l"; \
	done \
