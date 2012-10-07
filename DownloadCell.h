//
//  DownloadCell.h
//  Hayate
//
//  Created by 韩 国翔 on 11-12-2.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileModel.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface DownloadCell : UITableViewCell {
    FileModel *fileInfo;
    IBOutlet UIProgressView *progress;
    IBOutlet UILabel *fileName;
    IBOutlet UILabel *fileCurrentSize;
    IBOutlet UILabel *fileSize;
    IBOutlet UIButton *operateButton;
}

@property(nonatomic,retain)FileModel *fileInfo;
@property(nonatomic,retain)IBOutlet UIProgressView *progress;
@property(nonatomic,retain)IBOutlet UILabel *fileName;
@property(nonatomic,retain)IBOutlet UILabel *fileCurrentSize;
@property(nonatomic,retain)IBOutlet UILabel *fileSize;
@property(nonatomic,retain)IBOutlet UIButton *operateButton;
@property(nonatomic,retain)ASIHTTPRequest *request;//该文件发起的请求

-(IBAction)operateTask:(id)sender;//操作（暂停、继续）正在下载的文件
@end
