//
//  AppDelegate.m
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

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window, navigationController;

@synthesize downinglist=_downinglist;

@synthesize downloadDelegate=_downloadDelegate;

@synthesize finishedlist=_finishedList;

@synthesize buttonSound=_buttonSound;

@synthesize downloadCompleteSound=_downloadCompleteSound;

@synthesize isFistLoadSound=_isFirstLoadSound;

-(void)playButtonSound
{
#if !(TARGET_IPHONE_SIMULATOR)
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *result=[userDefaults objectForKey:@"isOpenAudio"];
    NSURL *url=[[[NSBundle mainBundle]resourceURL] URLByAppendingPathComponent:@"btnEffect.wav"];
    NSError *error;
    if(self.buttonSound==nil)
    {
        self.buttonSound=[[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error] autorelease];
        if(!error)
        {
            NSLog(@"%@",[error description]);
        }
    }
    if([result isEqualToString:@"YES"]||result==nil)//播放声音
    {
        if(!self.isFistLoadSound)
        {
            self.buttonSound.volume=1.0f;
        }
    }
    else
    {
        self.buttonSound.volume=0.0f;
    }
    [self.buttonSound play];
#endif
}

-(void)playDownloadFinishSound
{
#if !(TARGET_IPHONE_SIMULATOR)
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *result=[userDefaults objectForKey:@"isOpenAudio"];
    NSURL *url=[[[NSBundle mainBundle]resourceURL] URLByAppendingPathComponent:@"download-complete.wav"];
    NSError *error;
    if(self.downloadCompleteSound==nil)
    {
        self.downloadCompleteSound=[[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error] autorelease];
        if(!error)
        {
            NSLog(@"%@",[error description]);
        }
    }
    if([result isEqualToString:@"YES"]||result==nil)//播放声音
    {
        if(!self.isFistLoadSound)
        {
            self.downloadCompleteSound.volume=1.0f;
        }
    }
    else
    {
        self.downloadCompleteSound.volume=0.0f;
    }
    [self.downloadCompleteSound play];
#endif
}

