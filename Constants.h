
//************
//整个软件的APPDelegate
//***********
#define APPDELEGETE (AppDelegate *)[[UIApplication sharedApplication]delegate]



//*************
//**百度的API
//*************
//请求百度音乐下载地址的API，好像不是百度官方的
#define BAIDUMUSIC_API(MUSICNAME) [[NSString stringWithFormat:@"http://box.zhangmen.baidu.com/x?op=12&count=1&title=%@$$$$$$",MUSICNAME] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]



//***************
//**土豆的API
//**************
//7850aa50a95ba67a
#define TUDOU_API [NSString stringWithFormat:@"%@",@"http://api.tudou.com/v3/gw?"]
#define TUDOU_APPKEY [NSString stringWithFormat:@"%@",@"myKey"]
#define TUDOU_APPSECRET bb6cc74198433885cad964c03538a0bb