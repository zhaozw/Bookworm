//
//  CommonHelper.h
//  Hayate
//
//  Created by 韩 国翔 on 11-12-2.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonHelper : NSObject {
    
}


////将字节转化成M单位，不附带M
//+(NSString *)transformToM:(NSString *)size;
////将不M的字符串转化成字节
//+(float)transformToBytes:(NSString *)size;
//将文件大小转化成M单位或者B单位
+(NSString *)getFileSizeString:(NSString *)size;
//经文件大小转化成不带单位ied数字
+(float)getFileSizeNumber:(NSString *)size;

+(NSString *)getTargetFolderPath;//得到实际文件存储文件夹的路径
+(NSString *)getTempFolderPath;//得到临时文件存储文件夹的路径
+(BOOL)isExistFile:(NSString *)fileName;//检查文件名是否存在

//传入文件总大小和当前大小，得到文件的下载进度
+(CGFloat) getProgress:(float)totalSize currentSize:(float)currentSize;
@end
