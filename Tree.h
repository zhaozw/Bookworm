//
//  Tree.h
//  MyLauncher
//
//  Created by ramonqlee on 10/15/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tree : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSString * filesize;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * subcategory;
@property (nonatomic, retain) NSDate * time;//latest update time
@end
