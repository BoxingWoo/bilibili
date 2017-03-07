# bilibili
高仿山寨版bilibili
![logo](http://upload-images.jianshu.io/upload_images/2692232-e28e8fd94a496e5c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
[博客链接](http://www.jianshu.com/p/aed1a3fe5039)

###前言
本项目的所有数据均使用Charles抓包所得，使用MVVM+RAC模式进行编写。

![首页-推荐](http://upload-images.jianshu.io/upload_images/2692232-a77164d603bfc1d2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![首页-直播](http://upload-images.jianshu.io/upload_images/2692232-315749bfc4f66030.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![首页-番剧](http://upload-images.jianshu.io/upload_images/2692232-7e572ae41d718906.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![视频播放界面1](http://upload-images.jianshu.io/upload_images/2692232-a4605ee270e901eb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![视频播放界面2](http://upload-images.jianshu.io/upload_images/2692232-08ca6c3b9dc9b911.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![直播界面](http://upload-images.jianshu.io/upload_images/2692232-8e7791264d617661.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###项目描述

![架构图](http://upload-images.jianshu.io/upload_images/2692232-bb06d6624a0f7692.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

####Based
这里面包括了tabbarController、navigationController、webViewController、basedViewModel、viewModelRouter：
* navigationController，项目中只有一级界面显示tabbar，二级界面push的时候都会隐藏，需要自定制返回按钮，所以重写了push和pop方法。另外还新增了一个替换视图控制器的方法。
* webViewController，内部封装了webView的自定义网页视图控制器，重写了webView的几个代理方法，如果检测到网页上的视频会自动跳转到客户端自带的视频播放界面进行播放。
* basedViewModel，视图模型基类，所有的视图控制器都带有一个viewModel，视图间push或present的都是viewModel而不是viewController，所以这个类里面包含了一些用于控制跳转的属性和构造方法。另外还添加了一个UIViewController+DdViewModel的分类用于为视图控制器添加viewModel属性以及MVVM的核心Bind（绑定）方法。
* viewModelRouter，路由器，自定义本地路由表，从根视图控制器递归获取当前视图控制器并根据viewModel或者数据模型的URL进行界面跳转。

####Vendor
按功能创建的各种工具类：
* AppInfo 主要是应用的一些相关信息。
* DdFormatter 应用的文本格式化输出工具。
* DdHTTPSessionManager 网络请求类，基于AFHTTPSessionManager的二次封装，带有数据缓存功能，可以配置不同的数据缓存策略，还可以选择多种便于开发的数据打印模式。
* DdImageManager 图片处理工具，用于图片的调整、裁剪、合成和滤镜添加。
* YYFPSLabel、YPPlayerFPSLabel 帧速率监测工具。

###项目实现

####视频列表
![视频列表](http://upload-images.jianshu.io/upload_images/2692232-67474052dfbfce46.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
视频列表使用的是collectionView，viewController里只对collectionView进行了创建和配置，还有负责界面之间的跳转，collectionViewCell、sectionHeader、sectionFooter的配置和数据请求都交给了viewModel来实现。

![直播视频列表](http://upload-images.jianshu.io/upload_images/2692232-22427caba11a7f1b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
直播视频列表跟推荐视频列表的实现类似，因为本人不喜欢嵌套（譬如一个tableViewCell里嵌套一个collectionView），这里使用了自定义的流式布局来添加与tableView类似的HeaderView和FooterView。由于数据量比较小，布局的运算是一次完成的，并没有考虑性能问题（据说一般是使用二叉树算法）。

视频预览图的请求和处理使用的是YYKit里的类，相比于大家常用的SDWebImage，YYKit除了提供图片的请求方法之外还包含了很多图片的处理方法，真的非常人性化。此外，图片请求方法还多了一个transform的block用于在图片请求完成之后加载之前对图片进行异步处理并可以缓存到硬盘，有着非常优秀的性能体验。
![原图](http://upload-images.jianshu.io/upload_images/2692232-9870579c82061b60.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![效果图](http://upload-images.jianshu.io/upload_images/2692232-e4bf4ff22a3a6c2c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

####视频播放
![视频播放](http://upload-images.jianshu.io/upload_images/2692232-7fd8efb3ad54ad7f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
视频播放器使用的是bilibili的开源框架IJKMediaFramework，而媒体控制器是防bilibili自定制UI和功能实现，分为竖屏方向的DdPortraitMediaControl，横屏方向的DdLandscapeMediaControl，虽然两者在功能上有部分重叠，但是为了方便实现而分成了两个控件。有一点是不可否认的，复制黏贴要比抽象封装来得快也舒服。两个控件的实现并不复杂，但是要同时集成播放设置、弹幕设置、弹幕发送、播放控制、媒体控制器自动隐藏、进度监控等诸多功能，代码量可谓惊为天人。此外还自定制了快进快退指示器和缓冲指示器等一些小控件。
![媒体控制器](http://upload-images.jianshu.io/upload_images/2692232-bf128e049cf279e1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
弹幕的渲染和发送使用了一个第三方框架BarrageRenderer，使用简单并拥有以下特性：1、提供过场弹幕(4种方向)与悬浮弹幕(2种方向)支持; 支持图片弹幕与文字弹幕.2、弹幕字体可定义: 颜色,边框,圆角,背景,字体等皆可定制.3、自动轨道搜寻算法,新发弹幕会根据相同方向的同种弹幕获取最佳运动轨道.4、支持延时弹幕,为反复播放弹幕提供可能；支持与外界的时间同步.5、独立的动画时间系统, 可以统一调整动画速度.6、特制的动画引擎,播放弹幕更流畅,可承接持续的10条/s的弹幕流速.7、丰富的扩展接口, 实现了父类的接口就可以自定义弹幕动画.8、可以为任意UIView绑定弹幕,当然弹幕内容需要创建控件输入。

####直播
关于直播这一块并不打算多做介绍，网上有很多关于直播实现的教程，具体实现可以参照这篇博客http://www.jianshu.com/p/bd42bacbe4cc。项目中使用的是来疯直播的框架LFLiveKit。

###结束语
以上是对这个项目的几个重点模块的解说还有一些技术要点实现的阐述，整个项目还有很多细节没有提及，大家可以去看我的代码，里面有比较详细的注释。最后，欢迎大家对我的项目进行批评指正！（PS:本项目是基于bilibili客户端4.0版本实现的，目前已经更新到了5.0版本，界面布局和功能实现有着相当的差异）
