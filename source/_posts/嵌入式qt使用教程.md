---
title: 嵌入式qt使用教程
comments: true
cover: /gallery/defaultCover5.png
thumbnail: /gallery/defaultThumbnail5.png
tags:
  - qt
  - 嵌入式
categories:
  - 教程
toc: true
excerpt: 详情请点击read more
date: 2026-03-25 14:44:28
description:
---
# 安装
1. 在linux端配置好代理后，执行`wget https://download.qt.io/archive/qt/5.12/5.12.9/qt-opensource-linux-x64-5.12.9.run`
2. 大文件下载可能会网络波动导致失败，重新下载指令如下
```
(1)不关代理。wget -c --no-check-certificate https://download.qt.io/archive/qt/5.12/5.12.9/qt-opensource-linux-x64-5.12.9.run
(2)关代理。unset https_proxy
unset http_proxy
# 然后再尝试断点续传
wget -c https://download.qt.io/archive/qt/5.12/5.12.9/qt-opensource-linux-x64-5.12.9.run
```
3. 趁现在去注册qt账号，有账号的回想一下，qt官网为：<https://www.qt.io>
4. 执行命令开始安装，
  ```
  chmod +x qt-opensource-linux-x64-5.12.9.run
  sudo ./qt-opensource-linux-x64-5.12.9.run
  ```
5. 配置如下，![alt text](嵌入式qt使用教程/image.png)
## wsl问题
如果你是win10，默认没有图形化界面的。
1. 下载VcXsrv <https://sourceforge.net/projects/vcxsrv/files/latest/download。>
2. 在桌面找到安装好的图标后启动，选择 Multiple windows，Display number 输入 0。然后选择 Start no client。勾选勾选 "Disable access control"即可。
3. 推荐安装依赖以及环境变量
```
sudo apt update && sudo apt install -y libxcb-xinerama0
下面两句是写入bashrc的
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
alias qtcreator='/opt/Qt5.12.9/Tools/QtCreator/bin/qtcreator &'

source ~/.bashrc
```
4. 执行qtcreator即可调出窗口。
## 中文
在tool opions Environment interface，这里路径下设置。  
至于输入中文，我懒得折腾了，在windows下复制过去吧。

