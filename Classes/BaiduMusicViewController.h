//
//  BaiduMusicViewController.h
//  Hayate
//
//  Created by 韩 国翔 on 11-12-2.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicCell.h"
#import "ASIHTTPRequest.h"
#import "BaiduMusicHelper.h"
#import "CommonHelper.h"

@interface BaiduMusicViewController : UIViewController 
<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,ASIHTTPRequestDelegate>{
    IBOutlet UISearchBar *musicSearcher;
    IBOutlet UITableView *musicTable;
    int count;//等待时间不超过10s
    BOOL isLoading;//是否正在加载，默认没有
    IBOutlet UIView *inputOverLayer;//输入文本时的覆盖图
    IBOutlet UIView *loadingOverLayer;//搜索歌曲时的覆盖图
    NSMutableArray *musicList;//用来存档音乐的列表
    NSMutableArray *connList;//得到音乐下载连接后，进行二次请求获取文件大小的请求
    BOOL isFinished;//是否二次加载文件大小和名字完成
    ASIHTTPRequest *theRequest;
    NSString *rootElement;  
    NSString *currentElement;
    NSString *currentUrl;//当前进行拼凑的下载地址
    FileModel *currentFile;//当前进行实例化的音乐对象
}

@property(nonatomic,retain)IBOutlet UISearchBar *musicSearcher;
@property(nonatomic,retain)IBOutlet UITableView *musicTable;
@property(nonatomic) BOOL isLoading;
@property(nonatomic,retain)IBOutlet UIView *inputOverLayer;
@property(nonatomic,retain)IBOutlet UIView *loadingOverLayer;
@property(nonatomic,retain)NSMutableArray *musicList;
@property(nonatomic,retain)NSMutableArray *connList;
@property(nonatomic)BOOL isFinished;
@property(nonatomic,retain)ASIHTTPRequest *theRequest;
@property(nonatomic,retain)NSString *rootElement;
@property(nonatomic,retain)NSString *currentElement;
@property(nonatomic,retain)NSString *currentUrl;
@property(nonatomic,retain)FileModel *currentFile;

-(void)hideInput;//隐藏输入键盘
-(void)hideSearchBar;//隐藏搜索条和取消按钮
-(void)showSearchBar;//显示搜索条和取消按钮
-(void)checkFinished:(NSTimer *)timer;//检查是否结束搜索
-(void)startWaitting;//开始等待动画
-(void)stopWaitting;//停止等待动画
-(void)dismissLoadingOverLayer;//消除等待动画的覆盖图
-(IBAction)cancelLoading:(id)sender;//用户取消等待加载数据
-(void)searchMusicByMusicName:(NSString *)musicName;//根据歌曲名发起请求
@end
