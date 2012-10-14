//
//  BookStoreData.h
//  MyLauncher
//  本地书库数据的接口类
//    提供本地数据的访问，包括数据重置，数据的增删改查。
//  Created by ramonqlee on 10/14/12.
//
//

#import <Foundation/Foundation.h>

@interface BookStoreData : NSObject
{
    NSManagedObjectContext* _managedObjectContext;
    
    /*数据结构描述
     采用二维数组的方式纪录每本书的信息，其中category维度为所有的类别，subcategory为所属的子类别，其中将包括具体的信息
     
     比如
     流行－－玄幻－－龙门飞甲
     流行－－玄幻－－龙门飞甲2
     小说－－爱情－－我的爱人
     
     则 category中的数据为｛流行，小说｝
     subcategory中的数据为｛玄幻，爱情｝
     book中的信息为
     流行
        玄幻：｛龙门飞甲，龙门飞甲2｝
     小说
        爱情：｛我的爱人｝
     */
    NSMutableArray* mCategoryArray;
    NSMutableArray* mSubCategoryArray;
    NSMutableArray* mBookArray;
}
+(id)shareInstance;

//filePath
//nil to return local data else to reset data
-(id)init:(NSString*)filePath;

//edit
-(void)addBook:(id)book;
-(void)updateBook:(id)book;
-(void)deleteBook:(id)book;

//Query 
//category related
-(NSUInteger)countOfCategory;
-(void)setCurrentCategory:(NSInteger)index;
-(NSString*)categoryName:(NSInteger)index;

-(NSUInteger)countOfSubcategory;
-(void)setCurrentSubcategory:(NSInteger)index;
-(NSString*)subcategoryName:(NSInteger)index;

//Book related
-(NSInteger)countOfBooks;
-(id)bookInfo:(NSInteger)index;

@end