# 创建工程
> 参考文档为正点原子的qt教程，下载路径为imx6ull下的参考资料。 
>
## 相关名词解析
1. qmake：生成makefile编译的项目
2. 基类选择自行去了解，新手默认即可，嵌入式开发一般用没有状态栏的Qwidget
3. translation file可读的翻译软件极少用到点击下一步即可。
4. 工程目录中头文件和源文件就不多介绍了，form文件夹指的是ui资源，采用xml语言到时候编译的时候会生成对应的代码，不能手动编辑双击跳转到图形化界面编辑。pro后缀的文件是项目管理文件后续有大用。
5. ui设计页面左边是控件选择，中间是效果，右边是类和类的属性显示
## hello world
1. 双击ui软件，找到label控件，拖动，输入文字即可。教程似乎没讲但是ctrl+s似乎有用。
2. 回到编辑页面点击左下角绿色开始按键，开始编译，底部编译输出按键可以看结果。
3. 参考文档说会遇到sudo apt-get install libglu1-mesa-dev问题但是我一次成功了，遇到的是warning: implicitly-declared ‘QVariant::Private&...，这个是警告，意思是qt版本有点老了，可以忽略，有一说一警告标红色干嘛。。。
## 信号与槽
### 简述
1. 信号连接到槽上，当对象发出信号则对应连接的槽就被触发执行。  
2. 要设置这个需要进入signal/slots模式，在ui设计页面的中间上方按键，如果要退出点击左边按键edit widgets即可。
3. 进入信号槽编辑模式后，点击拖到控件，会弹出页面，右边是对象的槽函数，在初始main函数中只有QMainWindow的槽函数，左边是该控件的信号，选择匹配即可，比如按键的click()信号匹配close槽。这里的信号和槽他们都是基础父类得来的因此需要在匹配页面把显示基础打开。
4. 编写槽函数，在编辑页面左键转到槽，跳到对应的槽函数，比如close功能就需要this->close();
### 详述
1. 槽函数是自动执行的，目标函数去执行槽，所以之前体验的教程中是编辑mainwindow的函数，信号与槽的绑定函数为：`QObject::connect(sender, SIGNAL(signal()), receiver, SLOT(slot()));`  ,传入参数为：信号发射的对象，信号，接收信号的对象，槽
2. 连接多个槽的执行顺序按连接时的顺序来
3. 信号可以连接信号,`connect(pushButton, SIGNAL(objectNameChanged(QString)),this, SIGNAL(windowTitelChan
ged(QString)));`
4. **在使用信号与槽的类中，必须在类的定义中加入宏 Q_OBJECT**
5. 发射信号如同调用代码，有阻塞效果，执行完毕才到后面的语句。
6. 有断开信号和槽连接的方法，disconnect，一般不咋用吧
#### 取消ui编辑界面的代码编写
1. 创建项目时不生产ui文件即可。
2. 信号无需定义，只需要声明，为了在QMainWindow类添加信号，打开MainWindow的头文件。之前说的那个宏已经默认生成了，没有的自己添加。  因为信号只是起到触发作用真正起作用的函数是槽函数
3. 在类中写入
```
signals:
/* 声明一个信号，只需声明，无需定义
void pushButtonTextChanged();
``` 
这个signals写法是和public同级的，这是引入了moc的工具，他最终是把这个处理成public，这个工具的其他作用还有处理那个 Q_OBJECT宏。
4. 显示mainwindow中会有很多其他的类对象，而信号的声明正式声明这些类对象的函数。因此还需要引入相应对象的头文件。
```
/* 引入 QPushButton */
#include <QPushButton>
```
5. 信号函数和槽函数的参数和返回值要一样，从抽象概念理解上信号发射和接收方当然要一样，  
从代码理解来讲，实际上连接就是把信号发来的参数当参数传给了槽函数，如果不一样会报错。
6. 定义槽函数需要先创建好绑定对象，然后再在目标执行槽函数的主体上创建槽函数。代码为：
```
public slots:
/* 声明一个槽函数 */
void changeButtonText();
/* 声明按钮点击的槽函数 */
void pushButtonClicked();
private:
/* 声明一个对象 pushButton */
QPushButton *pushButton;
```
定义了公有属性的槽函数。
7. 这样可以发现在同一份头文件里又有信号又有槽，笔者在这里有些迷糊了，实际上最开始声明的那个信号是mainwindow的信号，如果只是把槽和类绑定的话不需要声明信号。
8. 个人c++语法拾遗，实例化对象一定是在cpp文件里实例化的，在头文件里只是声明。
9. 接下来实例化对象和实现具体的槽函数即可。打开cpp文件。
```
#include "mainwindow.h
MainWindow::MainWindow(QWidget *parent)
: QMainWindow(parent)
{
/* 设置窗体的宽为 800,高为 480 */
this->resize(800,480);
/* 实例化 pushButton 对象 */
pushButton = new QPushButton(this);
/* 调用 setText()方法设定按钮的文本 */
pushButton->setText("我是一个按钮");
}
MainWindow::~MainWindow()
{
}
/* 实现按钮点击槽函数 */
void MainWindow::pushButtonClicked()
{
/* 使用 emit 发送信号 */
emit pushButtonTextChanged();
}
/* 实现按钮文本改变的槽函数 */
void MainWindow::changeButtonText()
{
/* 在槽函数里改变按钮的文本 */
pushButton->setText("被点击了！ ");
}
```
10.  使用emit 信号函数，主动发送信号，由于目标是操作mainwindow下的对象因此使用槽函数去触发修改按键对象。
11.  连接信号和槽:写在类的构造函数
```
connect(pushButton, SIGNAL(clicked()), this,
SLOT(pushButtonClicked()));
connect(this, SIGNAL(pushButtonTextChanged()), this,
SLOT(changeButtonText()));
```
#### 控件积累
详细参考我之前提到的正点原子文档，这里只做特殊控件的介绍。
1. 按钮类，要注意radiobutton，他提供带文档的互斥按钮，通过check指示。这里开始涉及到**qss样式表文件**了，使用qss把文本样式变成image。
```
    QFile file(":/style.qss");
    /* 判断文件是否存在 */
    if (file.exists()){
    /* 以只读的方式打开 */
    file.open(QFile::ReadOnly);
    /* 以字符串的方式保存读出的结果 */
    QString styleSheet = QLatin1String(file.readAll());
    /* 设置全局样式 */
    qApp->setStyleSheet(styleSheet);
        file.close();
    }
```
2. qDebug()，qt自定义的调试语句
3. 基于模型的控件，需要建模，减少了冗余数据。
QListView就是一个是基于模型的类，被QListWidget继承，而QListWidget，是基于项目的类，实际上就是模型基类加一个封装好的项目：QListWidgetItem。操作基于项目的控件可以直接调用addItem添加项目，实现集成化功能。  
单独使用基于模型的类时要自己创建模型，Qt 提供了一些类型的 Model，其中最常用的就是这个
QStandardItemModel 类，一般可以满足大部分需求。
#### 文件读写
1. 打开系统文件资源管理获取文件路径
```
QString fileName = QFileDialog::getOpenFileName(this, 
                                                tr("Open File"), 
                                                "/home", 
                                                tr("Images (*.png *.jpg)"));
```
2. QFile传入路径，操作文件。可以选择只读打开，判断文件是否存在等等。
3. QString字符串对象，用于接收路径，传入路径给Qfile
4. textEdit->setPlainText(file.readAll());，显示框，显示文本。
5. file.write(strBytes, strBytes.length());不能写入字符串只能写入字节数据，因此需要QByteArray strBytes = str.toUtf8();，转换一下。
6. QTextStream，文本流，stream<<str;，QTextStream stream(&file);更好的操作Qfile
#### 绘图与图表
1. QPaintengine和QPaintdevice，提供基础，QPainter直接实现绘图
2. 绘图事件，paintEvent()，在初始化和手动调用刷新页面update()时使用。是虚函数被多个类继承，用到的时候需要重写。
```
/* 重写父类下的 protected 方法*/
protected:
void paintEvent(QPaintEvent *);
```
3. 图表：需要在pro文件中加入编译条件：QT += charts。在编译器跳转至定义的话则需要在头文件加入using namespace QtCharts;
#### 多线程
1. QThread 对象在程
序中管理一个控制线程。 QThreads 在 run()中开始执行。默认情况下， run()通过调用 exec()来启动事件循环，并在线程中运行 Qt 事件循环。您可以通过使用 QObject::moveToThread()将 worker对象移动到线程来使用它们。
2. Qt 有两种多线程的方法，其中一种是继承 QThread
的 run()函数，另外一种是把一个继承于 QObject 的类转移到一个 Thread 里。
3. 继承 QThread 是创建线程的一个普通方法。 其中创建的线程
只有 run()方法在线程里的。其他类内定义的方法都在主线程内。
4. 具体为定义创建workthread对象重定义run函数或者创建一个类继承QObject类然后moveToThread传入workerthread类。
#### 网络编程
1. pro加入QT += network
2. 相关的类太多了，这里简要提一下，通过 QHostInfo 和 QNetworkInterface 类获取本地网络所有接口的信息。
3. TCP：在 Qt 中，Qt 把 socket 当成输入输出流来对待的，数据的收发是通过 read()和 write()来进行的，需要与我们常见的 send()与 recv()进行区分。
4. 客户端是：QTcpSocket，服务端是，QTcpSocket和QTcpServer。
```
核心：
    /* 通信套接字 */
    QTcpSocket *tcpSocket;
        /* tcp 服务器 */
    QTcpServer *tcpServer;
辅助：
    /* 存储本地的 ip 列表地址 */
    QList<QHostAddress> IPlist;
api：
/* 获取客户端的套接字 */
tcpSocket = tcpServer->nextPendingConnection();
/* 客户端的 ip 信息 */
QString ip = tcpSocket->peerAddress().toString();
/* 客户端的端口信息 */
quint16 port = tcpSocket->peerPort();


其实就是调用一堆函数read，看state，具体的通信协议被屏蔽了
```
5. 在server端，监听一个端口：地址和端口号。连接newConnection信号。如果client端调用connectToHost连接服务器的地址和端口时，将会触发server端的这个信号。跳转到槽函数nextPendingConnection()获取QTcpSocket*。这是个对象提供read等函数给你操作实际上的套接字。



