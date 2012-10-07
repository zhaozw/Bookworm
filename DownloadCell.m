//
//  DownloadCell.m
//  Hayate
//
//  Created by 韩 国翔 on 11-12-2.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "DownloadCell.h"


@implementation DownloadCell
@synthesize fileInfo;
@synthesize progress;
@synthesize fileName;
@synthesize fileCurrentSize;
@synthesize fileSize;
@synthesize operateButton;
@synthesize request;

- (void)dealloc
{
    [request release];
    [operateButton release];
    [fileName release];
    [fileCurrentSize release];
    [fileSize release];
    [progress release];
    [fileInfo release];
    [super dealloc];
}

-(IBAction)operateTask:(id)sender
{
    AppDelegate *appDelegate=APPDELEGETE;
    UIButton *btnOperate=(UIButton *)sender;
    FileModel *downFile=((DownloadCell *)[[[btnOperate superview] superview]superview]).fileInfo;
    if(downFile.isDownloading)//文件正在下载，点击之后暂停下载
    {
        [operateButton setBackgroundImage:[UIImage imageNamed:@"downloading_stop.png"] forState:UIControlStateNormal];
        downFile.isDownloading=NO;
        [request cancel];
        [request release];
        request=nil;
    }
    else
    {
        [operateButton setBackgroundImage:[UIImage imageNamed:@"downloading_go.png"] forState:UIControlStateNormal];
        downFile.isDownloading=YES;
        [appDelegate beginRequest:downFile isBeginDown:YES];
    }
    //暂停意味着这个Cell里的ASIHttprequest已被释放，要及时更新table的数据，使最新的ASIHttpreqst控制Cell
    UITableView *tableView=(UITableView *)[[[[btnOperate superview] superview] superview] superview];
    [tableView reloadData];
}
@end
