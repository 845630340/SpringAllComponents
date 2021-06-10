# 通过groovy配置报警

---

DomeOS v0.5支持通过groovy动态配置报警，方便使用者根据实际情况自定义报警发送方式。DomeOS server中有三个报警发送接口，分别用于发送邮件、短信、微信。

## 配置邮件报警服务

DomeOS server中用于接收邮件报警的url为http://[server ip:port]/api/alarm/send/mail，接收POST类型的http请求，请求参数为tos，subject，content和sender，其中tos是接收报警信息的email地址（多个地址使用逗号分隔），subject是邮件标题，content是邮件内容，sender是用于发送邮件的groovy配置文件名称（默认为groovy/DefaultMailSender.groovy）。

后台利用javax.mail实现邮件发送，邮件服务器地址和邮件来源地址通过groovy配置。在groovy配置文件中，必须存在send函数，该函数的参数为String类型的number（一个邮件地址），subject（邮件标题）和content（邮件内容），返回值为必须包含‘host’和‘fromAddr’两个key的Map<String,String>。DomeOS server会调用groovy中的send函数获取配置，读取host作为邮件服务器，读取fromAddr作为邮件发送地址。

DomeOS server会读取进程运行目录下groovy文件夹中的由sender指定的配置文件。例如POST请求中sender=SohuMailSender，后台会自动加载文件groovy/SohuMailSender.groovy中的配置，发送邮件。参考groovy/SohuMailSender.groovy：

```java
class SohuMailSender {
    public Object send(String number, String subject, String content) throws Exception {
        return ["fromAddr": "domeos@sohu-inc.com",
                "host": "mail.sohu.com",
                "number": number,
                "subject": subject,
                "content": content]
    }
}
```

## 配置短信报警服务

DomeOS server中用于接收短信报警的url为http://[server ip:port]/api/alarm/send/sms，接收POST类型的http请求，请求参数为tos，subject，content和sender，其中tos是接收报警信息的手机号码（多个号码使用逗号分隔），subject是标题，content是短信内容，sender是用于发送短信的groovy配置文件名称（默认为groovy/DefaultSMSSender.groovy）。

配置短信报警的groovy文件中必须包含send函数，后台会调用该函数来发送报警。文件命名规则和参数列表与邮件服务一致。此处需要在groovy中发送请求给短信服务器，DomeOS server仅调用groovy中的send函数。参考groovy/SohuSMSSender.groovy

```java
import groovyx.net.http.HTTPBuilder

class SohuSMSSender {
    public Object send(String number, String subject, String content) throws Exception {
        try {
            def params = ['body': ['number': number,
                                   'content'   : content]]
            def httpclient = new HTTPBuilder('http://sms.sohu.com')
            httpclient.post(params)
        } catch (Exception e) {
            return e.getMessage()
        }
        return ''
    }
}
```

## 配置微信报警服务

DomeOS server中用于接收短信报警的url为http://[server ip:port]/api/alarm/send/wechat，接收POST类型的http请求，请求参数为tos，subject，content和sender，其中tos是接收报警信息的手机号码（多个号码使用逗号分隔），subject是标题，content是短信内容，sender是用于发送微信的groovy配置文件名称（默认为groovy/DefaultWechatSender.groovy）。

配置微信报警的groovy文件中必须包含send函数，后台会调用该函数来发送报警。文件命名规则和参数列表与邮件服务一致。此处需要在groovy中发送请求给微信服务器，DomeOS server仅调用groovy中的send函数。参考groovy/SohuWechatSender.groovy

```java
import groovyx.net.http.HTTPBuilder

class SohuWechatSender {
    public Object send(String number, String subject, String content) throws Exception {
        try {
            def params = ['body': ['number': number,
                                   'content'   : content]]
            def httpclient = new HTTPBuilder('http://wechat.sohu.com')
            httpclient.post(params)
        } catch (Exception e) {
            return e.getMessage()
        }
        return ''
    }
}
```