1. UDP，是不可靠通信，因此他有单播，广播：使用广播地址，把信息发送给这个地址网段里的所有主机，当然了还是得指定端口号，不然到了对应主机还是不知道给谁。；多/组播：不在组里的不发。
2. 因为广播是只有同一网段都会发，这种无差别的信息路由器不可能转发的，因此广播用于局域网通信，单播和组播都能互联网通信。
3. 单播与广播：本例大体流程首先获取本地 IP 地址。创建一个 udpSocket 套接字， 然后开启广播功能setSocketOption函数。然后就可以直接向目标端口和ip发送了，qint64 bytesSent = udpSocket->writeDatagram(data, broadcastAddr, port);。想要读取数据的话首先与套接字的信号绑定好自己的槽函数。以及绑定好监听端口。
```
udpReceiver->bind(port, QUdpSocket::ShareAddress)
        udpReceiver->readDatagram(buffer.data(), buffer.size(), &senderAddr, &senderPort);
        qDebug() << "Received broadcast from" << senderAddr << ":" << senderPort
                 << "Data:" << buffer;
```
4. 组播，需要加入组播的组， D 类 IP 地址不分网络地址和主机地址，是一个专门保留的地址，其地址范围为 224.0.0.0～239.255.255.255。 D 类 IP 地址主要用于多点广播（Multicast，也称为多播（组播））之中作为多播组 IP 地址。QUdpSocket 类支持 UDP 组播，提供了 joinMulticastGroup 方法使本地主机加入多播组，leaveMulticastGroup 离开多播组。
5. 组播接收端同样是bind一下，这个不能缺失因为他发到组里后还要知道具体发给那个端口，这里绑定的ip是本地ip和端口。然后加入组播组里，udpSocket->joinMulticastGroup(groupAddress)。然后发送端老样子发送，但是他是用的组播地址。

