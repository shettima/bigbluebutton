# Introduction #

In this page, we are going to describe how to monitor BigBlueButton's performance (memory consumption, CPU usage, threads, etc) using  [Jconsole](http://download.oracle.com/javase/6/docs/technotes/tools/share/jconsole.html) and/or [JVisualVM](http://download.oracle.com/javase/6/docs/technotes/guides/visualvm/index.html).

Jconsole and VisualVM can put load on your server. It is recommended to connect remotely to your server to have correct results.

# Details #
### Generate Keys ###

Go to the Red5 conf directory
```
   cd /usr/share/red5/conf
```

Generate a keystore. You will be prompted for password and other information. Make note of the password you entered as you'll need them later.
```
   sudo keytool -genkey -alias jconsole -keystore red5JConsoleKeyStore
```

Check if the keystore has been generated properly.
```
   keytool -list -keystore red5JConsoleKeyStore
```

Let's export the keystore so we can use it to connect from JConsole or VisualVM
```
   sudo keytool -export -alias jconsole -keystore red5JConsoleKeyStore -file jconsole.cert
```

Now we copy `jconsole.cert` into the machine where we will run jconsole or VisualVM. Let's put it into a folder called `D:\visualvm`.

Import the into a file call `red5KeyStore`. When prompted for a password, enter the password you used when you created the keystore.
```
D:\visualvm>keytool -import -alias red5 -keystore D:\visualvm\red5KeyStore -file jconsole.cert
```

Now let's configure Red5 to use the keystore we generated and accept connections using SSL.

Open up `/usr/share/red5/conf/red5.properties`. Change the value of `rtmps.keystorepass` to the password you entered when generating the keystore. Also, change `jmx.rmi.host` to the IP of your Red5 server. And set `jmx.rmi.ssl=true`.

```
rtmps.keystorepass=password

# JMX
jmx.rmi.port.registry=9999
jmx.rmi.port.remoteobjects=
jmx.rmi.host=192.168.0.166
jmx.rmi.ssl=true
```

Open `/usr/share/red5/conf/conf/red5-common.xml`. Edit the value of `remoteSSLKeystore` to the keystore we generated (i.e. `red5JConsoleKeyStore`).
```
        <bean id="jmxAgent" class="org.red5.server.jmx.JMXAgent" init-method="init">
                <!-- The RMI adapter allows remote connections to the MBeanServer -->
                <property name="enableRmiAdapter" value="true"/>
                <property name="rmiAdapterPort" value="${jmx.rmi.port.registry}"/>
                <property name="rmiAdapterRemotePort" value="${jmx.rmi.port.remoteobjects}"/>
                <property name="rmiAdapterHost" value="${jmx.rmi.host}"/>
                <property name="enableSsl" value="${jmx.rmi.ssl}"/>
                <!-- Starts a registry if it doesnt exist -->
                <property name="startRegistry" value="true"/>
                <!-- Authentication -->
                <property name="remoteAccessProperties" value="${red5.config_root}/access.properties"/>
                <property name="remotePasswordProperties" value="${red5.config_root}/password.properties"/>
                <property name="remoteSSLKeystore" value="${red5.config_root}/red5JConsoleKeyStore"/>
                <property name="remoteSSLKeystorePass" value="${rtmps.keystorepass}"/>
                <!-- Mina offers its own Mbeans so you may integrate them here -->
                <property name="enableMinaMonitor" value="false"/>
        </bean>
```


Make note of the username and password in `/usr/share/red5/conf/password.properties`, you will need it when connecting using JConsole and VisualVM. If you want to change it from the default, you can go ahead.

```
red5user changeme
```

From your monitoring machine, startup JConsole passing in the location of the keystore and the password you entered when generating the keystore.
```
   D:\visualvm>jconsole -J-Djavax.net.ssl.keyStore="D:\visualvm\red5KeyStore" -J-Djavax.net.ssl.keyStorePassword=password -J-Djavax.net.ssl.trustStore="D:\visualvm\red5KeyStore"
```

You will be prompted to connect to the Red5 server. Use your server ip. Enter the username and password defined in `/usr/share/red5/conf/password.properties`
```
   service:jmx:rmi://192.168.0.166:9999/jndi/rmi://192.168.0.166:9999/red5
```

You should now be able to monitor Red5 using JConsole.

For JVisualVM, the steps are not different. From your monitoring machine, startup JConsole passing in the location of the keystore and the password you entered when generating the keystore.
```
D:\visualvm>visualvm -J-Djavax.net.ssl.keyStore="D:\visualvm\red5KeyStore" -J-Djavax.net.ssl.keyStorePassword=password -J-Djavax.net.ssl.trustStore="D:\visualvm\red5KeyStore"
```

You will be prompted to connect to the Red5 server. Use your server ip. Enter the username and password defined in `/usr/share/red5/conf/password.properties`
```
   service:jmx:rmi://192.168.0.166:9999/jndi/rmi://192.168.0.166:9999/red5
```

You should now be able to monitor Red5 using JVisualVM.

## References ##

[An idiot's guide to RMI/JMX remote connections - without SSL / authentication](http://www.red5tutorials.net/index.php/An_idiot's_guide_to_RMI/JMX_remote_connections_-_without_SSL_/_authentication)

[Monitor Your Applications With JConsole - Part 2](http://www.componative.com/content/controller/developer/insights/jconsole2/index.html)