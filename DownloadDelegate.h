//
//  DownloadDelegate.h
//  Hayate
//
//  Created by 韩 国翔 on 11-12-4.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@protocol DownloadDelegate <NSObject>

-(void)startDownload:(ASIHTTPRequest *)request;
-(void)updateCellProgress:(ASIHTTPRequest *)request;
-(void)finishedDownload:(ASIHTTPRequest *)request;

@end
