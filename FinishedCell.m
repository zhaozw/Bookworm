//
//  FinishedCell.m
//  Hayate
//
//  Created by 韩 国翔 on 11-12-7.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "FinishedCell.h"


@implementation FinishedCell

@synthesize fileInfo;
@synthesize fileNameLabel;
@synthesize fileSizeLabel;

- (void)dealloc
{
    [fileInfo release];
    [fileSizeLabel release];
    [fileNameLabel release];
    [super dealloc];
}

@end
