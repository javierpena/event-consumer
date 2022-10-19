# event-consumer
Sample event consumer deployment

### Set version

``export VERSION=4.9``

### Set transport host

You may edit ``manifests/deployment.yaml`` to set a different transport host
if it is deployed with a different namespace or interconnect name.

### Deploy

``make deploy``

### Undeploy

``make undeploy``
