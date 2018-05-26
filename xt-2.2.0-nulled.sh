
green='\e[0;32m'
NC='\e[0m' # No Color
VER=$(exec uname -m|grep 64)
if [ "$VER" = "" ]
then VER="x86"
else VER="x64"
fi
echo -e "${green}[+]Checking System Version...${NC}"
sleep 1
echo -e "${green}[+]Detected a $VER System...${NC}"
sleep 1
echo -e "${green}[+]Installing System Requirements... This May Take Some Time...${NC}"
apt-get -qq update > /dev/null 2>&1
apt-get upgrade -y
apt-get -qq install aptitude -qy > /dev/null 2>&1
apt-get -qq install apache2 -qy > /dev/null 2>&1
echo -e "${green}[+]Installing PHP ...${NC}"
apt-get -qq install php5 libapache2-mod-php5 php5-mysql php5-mcrypt -qy > /dev/null 2>&1
apt-get -qq install unzip -qy > /dev/null 2>&1
if [ $(php -v | grep -v grep | grep -c '5\.3\.') -eq 1 ]
then PHPV="53"
elif [ $(php -v | grep -v grep | grep -c '5\.4\.') -eq 1 ]
then PHPV="54"
elif [ $(php -v | grep -v grep | grep -c '5\.5\.') -eq 1 ]
then PHPV="55"
fi
if [ "$PHPV" == "53" ] && [ "$VER" == "x86" ]
then url="http://www.xtream-codes.com/downloads/extension/x86_PHP5.3.zip"
elif [ "$PHPV" == "53" ] && [ "$VER" == "x64" ]
then url="http://www.xtream-codes.com/downloads/extension/x64_PHP5.3.zip"
elif [ "$PHPV" == "54" ] && [ "$VER" == "x86" ]
then url="http://www.xtream-codes.com/downloads/extension/x86_PHP5.4.zip"
elif [ "$PHPV" == "54" ] && [ "$VER" == "x64" ]
then url="http://www.xtream-codes.com/downloads/extension/x64_PHP5.4.zip"
elif [ "$PHPV" == "55" ] && [ "$VER" == "x86" ]
then url="http://www.xtream-codes.com/downloads/extension/x86_PHP5.5.zip"
elif [ "$PHPV" == "55" ] && [ "$VER" == "x64" ]
then url="http://www.xtream-codes.com/downloads/extension/x64_PHP5.5.zip"
fi
cd /etc/
wget -O /etc/xtream_codes.zip "$url" && unzip xtream_codes.zip && rm xtream_codes.zip
if ! cat /etc/php5/apache2/php.ini | grep -v grep | grep -c 10000000000 > /dev/null
then
echo extension=mcrypt.so >> /etc/php5/apache2/php.ini
fi
if ! cat /etc/php5/apache2/php.ini | grep -v grep | grep -c 10000000000 > /dev/null
then
echo pcre.backtrack_limit=10000000000 >> /etc/php5/apache2/php.ini
fi
if ! cat /etc/php5/apache2/php.ini | grep -v grep | grep -c xtream_codes.so > /dev/null
then
echo extension=/etc/xtream_codes.so >> /etc/php5/apache2/php.ini
fi
sleep 1
if ! cat /etc/php5/cli/php.ini | grep -v grep | grep -c mcrypt.so > /dev/null
then
echo extension=mcrypt.so >> /etc/php5/cli/php.ini
fi
if ! cat /etc/php5/cli/php.ini | grep -v grep | grep -c 10000000000 > /dev/null
then
echo pcre.backtrack_limit=100000000 >> /etc/php5/cli/php.ini
fi
if ! cat /etc/php5/cli/php.ini | grep -v grep | grep -c xtream_codes.so > /dev/null
then
echo -e "${red}[%]Extension Not Found in php.ini, installing..${NC}"
echo extension=/etc/xtream_codes.so >> /etc/php5/cli/php.ini
fi
service apache2 restart > /dev/null 2>&1
sleep 1
cd /root
wget http://www.xtream-codes.com/downloads/iptv_installer.zip
unzip /root/iptv_installer.zip
chmod 777 /root/iptv_installer.sh 
/root/iptv_installer.sh
iptables -I INPUT -j ACCEPT
iptables-save > /etc/network/iptables.rules
echo 'Restarting system...'
sudo shutdown -r -f
