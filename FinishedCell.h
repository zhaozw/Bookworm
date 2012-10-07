//
//  FinishedCell.h
//  Hayate
//
//  Created by 韩 国翔 on 11-12-7.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileModel.h"

@interface FinishedCell : UITableViewCell {
    IBOutlet UILabel *fileNameLabel;
    IBOutlet UILabel *fileSizeLabel;
    FileModel *fileInfo;
}
@property(nonatomic,retain)IBOutlet UILabel *fileNameLabel;
@property(nonatomic,retain)IBOutlet UILabel *fileSizeLabel;
@property(nonatomic,retain)IBOutlet FileModel *fileInfo;
@end
