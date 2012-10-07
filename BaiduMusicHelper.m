//
//  BaiduMusicHelper.m
//  Hayate
//
//  Created by 韩 国翔 on 11-12-2.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "BaiduMusicHelper.h"


@implementation BaiduMusicHelper

+(NSData *)getDataByMusicName:(NSString *)musicName
{
    NSString *requestUrl=BAIDUMUSIC_API(musicName);
    ASIHTTPRequest *theRequest=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [theRequest addRequestHeader:@"Content-Type" value:@"text/xml"];
    [theRequest setRequestMethod:@"GET"];//ASIHttpRequest默认是GET
    [theRequest startSynchronous];
    NSError *error=[theRequest error];
    if(error!=nil)
    {
        NSLog(@"BaiduMusicHelper百度请求错误：%@",error);
    }
    return [theRequest responseData];
}
@end
