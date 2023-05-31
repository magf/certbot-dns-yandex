#!/bin/bash
_dir="$(dirname "$0")"
source "$_dir/config.sh"

echo "`date` *CLEAN* -- DOMAIN $CERTBOT_DOMAIN" >> ${logFile}
echo "`date` *CLEAN* -- Validtion $CERTBOT_VALIDATION"  >> ${logFile}

# Get domain name from FQDN
domain=`echo $CERTBOT_DOMAIN | sed -E 's/(.*)\.(.+\..+)$/\2/'`

# Remove the challenge TXT record from the zone
if [ -f /tmp/certbot_$CERTBOT_DOMAIN/RECORD_ID ]; then
    recordIds=`cat /tmp/certbot_$CERTBOT_DOMAIN/RECORD_ID | jq .recordId`
    unset ERR
    for recordId in $recordIds
    do
        [[ -n "${recordId}" ]] && \
            RESULT=`curl --silent -X DELETE https://api360.yandex.net/directory/v1/org/${orgId}/domains/${domain}/dns/${recordId} \
                    -H "Authorization: OAuth ${OAuth}"`
        [[ "$RESULT" == "{}" ]] &&  echo "`date` *CLEAN* -- RECORD_ID \"$recordId\" removed" >> ${logFile} \
                                || (echo "`date` *CLEAN* -- RECORD_ID \"$recordId\" NOT removed. RESULT: \"$RESULT\""  >> ${logFile}; ERR=1)
    done
    [[ -z $ERR ]] && (echo "`date` *CLEAN* -- File /tmp/certbot_$CERTBOT_DOMAIN/RECORD_ID removed"  >> ${logFile}; rm -f /tmp/certbot_$CERTBOT_DOMAIN/RECORD_ID) \
                  ||  echo "`date` *CLEAN* -- File /tmp/certbot_$CERTBOT_DOMAIN/RECORD_ID NOT removed" >> ${logFile}
fi
