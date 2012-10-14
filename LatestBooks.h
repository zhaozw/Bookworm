//
//  LatestBooks.h
//  MyLauncher
//  提供最近下载书籍的管理：包括数据的增删改查
//  Created by ramonqlee on 10/15/12.
//
//

#import <Foundation/Foundation.h>

@interface LatestBooks : NSObject

+(id)shareInstance;

//edit
-(void)addBook:(id)book;
-(void)updateBook:(id)book;
-(void)deleteBook:(id)book;

-(NSInteger)countOfBooks;
-(id)bookInfo:(NSInteger)index;

@end
