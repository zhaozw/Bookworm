//
//  MusicCell.h
//  Hayate
//
//  Created by 韩 国翔 on 11-12-2.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileModel.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "ASIHTTPRequest.h"
#import "CommonHelper.h"

@interface MusicCell : UITableViewCell <UIAlertViewDelegate,UIAlertViewDelegate>{
    IBOutlet UILabel *musicName;
    IBOutlet UILabel *musicSize;
    IBOutlet UIButton *musicDown;
    FileModel *fileInfo;
}

@property(nonatomic,retain)IBOutlet UILabel *musicName;
@property(nonatomic,retain)IBOutlet UILabel *musicSize;
@property(nonatomic,retain)IBOutlet UIButton *musicDown;
@property(nonatomic,retain)FileModel *fileInfo;

-(IBAction)downMusic:(id)sender;//点击下载开始下载
@end
