//
//  BaiduMusicHelper.h
//  Hayate
//
//  Created by 韩 国翔 on 11-12-2.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "FileModel.h"
#import "ASIHTTPRequest.h"

@interface BaiduMusicHelper : NSObject 
<NSXMLParserDelegate>{

   
}


//通过歌曲名字得到可以下载的歌曲信息
+(NSData *)getDataByMusicName:(NSString *)musicName;

@end
