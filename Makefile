# IMPORTANT - This makefile contains commands for SAM CLI to run the build of the file
# Please see: https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/building-custom-runtimes.html

# Get current location of this file
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

tmp_build_dir := tmp
tmp_pack_file := $(tmp_build_dir)/tmp-pack.tgz

# Main Build functions
build-TypeFunction: yarn-pnp-flow
build-TestEntrypoint: yarn-pnp-flow

# The Following are build stage methods
esbuild-flow: esbuild pack copy-to-build-folder clean-pack-tmp-artifacts

esbuild:
	cd "$(mkfile_dir)" && yarn --version && yarn es-build && echo "$(ARTIFACTS_DIR)"

pack: clean-pack-tmp-artifacts
	cd "$(mkfile_dir)" && yarn pack -o $(tmp_pack_file)

copy-to-build-folder: 
	tar -xvzf tmp/tmp-pack.tgz -C $(tmp_build_dir) && cp -R $(tmp_build_dir)/package/. $(ARTIFACTS_DIR)

clean-pack-tmp-artifacts:
	cd "$(mkfile_dir)" && rm -rf $(tmp_build_dir) && mkdir $(tmp_build_dir)

# TODO: if this requires the use of sequelize, etc, then you will need to 
# switch the following command to the build-<function> commands
yarn-pnp-flow: ts-build create-pnp-folder pack copy-to-build-folder clean-pack-tmp-artifacts

ts-build:
	cd "$(mkfile_dir)" && yarn build

create-pnp-folder:
	cd "$(mkfile_dir)" && yarn prod-install $(ARTIFACTS_DIR)

insert-pnp-files:
	cd "$(mkfile_dir)" && $(mkfile_dir)bin/insert-pnp-init.sh "$(ARTIFACTS_DIR)" "dist/handlers.js"