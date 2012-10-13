//
//  AppDelegate.h
//  @rigoneri
//  
//  Copyright 2010 Rodrigo Neri
//  Copyright 2011 David Jarrett
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "CommonHelper.h"
#import "DownloadDelegate.h"
#import "FileModel.h"
#import "DownloadCell.h"
#import <AVFoundation/AVAudioPlayer.h>

#define kFileDownloadSuccess @"kFileDownloadSuccess"
@class MyLauncherViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate,ASIHTTPRequestDelegate,ASIProgressDelegate> {
    UIWindow *window;
	UINavigationController *navigationController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;

@property(nonatomic,retain)NSMutableArray *finishedlist;//已下载完成的文件列表（文件对象）

@property(nonatomic,retain)NSMutableArray *downinglist;//正在下载的文件列表(ASIHttpRequest对象)

@property(nonatomic,retain)id<DownloadDelegate> downloadDelegate;

@property(nonatomic,retain)AVAudioPlayer *buttonSound;//按钮声音

@property(nonatomic,retain)AVAudioPlayer *downloadCompleteSound;//下载完成的声音

@property(nonatomic)BOOL isFistLoadSound;//是否第一次加载声音，静音


-(void)loadTempfiles;//将本地的未下载完成的临时文件加载到正在下载列表里,但是不接着开始下载
-(void)loadFinishedfiles;//将本地已经下载完成的文件加载到已下载列表里
-(void)playButtonSound;//播放按钮按下时的声音
-(void)playDownloadFinishSound;//播放下载完成时的声音

//1.点击百度或者土豆的下载，进行一次新的队列请求
//2.是否接着开始下载
-(void)beginRequest:(FileModel *)fileInfo isBeginDown:(BOOL)isBeginDown;
@end

