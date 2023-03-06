---
title: Android短信与电话模块分析
uuid: 178
status: publish
date: 2019-11-28 17:51:46
tags: 短信与电话, Android
categories: Android
description: 公司有短信pdu相关业务, 借此机会分析了一波，短信与电话模块的代码，实话讲没分析出个啥，可参考意义不大， 后续有机会再整理分析, 又是一个坑。。。
---

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

最终是通过AIDL, 访问android.hardware.radio.V1_1.IRadio, 再通过hidl方问硬件so库, 具体调用链如下:
com.android.internal.telephony.RIL.java::sendImsGsmSms() -> 
	android.hardware.radio.V1_1.IRadio.java::sendImsSms() -> 
		android.os.HwParcel -> android.os.IHwBinder::transact(104/*sendImsSms*/, _hidl_request, _hidl_reply, android.os.IHwBinder.FLAG_ONEWAY);
	com.android.internal.telephony.metrics.TelephonyMetrics.java::writeRilSendSms() /* 添加回调 */
	com.android.internal.telephony.metrics.InProgressSmsSession.java -> 
	com.android.internal.telephony.nano.TelephonyProto.SmsSession.Event
		
解析串口数据, 通过 com.android.internal.telephony.nano.TelephonyProto::writeTo() 回调上一部注册的 SmsSession.Event
Event里的信息有: TelephonySettings, TelephonyServiceState, ImsConnectionsState, RilDataCall[], errorCode 是我们要关心的, 开关机检测主要关心ImsConnectionState.
ImsConnectionState 中有状态 STATE_UNKONWN, CONNECTED, PROGRESSING, RESUMED, SUSPENDED.
结合以上的at指令终端交互流程可知, ImsConnectionState, errorCode, 即为短信发送后可获取的具体状态. 

接下来, 继续确定, framework层抛出的短信broadcast 是否依ImsConnectionState 状态决定的. 

注册调用链:

com.android.internal.telephony.SMSDispatcher.java::sendText(.., deliveryIntent, mSenderCallback) ->
	com.android.internal.telephony.SMSDispatcher.MultiparSmsSender::onServiceReady() -> 
		android.service.carrier.ICarrierMessagingService.aidl::sendMultipartTextSms(...,deliveryIntent, mSenderCallback) ->
		com.android.internal.telephony.SMSDispatcher.SmsSenderCallback::onSendSmsComplete() -> 
			com.android.internal.telephony.CommandsInterface, 
			在CommandsInterface::setOnSmsStatus 回调中, 调用注册deliveryIntent, 向上层应用发送消息状态. 

调用 mSenderCallback的流程:

SMSDispatcher 即为一个Handler, 处理短信发送相关的几个状态为: 
	EVENT_SEND_SMS_COMPLETE, EVENT_SEND_RETRY, EVENT_SEND_CONFIRMED_SMS, EVENT_STOP_SENDING, EVENT_HANDLE_STATUS_REPORT, 
	EVENT_SEND_LIMIT_REACHED_CONFIRMATION, EVENT_CONFIRM_SEND_TO_POSSIBLE_PREMIUM_SHORT_CODE
初始化SMSDISPATCHER的类为
com.android.internal.telephony.IccSmsInerfaceManager, 
初始化的实类为 ImsSmsDispatcher, 在其handleMessage中 处理的消息为 EVENT_IMS_STATE_DONE, EVENT_IMS_STATE_CHANGED
触发这个消息的的类为 
在CommandsInterface::registerForImsNetworkStateChanged(this, EVENT_IMS_STATE_CHANGED, null);
CommandsInterface 的实例 mCi 为 com.android.internal.telephony.Phone.java 中的单例
Phone的实例为 GsmCdmaPhone.java , 通过 TelephonyComponentFactory::makeIccSmsInterfaceManager(this) 传入
GsmCdmaPhone::initOnce() 中通过 TelephonyComponentFactory::makeGsmCdmaCallTracker() 初始化 
在Phone系的构造函数中会构造TelephoneComponentFactory.makeAppSmsManager 初始化 AppSmsmanager 监听短信状态. 
在IccSmsInterfaceManager 构造函数中初始化 ImsSMSDispatcher 会传递 phone.smsUsageMonitor, 初始化InBoundSmsHandler, SmsBroadcastUndelivered 
在InboundSmsHandler::dispatchSmsDeliveryIntent 中会调用 mAppSmsManager.handleSmsReceiverdIntent
InboundSmsHandler::processMessage 调用 dispatchSmsDeliveryIntent, 在初始化 StartupState 中由消息 EVENT_BROADECAST_SMS 处理短信发送状态. 

由InboundSmsHandler.StartupState 中的注释可知, 最终通知回调的类为SmsBroadcastUndevlivered, 其中亦有 EVENT_BROADECAST_SMS 消息事件处理, 逻辑为开一个线程轮询查询RawTable, 通过 ContentProvider 查询 PDU_PENDING_MESSAGE_PROJECTION, 通过 Telephony.Sms.CONTENT_URI ("content://sms/sent")找到 SMS Provider 查询rawpdudata 

那么表里的信息是何时写的呢? 在 InboundSmsHandler::writeInboxMessage 由 InboundSmsHandler::dispatchSmsDeliveryIntent 由SmsManager::getAutoPersisting()为true时触发

继续跟踪 InboundSmsHandler::dispatchSmsDeliveryIntent 的触发时机
由 android.telephony.CarrierMessagingServiceConnection.CarrierMessagingServiceConnection::onServiceConnected -> 
	android.telephony.CarrierMessagingServiceConnection::onServiceReady(在android.internal.telephony.CarrierServiceSmsFilter中实现) ->
	android.internal.telephony.CarrierServiceSmsFilter::filterSms ->
	InboundSmsHandler.CarrierServiceSmsFilterCallback::onFilterComplete ->
	InboundSmsHandler::dispatchSmsDeliveryIntent

接下来 分析 CarrierMessagingServiceConnection 中的 ICarrierMessagingService::filterSms() 逻辑, 
ICarrierMessagingService 由 CarrierMessagingSerivce 中的 ICarrierMessagingWrapper 作为service 端来实现具体业务
			
结合短信发送流程: 接收端收到一条短信, 会向SMS center 发送一条是否成功的报文, SMS center 再将这些信息返回给发送者(可参考附录10), 这时发送端相当于接收了一条pdu, android 作为接收端就是遍历这些pdu, 通过filterSms 来达确认是否成功送达或是一条新短信. 

CarrierMessagingSerivce 编历的pdu, 是怎么获取的? 这里仍旧没有探索到. 

分析至此, 已可知当前的短信开关机检测是与at命令的效果一致的. 

因此当前的开关机检测可视为准确的. 

PS: 时间有限, 关于此次分析相关的UML图, 流程图就先不画了, 直接采用文字描述. 有纰漏之处或者疑问, 欢迎指出, 进行进一步计论.  


### 查看radio 日志

修改 system/core/liblog/logger_write.c 中 __android_log_buf_write() 方法, 将RIL, IMS, AT log都打开, 合并到radio buffer 中

adb logcat -b radio 查看 radio buffer 中的日志信息.  

查看pdu, 在deliveringIntent 中的 pdu 中存储的. 只有联通给联通电信发, 电信给电信发, 移动给移动发才有. 

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
10. [Message Delivery Reports](http://www.developershome.com/sms/sms_tutorial.asp?page=basicConcepts#5.4)
