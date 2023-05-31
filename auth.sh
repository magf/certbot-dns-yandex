#!/bin/bash
_dir="$(dirname "$0")"
source "$_dir/config.sh"

# Split FQDN to domain and subdomain if present
domain=`echo $CERTBOT_DOMAIN | sed -E 's/(.*)\.(.+\..+)$/\2/'`
subdomain=`echo $CERTBOT_DOMAIN | sed -E 's/(.*)\.(.+\..+)$/\1/'`
	
echo "`date` *AUTH* -- CERTBOT_DOMAIN \"$CERTBOT_DOMAIN\"" >> ${logFile}
echo "`date` *AUTH* -- CERTBOT_VALIDATION \"$CERTBOT_VALIDATION\""  >> ${logFile}
echo "`date` *AUTH* -- Asked domain: \"$domain\"" >> ${logFile}
echo "`date` *AUTH* -- Asked subdomain: \"$subdomain\"" >> ${logFile}

# Create TXT record
CREATE_DOMAIN="_acme-challenge.${subdomain}"
RECORD_ID=`curl --silent -X POST https://api360.yandex.net/directory/v1/org/${orgId}/domains/${domain}/dns \
        -H "Authorization: OAuth ${OAuth}" \
        -H "Content-Type: application/json" \
        -d '{"name":"'"$CREATE_DOMAIN"'","type":"TXT","ttl":"3600","text":"'"$CERTBOT_VALIDATION"'"}'`

echo "`date` *AUTH* -- Asked record: {\"name\":\"$CREATE_DOMAIN\",\"type\":\"TXT\",\"ttl\":\"3600\",\"text\":\"$CERTBOT_VALIDATION\"}" >> ${logFile}
echo "`date` *AUTH* -- Recieved responce: \"$RECORD_ID\"" >> ${logFile}

# Save info for cleanup
mkdir -p -m 0700 /tmp/certbot_$CERTBOT_DOMAIN
echo $RECORD_ID >> /tmp/certbot_$CERTBOT_DOMAIN/RECORD_ID

echo "`date` *AUTH* -- File /tmp/certbot_$CERTBOT_DOMAIN/RECORD_ID created/updated"  >> ${logFile}
# cat /tmp/certbot_$CERTBOT_DOMAIN/RECORD_ID >> ${logFile}

# Sleep ONE HOUR to make sure the change has time to propagate over to DNS. Yandex DNS is very-very-very slow
sleep 3600
