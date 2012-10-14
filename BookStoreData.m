//
//  BookStoreData.m
//  MyLauncher
//
//  Created by ramonqlee on 10/14/12.
//
//

#import "BookStoreData.h"
#import "AppDelegate.h"
#import "CoreDataMgr.h"
#import "GDataXMLNode.h"
#import "Tree.h"

#define TYPE_ACCOUNT_KEY @"AccountTypeCount"
#define TYPE_NAME_PREFIX @"TypeName"
#define TYPE_ICON_PREFIX @"TypeIcon"

#define kBookStoreFileNameWithSuffix @"bookstore.xml"

static BookStoreData * sSharedInstance;

@interface BookStoreData()

-(void)initWithCoreData;
-(void)parseLocalCategoryXML;
@end

@implementation BookStoreData
-(oneway void)release
{
    [super release];
    sSharedInstance = nil;
}
+(id)shareInstance
{
    if(!sSharedInstance)
    {
        sSharedInstance = [[BookStoreData alloc] init];
    }
    return sSharedInstance;
}

-(id)init:(NSString*)filePath
{
    if (self = [super init]) {
        _managedObjectContext = [((AppDelegate*)[[UIApplication sharedApplication]delegate]) managedObjectContext];
        
        //init data from core data
        if(filePath)
        {
            //TODO::reset local data            
        }
        else
        {
            [self initWithCoreData];
        }
    }
    return self;
}
-(void)parseLocalCategoryXML
{
    //#define kLocalStringCategory
#ifdef kLocalStringCategory
    NSMutableArray* sections = [[NSMutableArray alloc]init];
    NSString* typeCount = NSLocalizedString(TYPE_ACCOUNT_KEY, "");
    NSLog(@"%@",typeCount);
    for (NSInteger i = 0; i < [typeCount intValue]; ++i) {
        NSString* nameKey = [NSString stringWithFormat:@"%@%d",TYPE_NAME_PREFIX,i];
        [sections addObject:NSLocalizedString(nameKey, "")];
    }
    _mSectionName = [[NSArray alloc]initWithArray:sections];
    [sections release];
    
    sections = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < [typeCount intValue]; ++i) {
        NSString* nameKey = [NSString stringWithFormat:@"%@%d",TYPE_ICON_PREFIX,i];
        [sections addObject:NSLocalizedString(nameKey, "")];
    }
    _mSectionNameIcons = [[NSArray alloc]initWithArray:sections];
    [sections release];
#else
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString* xmlFileName = [[delegate applicationDocumentsDirectory]stringByAppendingPathComponent:kBookStoreFileNameWithSuffix];
    NSFileManager* fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:xmlFileName])
    {
        return;
    }
    
    //parse xml in local directory
    NSData* responseXML = [NSData dataWithContentsOfFile:xmlFileName];
    NSError *error;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:responseXML options:0 error:&error]autorelease];
    if (doc == nil) {
        return;
    }
    
    NSArray *members = [doc nodesForXPath:@"//channel/item" error:nil];
    
    NSMutableArray* names = [[NSMutableArray alloc]init];
    NSMutableArray* icons = [[NSMutableArray alloc]init];
    for (GDataXMLElement *member in members){
        NSString *title = [[member attributeForName:@"title"] stringValue];
        NSString *icon = [[member attributeForName:@"icon"] stringValue];
        NSLog(@"name:%@,icon:%@",title,icon);
        [names addObject:title];
        [icons addObject:icon];
    }
    //_mSectionName = names;
    //_mSectionNameIcons = icons;
    
    //[doc release];??
#endif
}
-(void)initWithCoreData
{
    CoreDataMgr* mgr = [CoreDataMgr sharedProtocolLogManager];
    
    //TODO::category according to type
    Tree* info = nil;
    NSLog(@"account count::%d", [mgr count]);
    for (NSInteger i = 0; i < [mgr count]; ++i) {
        info = [mgr objectAtIndex:i];
//        if (info) {
//            [self setRowInSection:info inSection:[info.type intValue]];
//        }
    }
    
}
-(void)dealloc
{
//    for (NSInteger i = 0; i < [_mData count]; ++i) {
//        [[_mData objectAtIndex:i]release];
//    }
//    [_mData release];
//    [_mSectionName release];
    [super dealloc];
}

#pragma mark interfaceImplementation
//edit
-(void)addBook:(id)book
{
    
}
-(void)updateBook:(id)book
{
    
}
-(void)deleteBook:(id)book
{
    
}

//Query
//category related
-(NSUInteger)countOfCategory
{
    return 0;
}
-(void)setCurrentCategory:(NSInteger)index
{
    
}
-(NSString*)categoryName:(NSInteger)index
{
    return @"";
}

-(NSUInteger)countOfSubcategory
{
    return 0;
}
-(void)setCurrentSubcategory:(NSInteger)index
{
    
}
-(NSString*)subcategoryName:(NSInteger)index
{
    return @"";
}

//Book related
-(NSInteger)countOfBooks
{
    return 0;
}
-(id)bookInfo:(NSInteger)index
{
    return nil;
}
@end
