# Example AWS Cli Layer

In this example, we will be creating a layer that installs the aws binary in a lambda layer
so that we can call it for particular cluster authentication actions (thinking of aws eks)

## Important Caveats:

### Build environment

Unless you find support for creating your own docker image, it is most advisable to create your layer
using the sam docker cli.  This will build the corresponding binaries in the correct docker container
that they will be run in.  The only issue with this is that you will need to see what tools are available
on that image (for instance, standard package installers are not available).

### Folder Location

Your makefile in this folder is called with your lambda function on build **BUT** your folder name
has to match the contentUri property that you declare in the root-level template.yaml.

### S3 Content Location

Because this resource is Cloudformation Extension, we want to be very mindful that all layers we use
are strictly built and supplied for this lambda (not shared).  This is because the extension should
be the first element registered before any other lambda implementations or layers in a disaster 
recovery scenario.  Please ensure that your ContentUri in the top-level directory is correct.

### Docker Building

If you are using layers, you most likely are trying to add binaries to your lambda.  Because of this,
you basically **must** use the `yarn sam-build-docker` command.  If you think about this specific example,
you can realize that you might inadvertently package your mac or windows kubectl binary and end up not
being able to call the kubectl once it is running on the Linux node18 image for lambdas.  Therefore, you
want to do the install inside of here.

## Symbolic Links

If you are using something like aws-cli that creates symlinks to your bin folder, please pay close attention
to the Make command that changes all symbolic links to relative within the bin/ folder.  This way, we can
copy our binaries around without having broken links.

# Testing

This example also provides a very simple layer_test.js file that can be used in conjunction with a Function
declaration in the template.yaml.  It is called by the package script `test-layers` which basically calls
`bin/test-layers.sh`.  This simple test script has a few expectations about the function that it is calling:

1. The function will only return `SUCCESS` if it has succeeded to the end
2. The function (and only layer test functions) will be named something like `LayerTest`

This type of setup is ideal for compartmentalizing failure modes and ensuring that layers were functioning
in a very simple lambda before being used elsewhere.

