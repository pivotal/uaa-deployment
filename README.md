** This repo is currently actively in development **
# Deploying a standalone UAA

## Pave your IaaS and get a BOSH Director

Before you can start deploying,
you'll need to make sure you've configured your infrastructure appropriately
and deployed a BOSH Director.
If you're using AWS, GCP, or Azure,
we'd suggest using [bbl](https://github.com/cloudfoundry/bosh-bootloader)
to set up your IaaS resources and bootstrap a BOSH director.
Otherwise, take a look at [the BOSH documentation](https://bosh.io/docs/init.html)
for information about prerequisites for a given IaaS
and installing a BOSH Director there.

#### bosh-lite
If you're deploying bosh-lite to a VM on AWS, GCP, or Azure,
look at [this guide](iaas-support/bosh-lite/README.md).

If you're planning to deploy against a **local** bosh-lite,
follow [these instructions](https://bosh.io/docs/bosh-lite.html).
You'll also need to take the following step before continuing:
```
mkdir -p ~/workspace
pushd ~/workspace
  git clone https://github.com/DennisDenuto/openldap-boshrelease.git
  git clone https://github.com/cloudfoundry/uaa.git
popd
```

# Deploy uaa
```
bosh -e vbox -d uaa deploy uaa.yml \
  -o operations/use-bosh-dns.yml \
  --no-redact
sudo -E ./configure-host.sh
```

# Deploy uaa with ldap
```
bosh -e vbox -d uaa deploy uaa.yml \
  -o operations/use-bosh-dns.yml \
  -o operations/identity_providers/add_ldap.yml \
  --vars-store=./store.json \
  --no-redact
sudo -E ./configure-host.sh
```

# Testing uaa standalone deployment
1) uaac target https://uaa-minimal.bosh-lite.com:8443

2) find clients created in the UAA internal store:
```
bosh int --path=/instance_groups/name=uaa/jobs/name=uaa/properties/uaa/clients  <(bosh -e vbox -d uaa manifest)
```
3) get a token:
```
uaac token client get admin -s adminsecret
```

# If you have deployed with ldap idp:
4) add users to ldap
```
bosh -e vbox -d uaa errands
bosh -e vbox -d uaa run-errand add-dn
uaac token owner get admin belle -s adminsecret -p koala
```
