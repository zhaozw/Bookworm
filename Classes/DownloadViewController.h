//
//  DownloadViewController.h
//  Hayate
//
//  Created by 韩 国翔 on 11-12-9.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadCell.h"
#import "FinishedCell.h"
#import "DownloadDelegate.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface DownloadViewController : UIViewController
<UITableViewDataSource,DownloadDelegate>{
    IBOutlet UITableView *downloadingTable;   
    IBOutlet  UITableView *finishedTable;
    NSMutableArray *downingList;
    NSMutableArray *finishedList;
}

@property(nonatomic,retain)IBOutlet UITableView *downloadingTable;
@property(nonatomic,retain)IBOutlet UITableView *finishedTable;
@property(nonatomic,retain)NSMutableArray *downingList;
@property(nonatomic,retain)NSMutableArray *finishedList;

-(void)showFinished;//查看已下载完成的文件视图
-(void)showDowning;//查看正在下载的文件视图
-(void)startFlipAnimation:(NSInteger)type;//播放旋转动画,0从右向左，1从左向右
-(void)updateCellOnMainThread:(FileModel *)fileInfo;//更新主界面的进度条和信息
@end
