//
//  LatestBooks.m
//  MyLauncher
//
//  Created by ramonqlee on 10/15/12.
//
//

#import "LatestBooks.h"
#import "AppDelegate.h"
#import "CoreDataMgr.h"
#import "GDataXMLNode.h"
#import "Tree.h"
static LatestBooks * sSharedInstance;
#define kLatestBooksFileNameWithSuffix @"latestbooks.xml"



@implementation LatestBooks
-(oneway void)release
{
    [super release];
    sSharedInstance = nil;
}
+(id)shareInstance
{
    if(!sSharedInstance)
    {
        sSharedInstance = [[LatestBooks alloc] init];
    }
    return sSharedInstance;
}


-(id)init:(NSString*)filePath
{
    if (self = [super init]) {
        [self parseLocalCategoryXML];
    }
    return self;
}
-(void)parseLocalCategoryXML
{
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString* xmlFileName = [[delegate applicationDocumentsDirectory]stringByAppendingPathComponent:kLatestBooksFileNameWithSuffix];
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
-(NSInteger)countOfBooks
{
    return 1;
}
-(id)bookInfo:(NSInteger)index
{
    Tree* item=[[Tree alloc]init];
    item.image = @"itemImage";
    item.filename = @"iOSUIGuide.pdf";
    item.name = @"iOSUIGuide";
    return item;
}
@end