1. 这里讲一下，TCP的监听地址和UDP的绑定地址。同一都是电脑的，采用回环地址的话只能接收到本地的信息，采用局域网的就能接收到局域网信息等等。

#### 多媒体
添加pro，QT += multimedia。 Qt 中的音乐播放器与视频播放器需要在 Ubuntu 里安装媒体解码器才能实现播放，
```
sudo apt-get install gstreamer1.0-plugins-base gstreamer1.0-plugins-bad gstreamer1.0-plugins-good
gstreamer1.0-plugins-ugly gstreamer1.0-pulseaudio gstreamer1.0-libav
```
#### 数据库
QT += core gui sql。加入这个。一般常用的数据库就是 Sqlite3。 SQLite 是非常小的，是轻量级的。
 在 QSqlDatabase 连接
数据库后，用 QSqlTableModel 从数据库里读取出表格模型，然后通过 Qt 的 QTableView 类显示数据库的内容在我们面前。需要对数据库的数据进行修改可以使用 QSqlQuery，或者直接修改QSqlTableModel 对象，修改里面的模型数据即可

#### 嵌入式开发QT
主要是提前把驱动文件写好注册进去到时候不要Qfile操作，直接Linux应用开发时的操作，或者官方提供好类直接操作，比如串口操作。
1. pri 文件， include(headview/headview.pri)，正常来讲你定义了新的cpp和头文件时需要添加到pro文件使得编译生效，如果是使用频率很高的，则采用这种pri模式，这里面写的是qmake脚本，在这里面同一包含文件，减少重复操作。