# Developing

Since the cfn typescript plugin was prebuilt to use npm, this template is created to make use of the same plugin, but with yarn plug'n'play as a consideration.

In order to do this we make use of a few tools:

* make
* node version 18 and `corepack enable`
* yarn berry
* [prod install plugin](https://gitlab.com/Larry1123/yarn-contrib/-/raw/master/packages/plugin-production-install/bundles/@yarnpkg/plugin-production-install.js)

## Makefile

The makefile provided provides two different sets of build instructions depending on your needs:

1. esbuild-flow
2. yarn-pnp-flow

### esbuild-flow

This flow is the ideal flow since it will simply use esbuild to build the handlers.ts file into a single
compact handlers.js output that runs.  This is ideal for most implementations except where you would need
to somehow maintain file structure due to some library that does not play well with code bundlers.

### yarn-pnp-flow

This flow makes use of the yarn [prod install plugin](https://gitlab.com/Larry1123/yarn-contrib/-/raw/master/packages/plugin-production-install/bundles/@yarnpkg/plugin-production-install.js)

**Note:** This plugin serves its purpose but is not actively maintained, you may change it out for something 
that does equivalent functionality in the makefile that calls `yarn prod-install`

```shell
yarn plugin import https://gitlab.com/Larry1123/yarn-contrib/-/raw/master/packages/plugin-production-install/bundles/@yarnpkg/plugin-production-install.js
```

This flow will create a small bundled library (compatible with monorepos) with a yarn cache and .pnp.js file.
It will also bring your entire pack in and then ensure that the entry file (handlers.js) imports the .pnp.js file.

### Choosing your build flow

The SAM template.yaml is already set up to work out of the box for you by referencing the makefile as a custom runtime.  If you want to change your build flow, you just need to change the implementation for:

* build-TypeFunction
* build-TestEntrypoint
* build-<any other function name>

# IDE support

For yarn plug'n'play, you need to install your appropriate [editor sdk](https://yarnpkg.com/getting-started/editor-sdks/).  For convenience, this repo includes a working config with VSCode.  

You will still need to call `cmd + p -> Select Typescript Version`

# Tutorial

There is a pretty helpful introduction to typescript plugin development [here](https://aws.amazon.com/blogs/mt/introducing-typescript-support-for-building-aws-cloudformation-resource-types/)