-(void)beginRequest:(FileModel *)fileInfo isBeginDown:(BOOL)isBeginDown
{
    //如果不存在则创建临时存储目录
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    if(![fileManager fileExistsAtPath:[CommonHelper getTempFolderPath]])
    {
        [fileManager createDirectoryAtPath:[CommonHelper getTempFolderPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //文件开始下载时，把文件名、文件总大小、文件URL写入文件，上海滩.rtf中间用逗号隔开
    NSString *writeMsg=[fileInfo.fileName stringByAppendingFormat:@",%@,%@",fileInfo.fileSize,fileInfo.fileURL];
    NSInteger index=[fileInfo.fileName rangeOfString:@"."].location;
    NSString *name=[fileInfo.fileName substringToIndex:index];
    [writeMsg writeToFile:[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.rtf",name]] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    
    //按照获取的文件名获取临时文件的大小，即已下载的大小
    fileInfo.isFistReceived=YES;
    NSData *fileData=[fileManager contentsAtPath:[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileInfo.fileName]]];
    NSInteger receivedDataLength=[fileData length];
    fileInfo.fileReceivedSize=[NSString stringWithFormat:@"%d",receivedDataLength];
    
    //如果文件重复下载或暂停、继续，则把队列中的请求删除，重新添加
    for(ASIHTTPRequest *tempRequest in self.downinglist)
    {
        if([[NSString stringWithFormat:@"%@",tempRequest.url] isEqual:fileInfo.fileURL])
        {
            [self.downinglist removeObject:tempRequest];
            break;
        }
    }
    
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fileInfo.fileURL]];
    request.delegate=self;
    [request setDownloadDestinationPath:[[CommonHelper getTargetFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileInfo.fileName]]];
    [request setTemporaryFileDownloadPath:[[CommonHelper getTempFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileInfo.fileName]]];
    [request setDownloadProgressDelegate:self];
    //    [request setDownloadProgressDelegate:downCell.progress];//设置进度条的代理,这里由于下载是在AppDelegate里进行的全局下载，所以没有使用自带的进度条委托，这里自己设置了一个委托，用于更新UI
    [request setAllowResumeForFileDownloads:YES];//支持断点续传
    if(isBeginDown)
    {
        fileInfo.isDownloading=YES;
    }
    else
    {
        fileInfo.isDownloading=NO;
    }
    [request setUserInfo:[NSDictionary dictionaryWithObject:fileInfo forKey:@"File"]];//设置上下文的文件基本信息
    [request setTimeOutSeconds:30.0f];
    if (isBeginDown) {
        [request startAsynchronous];
    }
    [self.downinglist addObject:request];
}

-(void)cancelRequest:(ASIHTTPRequest *)request
{
    
}

-(void)loadTempfiles
{
    self.downinglist=[[[NSMutableArray alloc] init] autorelease];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    NSArray *filelist=[fileManager contentsOfDirectoryAtPath:[CommonHelper getTempFolderPath] error:&error];
    if(!error)
    {
        NSLog(@"%@",[error description]);
    }
    for(NSString *file in filelist)
    {
        if([file rangeOfString:@".rtf"].location<=100)//以.rtf结尾的文件是下载文件的配置文件，存在文件名称，文件总大小，文件下载URL
        {
            NSInteger index=[file rangeOfString:@"."].location;
            NSString *trueName=[file substringToIndex:index];
            
            //临时文件的配置文件的内容
            NSString *msg=[[NSString alloc] initWithData:[NSData dataWithContentsOfFile:[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.rtf",trueName]]] encoding:NSUTF8StringEncoding];
            
            //取得第一个逗号前的文件名
            index=[msg rangeOfString:@","].location;
            NSString *name=[msg substringToIndex:index];
            msg=[msg substringFromIndex:index+1];
            
            //取得第一个逗号和第二个逗间的文件总大小
            index=[msg rangeOfString:@","].location;
            NSString *totalSize=[msg substringToIndex:index];
            msg=[msg substringFromIndex:index+1];
            
            //取得第二个逗号后的所有内容，即文件下载的URL
            NSString *url=msg;
            
            //按照获取的文件名获取临时文件的大小，即已下载的大小
            NSData *fileData=[fileManager contentsAtPath:[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",name]]];
            NSInteger receivedDataLength=[fileData length];
            
            //实例化新的文件对象，添加到下载的全局列表，但不开始下载
            FileModel *tempFile=[[FileModel alloc] init];
            tempFile.fileName=name;
            tempFile.fileSize=totalSize;
            tempFile.fileReceivedSize=[NSString stringWithFormat:@"%d",receivedDataLength];
            tempFile.fileURL=url;
            tempFile.isDownloading=NO;
            [self beginRequest:tempFile isBeginDown:NO];
            [msg release];
            [tempFile release];
        }
    }
}

-(void)loadFinishedfiles
{
    self.finishedlist=[[[NSMutableArray alloc] init] autorelease];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    NSArray *filelist=[fileManager contentsOfDirectoryAtPath:[CommonHelper getTargetFolderPath] error:&error];
    if(!error)
    {
        NSLog(@"%@",[error description]);
    }
    for(NSString *fileName in filelist)
    {
        if([fileName rangeOfString:@"."].location<100)//出去Temp文件夹
        {
            FileModel *finishedFile=[[FileModel alloc] init];
            finishedFile.fileName=fileName;
            
            //根据文件名获取文件的大小
            NSInteger length=[[fileManager contentsAtPath:[[CommonHelper getTargetFolderPath] stringByAppendingPathComponent:fileName]] length];
            finishedFile.fileSize=[CommonHelper getFileSizeString:[NSString stringWithFormat:@"%d",length]];
            
            [self.finishedlist addObject:finishedFile];
            [finishedFile release];
        }
    }
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.isFistLoadSound=YES;
#if !(TARGET_IPHONE_SIMULATOR)
    [self playButtonSound];
    [self playDownloadFinishSound];
#endif
    self.isFistLoadSound=NO;
    [self loadFinishedfiles];
    [self loadTempfiles];
    
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (!window)
    {
        return FALSE;
    }
    window.backgroundColor = [UIColor blackColor];
    
	navigationController = [[UINavigationController alloc] initWithRootViewController:
							[[RootViewController alloc] init]];
	navigationController.navigationBar.tintColor = COLOR(2, 100, 162);
	
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
    [window layoutSubviews];
    return YES;
}
/*
 - (void)applicationDidFinishLaunching:(UIApplication*)application
{
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (!window) 
    {
        return;
    }
    window.backgroundColor = [UIColor blackColor];
							
	navigationController = [[UINavigationController alloc] initWithRootViewController:
							[[RootViewController alloc] init]];
	navigationController.navigationBar.tintColor = COLOR(2, 100, 162);
	
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
    [window layoutSubviews];    
}*/

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_downloadCompleteSound release];
    [_buttonSound release];
    [_finishedList release];
    [_downloadDelegate release];
    [_downinglist release];
    [window release];
    [navigationController release];
    [super dealloc];
}

#pragma mark ASIHttpRequestDelegate

//出错了，如果是等待超时，则继续下载
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error=[request error];
    NSLog(@"ASIHttpRequest出错了!%@",error);
    [request release];
}

-(void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"开始了!");
}

-(void)requestReceivedResponseHeaders:(ASIHTTPRequest *)request
{
    NSLog(@"收到回复了！");
    FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
    fileInfo.fileSize=[CommonHelper getFileSizeString:[[request responseHeaders] objectForKey:@"Content-Length"]];
}

////*********
//**注意：如果要要ASIHttpRequest自动断点续传，则不需要写上该方法，整个过程ASIHttpRequest会自动识别URL进行保存数据的
//如果设置了该方法，ASIHttpRequest则不会响应断点续传功能，需要自己手动写入接收到的数据，开始不明白原理，搞了很久才明白，如果本人理解不正确的话，请高人及时指点啊^_^QQ:1023217825
//***********
//-(void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
//{
//    FileModel *fileInfo=(FileModel *)[request.userInfo objectForKey:@"File"];
//    [fileInfo.fileReceivedData appendData:data];
//    fileInfo.fileReceivedSize=[NSString stringWithFormat:@"%d",[fileInfo.fileReceivedData length]];
//    [fileInfo.fileReceivedData writeToFile:request.temporaryFileDownloadPath atomically:NO];
//    NSString *configPath=[[CommonHelper getTempFolderPath] stringByAppendingPathComponent:[fileInfo.fileName stringByAppendingString:@".rtf"]];
//    NSString *tmpConfigMsg=[NSString stringWithFormat:@"%@,%@,%@,%@",fileInfo.fileName,fileInfo.fileSize,fileInfo.fileReceivedSize,fileInfo.fileURL];
//    NSError *error;
//    [tmpConfigMsg writeToFile:configPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
//    if(!error)
//    {
//        NSLog(@"错误%@",[error description]);
//    }
//    [self.downloadDelegate updateCellProgress:fileInfo];
//    NSLog(@"正在接受搜数据%d",[fileInfo.fileReceivedData length]);
//}

//1.实现ASIProgressDelegate委托，在此实现UI的进度条更新,这个方法必须要在设置[request setDownloadProgressDelegate:self];之后才会运行
//2.这里注意第一次返回的bytes是已经下载的长度，以后便是每次请求数据的大小
//费了好大劲才发现的，各位新手请注意此处
-(void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
    if(!fileInfo.isFistReceived)
    {
        fileInfo.fileReceivedSize=[NSString stringWithFormat:@"%lld",[fileInfo.fileReceivedSize longLongValue]+bytes];
    }
    if([self.downloadDelegate respondsToSelector:@selector(updateCellProgress:)])
    {
        [self.downloadDelegate updateCellProgress:request];
    }
    fileInfo.isFistReceived=NO;
}

//将正在下载的文件请求ASIHttpRequest从队列里移除，并将其配置文件删除掉,然后向已下载列表里添加该文件对象
-(void)requestFinished:(ASIHTTPRequest *)request
{
    [self playDownloadFinishSound];
    FileModel *fileInfo=(FileModel *)[request.userInfo objectForKey:@"File"];
    NSInteger index=[fileInfo.fileName rangeOfString:@"."].location;
    NSString *name=[fileInfo.fileName substringToIndex:index];;
    NSString *configPath=[[CommonHelper getTempFolderPath] stringByAppendingPathComponent:[name stringByAppendingString:@".rtf"]];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    if([fileManager fileExistsAtPath:configPath])//如果存在临时文件的配置文件
    {
        [fileManager removeItemAtPath:configPath error:&error];
    }
    if(!error)
    {
        NSLog(@"%@",[error description]);
    }
    if([self.downloadDelegate respondsToSelector:@selector(finishedDownload:)])
    {
        [self.downloadDelegate finishedDownload:request];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:kFileDownloadSuccess object:fileInfo];
    
    [request release];
}
#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Tree1.0.0.sqlite"]];
	
	NSError *error;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        // Handle the error.
        NSLog(@"addPersistentStoreWithType error:%@",error);
    }
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}
@end