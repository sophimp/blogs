#!/bin/sh

rm shared.*
rm *.keystore

KEYSTORE_NAME=$1

if [ ! -n "$1" ]
then
	KEYSTORE_NAME='mkp_enchilada_system_debug'
fi

# 把pkcs8格式的私钥转化成pkcs12格式：
openssl pkcs8 -in platform.pk8 -inform DER -outform PEM -out shared.priv.pem -nocrypt

# 把x509.pem公钥转换成pkcs12格式： alias: androiddebugkey 密码都是：android
openssl pkcs12 -export -in platform.x509.pem -inkey shared.priv.pem -out shared.pk12 -name androiddebugkey -password pass:android

# 生成platform.keystore
keytool -importkeystore -deststorepass android -destkeypass android -destkeystore $KEYSTORE_NAME.keystore -srckeystore shared.pk12 -srcstoretype PKCS12 -srcstorepass android -alias androiddebugkey

