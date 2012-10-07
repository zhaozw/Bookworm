//
//  MusicCell.m
//  Hayate
//
//  Created by 韩 国翔 on 11-12-2.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "MusicCell.h"


@implementation MusicCell

@synthesize musicName;
@synthesize musicSize;
@synthesize musicDown;
@synthesize fileInfo;

- (void)dealloc
{
    [fileInfo release];
    [musicDown release];
    [musicSize release];
    [musicName release];
    [super dealloc];
}

-(void)downMusic:(id)sender
{    
    FileModel *selectFileInfo=self.fileInfo;
    
    //选择点击的行
//    UITableView *tableView=(UITableView *)[sender superview];
//    NSLog(@"%d",[fileInfo.fileID integerValue]);
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[fileInfo.fileID integerValue] inSection:0];
//    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
    //因为是重新下载，则说明肯定该文件已经被下载完，或者有临时文件正在留着，所以检查一下这两个地方，存在则删除掉
    NSString *targetPath=[[CommonHelper getTargetFolderPath]stringByAppendingPathComponent:selectFileInfo.fileName];
    NSString *tempPath=[[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:selectFileInfo.fileName]stringByAppendingString:@".temp"];
    if([CommonHelper isExistFile:targetPath])//已经下载过一次该音乐
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该文件已经添加到您的下载列表中了！是否重新下载该文件？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
        return;
    }
    //存在于临时文件夹里
    if([CommonHelper isExistFile:tempPath])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该文件已经添加到您的下载列表中了！是否重新下载该文件？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
        return;
    }
    selectFileInfo.isDownloading=YES;
    //若不存在文件和临时文件，则是新的下载
    AppDelegate *appDelegate=APPDELEGETE;
    [appDelegate beginRequest:selectFileInfo isBeginDown:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)//确定按钮
    {
        NSFileManager *fileManager=[NSFileManager defaultManager];
        NSError *error;
        AppDelegate *appDelegate=APPDELEGETE;
        NSString *targetPath=[[CommonHelper getTargetFolderPath]stringByAppendingPathComponent:self.fileInfo.fileName];
        NSString *tempPath=[[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:self.fileInfo.fileName]stringByAppendingString:@".temp"];
        if([CommonHelper isExistFile:targetPath])//已经下载过一次该音乐
        {
            [fileManager removeItemAtPath:targetPath error:&error];
            if(!error)
            {
                NSLog(@"删除文件出错:%@",error);
            }
            for(FileModel *file in appDelegate.finishedlist)
            {
                if([file.fileName isEqualToString:self.fileInfo.fileName])
                {
                    [appDelegate.finishedlist removeObject:file];
                    break;
                }
            }
        }    
        //存在于临时文件夹里
        if([CommonHelper isExistFile:tempPath])
        {
            [fileManager removeItemAtPath:tempPath error:&error];
            if(!error)
            {
                NSLog(@"删除临时文件出错:%@",error);
            }
        }
        
        for(ASIHTTPRequest *request in appDelegate.downinglist)
        {
            FileModel *fileModel=[request.userInfo objectForKey:@"File"];
            if([fileModel.fileName isEqualToString:self.fileInfo.fileName])
            {
                [appDelegate.downinglist removeObject:request];
                break;
            }
        }
        self.fileInfo.isDownloading=YES;
        self.fileInfo.fileReceivedSize=[CommonHelper getFileSizeString:@"0"];
        [appDelegate beginRequest:self.fileInfo isBeginDown:YES];
    }
}

@end
