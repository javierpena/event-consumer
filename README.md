# event-consumer
Sample event consumer deployment

### Set version

``export VERSION=4.12``

### Set transport host

You may need to edit ``manifests/deployment.yaml`` to set the right host name in the
``--http-event-publishers`` argument. Also, change it if a different transport type
(AMQ) is in use, or it runs on a different namespace or interconnect name.

### Deploy

``make deploy``

### Undeploy

``make undeploy``
