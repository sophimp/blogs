
## android 短信与电话模块分析

目的: 

	1. 何为AT指令?
	2. 分析源码, 确认at指令的发送以及返回信息的内容, 是否可以抛到上层, 
	3. 当前的开关机检测机制是否准确? 
	4. 在适配rom的时候, 这方面涉及的到配置有哪些? rc文件, so库, system.prop
	

### at指令

AT指令是一种 Command language, 也叫作 Hayes command set, 是 Dennis Hayes 在1981年为其发明的300波特率的调制解调器发明的语言. 这一命令集由一系列的短文本字符串组成, 这些指令可以联合起来产生拨打电话, 挂断电话, 改成连结参数等一系列操作指令. 更说细的内容请参考附录[2][3]. 

sms 和 mms 相关介绍参考附录[1]

每一条at指令需要回车符作为确认, 否则设备不认可

发送短信

	1. AT+CMGF=1 回车				// 设置短信发送格式, 1 代表文本格式, 0 代表pdu格式
	2. AT+CMCA="+86138******" 回车	// 设置电话号码, 一般模块都会默认设置
	3. AT+CMCS="+86 手机号码" 回车 // 设备会返回一个 ">"
	4. 输入需要发送的字符串, ctrl+Z 结束发送. 

命令行示例:

```sh
AT+CMGF=1
OK
AT+CMGS="+31628870634"
> This is the text message.→
+CMGS: 198
OK
```

读取短信

	1. AT+CMGR=X 回车		// X代表sim卡中第几条短信, 一般sim卡是30-50不等 
	2. 串口会返回一长字符串 // 一般是由短信标志, 来电号码, 短信内容, 发送, 时间等等几部分组成. 
	3. AT+CMGD=x 回车		// 当sim卡满时, 是不可以收到短信的, 当设备收到短信时, 串口会返回一串字符

命令行示例:
```sh
AT+CMGF=1
OK
AT+CMGL="ALL"
+CMGL: 1,"REC UNREAD","+31628870634",,"11/01/09,10:26:26+04"
This is text message 1
+CMGL: 2,"REC UNREAD","+31628870634",,"11/01/09,10:26:49+04"
This is text message 2
OK
AT+CMGD=1
OK
AT+CMGD=2
OK
```
以上参考附录[6]

更详细的at指令互动参考附录[7], 以及附件pdf(sending_sms_at_commands.pdf)

更详细的at命令列表(完整的at列表请参看附录[8]及附件pdf(supported_at_command_reference)):
```sh
AT – Check to see if the module is active. Should return ‘OK’
AT+CREG? – Is the module registered to the network? Set the mode first: AT+CREG=2
AT+COPS? – What network is the module registered?
AT+CMGF=1 – This puts the module into text mode so messages can be sent/received
AT+CMGS=”number”,129 <cr>< body of message> <1A> – Send a text message.
AT+CMGL=”ALL” – Lists all text messages that are on the device (or network)
AT+CMGR=<index> – Read SMS message at index number
AT+QBAND? – What band am I on?
AT+CIMI – Get the IMSI number from the module
AT+CSQ – Check the signal strength
AT+GSN – Get IMEI number
AT+QSPN – Get service provider name
AT+QCCID – Get CCID number from SIM
AT+CRSM – SIM card restricted access (still researching)
AT+CSIM – Generic SIM access (still researching)
```

通过以上的资料可知, 由调制解调器封装后返回信息并不是很多, 信息发送成功也只是返回OK, 发送失败, 是通过等待一定的时间来判断的. 那么接下来分析,源码是否可以获取得多的信息, 判断当前的开关机检测是否准确. 

使用pdu 发送短信参考附件[9]

### 源码分析

com.android.internal.telephony.SMSDispatcher.java  调用接口sendText(...) 具体实现在下面两个类
	com.android.internal.telephony.gsm.GsmSMSDispatcher.java  进一步跟踪,调用链为 sendText() -> sendSms() -> sendSmsByPstn()
	com.android.internal.telephony.cdma.CdmaSMSDispather.java 同上

由上一步的GsmSMSDispatcher/CdmaSMSDispatcher 中的mCi.sendImsGsmIms 调用到 com.android.internal.telephony.RIL.java 中的 sendImsGsmSms()


附录:

1. [Everything You Need to Know About SMS & MMS on the iPhone](lifewire.com/what-is-sms-mms-iphone-2000247)
2. [SMS wiki](en.wikipedia.org/wiki/SMS)
3. [Introduction to AT Commands](developershome.com/sms/atCommandsIntro.asp)
4. [Hayes command set](wikipedia.org/Hayes_command_set)
5. [SMS Tutorial](developershome.com/sms)
6. [gsm-modem-tutorial](https://www.diafaan.com/sms-tutorials/gsm-modem-tutorial/at-cmgd/)
7. [Send SMS using AT commands](https://www.smssolutions.net/tutorials/gsm/sendsmsat/)
8. [gsm-at-commands-set](https://www.engineersgarage.com/tutorials/at-commands-gsm-at-command-set/)
9. [sms-pdu-mode](http://www.gsm-modem.de/sms-pdu-mode.html)
