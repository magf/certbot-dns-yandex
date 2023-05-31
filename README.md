# CertBot manual DNS management scripts via Yandex API

[Yandex API Access](https://yandex.ru/dev/api360/doc/concepts/access.html)

[Yandex DNS API](https://yandex.ru/dev/api360/doc/ref/DomainDNSService.html)

## Generate wildcard

```bash
sudo certbot certonly \
  --agree-tos \
  --manual-public-ip-logging-ok \
  --preferred-challenges=dns \
  --email certbot@mydomain.tld \
  --server https://acme-v02.api.letsencrypt.org/directory \
  --renew-by-default \
  --manual \
  --manual-auth-hook $(pwd)/auth.sh \
  --manual-cleanup-hook $(pwd)/cleanup.sh \
  -d mydomain.tld \
  -d *.mydomain.tld

```

## Force Renew

```bash
sudo renew certonly \
  --preferred-challenges=dns \
  --server https://acme-v02.api.letsencrypt.org/directory \
  --force-renew \
  --manual \
  --manual-auth-hook $(pwd)/auth.sh \
  --manual-cleanup-hook $(pwd)/cleanup.sh \
  -d mydomain.tld \
  -d *.mydomain.tld

```
