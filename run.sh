#!/bin/sh

/opt/1cv8/x86_64/8.3.27.1719/webinst -apache24 -wsdir ${DB_1C} -dir $SITE_DIR -connstr "Srvr=${SERVER_1C};Ref=${DB_1C};" -confPath /etc/apache2/apache2.conf 

sed -i -e 's/standardOdata enable="false"/standardOdata enable="true"/' /opt/web/default.vrd
sed -i -e "s/reuseSessions=\"autouse\"/reuseSessions=\"$REUSESESSIONS\"/" /opt/web/default.vrd
sed -i -e '/<\/point>/i <httpServices publishExtensionsByDefault="true" />' /opt/web/default.vrd


apache2 -DFOREGROUND
