# CertBot manual DNS management scripts via Yandex API

## Useful links

- [Yandex API Access](https://yandex.ru/dev/api360/doc/concepts/access.html)
- [Yandex DNS API](https://yandex.ru/dev/api360/doc/ref/DomainDNSService.html)

## Examples

### Clone it first

```bash
git clone https://github.com/magf/certbot-dns-yandex.git first
cd  certbot-dns-yandex
```

> **warning**
> **See this scripts before running!**
> I don't give you any guarantees. You do this at your own risk.

### Generate wildcard

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

### Force Renew

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

> **warning**
> **Do not delete or move scripts after the certificate is issued.** CertBot will create a cronjob that will look for them here when requesting a certificate renewal.
