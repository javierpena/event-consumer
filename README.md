# event-consumer
Sample event consumer deployment

### Set version

``export VERSION=4.12``

### Set transport host

You may need to edit ``manifests/deployment.yaml`` if deploying on OpenShift 4.16
or later (see comments in file). Also, change it if a different transport type
(AMQ) is in use, or it runs on a different namespace or interconnect name.

### Deploy

``make deploy``

### Undeploy

``make undeploy``
