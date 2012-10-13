//
//  BookStoreData.h
//  MyLauncher
//  
//  Created by ramonqlee on 10/14/12.
//
//

#import <Foundation/Foundation.h>

@interface BookStoreData : NSObject
{
    NSManagedObjectContext* _managedObjectContext;
}
+(id)shareInstance;

//init
-(id)init;

//edit
-(void)addBook:(id)book;
-(void)updateBook:(id)book;
-(void)deleteBook:(id)book;

//Query
//category related
-(NSUInteger)countOfCategory;
-(void)setCurrentCategory:(NSInteger)index;
-(NSString*)categoryName:(NSInteger)index;

//Book related
-(NSInteger)countOfBooks;
-(id)bookInfo:(NSInteger)index;

@end
