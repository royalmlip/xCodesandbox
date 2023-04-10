#!/bin/sh
# Create By ifeng
# Web Site:https://www.hicairo.com
# Telegram:https://t.me/HiaiFeng

UUID=${UUID:-'d3ab62cf-3206-4317-8804-a4509db3f366'}
VMESS_WSPATH=${VMESS_WSPATH:-'/vmess'}
VLESS_WSPATH=${VLESS_WSPATH:-'/vless'}
TROJAN_WSPATH=${VLESS_WSPATH:-'/trojan'}
URL=${HOSTNAME}-8080.csb.app

sed -i "s#UUID#$UUID#g;s#VMESS_WSPATH#$VMESS_WSPATH#g;s#VLESS_WSPATH#$VLESS_WSPATH#g;s#TROJAN_WSPATH#$TROJAN_WSPATH#g" /etc/mysql/config.json
sed -i "s#VMESS_WSPATH#$VMESS_WSPATH#g;s#VLESS_WSPATH#$VLESS_WSPATH#g;s#TROJAN_WSPATH#$TROJAN_WSPATH#g" /etc/nginx/nginx.conf

vmlink=vmess://$(echo -n "{\"v\":\"2\",\"ps\":\"hicairo.com\",\"add\":\"$URL\",\"port\":\"443\",\"id\":\"$UUID\",\"aid\":\"0\",\"net\":\"ws\",\"type\":\"none\",\"host\":\"$URL\",\"path\":\"$VMESS_WSPATH\",\"tls\":\"tls\"}" | base64 -w 0)
vllink="vless://"$UUID"@"$URL":443?encryption=none&security=tls&type=ws&host="$URL"&path="$VLESS_WSPATH"#hicairo.com"
trllink="trojan://"$UUID"@"$URL":443?path="$TROJAN_WSPATH"&security=tls&host="$URL"&type=ws&sni="$URL"#trojan."


qrencode -o /usr/share/nginx/html/M$UUID.png $vmlink
qrencode -o /usr/share/nginx/html/L$UUID.png $vllink
qrencode -o /usr/share/nginx/html/T$UUID.png $trlink

cat > /usr/share/nginx/html/$UUID.html<<-EOF
<html>
<head>
<title>Codesandbox</title>
<style type="text/css">
body {
      font-family: Geneva, Arial, Helvetica, san-serif;
    }
div {
      margin: 0 auto;
      text-align: left;
      white-space: pre-wrap;
      word-break: break-all;
      max-width: 80%;
      margin-bottom: 10px;
}
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<div><font color="#009900"><b>VMESS协议链接：</b></font></div>
<div>$vmlink</div>
<div><font color="#009900"><b>VMESS协议二维码：</b></font></div>
<div><img src="/M$UUID.png"></div>
<div><font color="#009900"><b>VLESS协议链接：</b></font></div>
<div>$vllink</div>
<div><font color="#009900"><b>VLESS协议二维码：</b></font></div>
<div><img src="/L$UUID.png"></div>
<div><font color="#009900"><b>TROJAN协议链接：</b></font></div>
<div>$trlink</div>
<div><font color="#009900"><b>TROJAN协议二维码：</b></font></div>
<div><img src="/T$UUID.png"></div>
</body>
</html>
EOF

echo https://$URL/$UUID.html > /usr/local/mysql/info
# exec "$@"
