1、运行gcad.exe
2、点工具调最左面的按钮打开一个新窗口
3、把下面的内容复制到程序最下面的编辑框回车，可以看到整个场景
loadapx 1.apx 2.apx 3.apx 4.apx 5.apx 6.apx 7.apx 8.apx 9.apx 10.apx 11.apx 12.apx 13.apx 14.apx 15.apx 16.apx 17.apx 18.apx 19.apx 20.apx 21.apx 22.apx 23.apx 24.apx 25.apx 26.apx 27.apx
4、把下面的内容复制过去，可以看到线框图
set lineframe=1
5、把下面的内容复制过去，可以看到渲染图
set lineframe=0
6、按住鼠标中键，可以左右上下移动场景，鼠标滚轮可以放大缩小场景，
7、按住ctrl键，同时按上下左右剪头键可以旋转场景，pageup 和pagedown也是旋转场景，3个方向
8、把下面的内容复制到程序最下面的编辑框回车，卸载加载的场景
unloadapx
9、把下面的内容复制到程序最下面的编辑框回车，加载房子整体框架和地面
loadapx 1.apx 2.apx 3.apx 4.apx 5.apx 22.apx 24.apx 25.apx 26.apx
10、把下面的内容复制到程序最下面的编辑框回车，加载所有的桌椅沙发
loadapx 6.apx 7.apx 8.apx 9.apx 10.apx 11.apx 12.apx 13.apx
11、把下面的内容复制到程序最下面的编辑框回车，加载所有的灯具
loadapx 14.apx 15.apx 16.apx 17.apx
12、把下面的内容复制到程序最下面的编辑框回车，加载所有的风景画
loadapx 18.apx 19.apx 20.apx 21.apx 23.apx
13、把下面的内容复制到程序最下面的编辑框回车，加载房间里面的电脑键盘
loadapx 27.apx 


除了1、2两步是必须先做的；
其他步骤无先后顺序，可以随机使用查看效果；这些需要拷贝的命令也可以这么做：
清空最底下的编辑框，在里面按tab键，能顺序出现所有的命令按回车即可