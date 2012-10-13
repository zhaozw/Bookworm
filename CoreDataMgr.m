//
//  ProtocolLogManager.m
//  today
//
//  Created by li ming on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoreDataMgr.h"
#import "AppDelegate.h"
#import "Tree.h"


@interface CoreDataMgr()
{
    NSMutableArray* mLogData;
}

-(void)initWithCoreData;
-(void)addObject:(id)obj;

@end

static CoreDataMgr * sSharedInstance;
@implementation CoreDataMgr

+(id)sharedCoreDataMgr
{
    if(!sSharedInstance)
    {
        sSharedInstance = [[CoreDataMgr alloc] init];
    }
    [sSharedInstance initWithCoreData];
    return sSharedInstance;   
}
+(void)reset
{
    [sSharedInstance release];
    sSharedInstance = nil;
}
-(void)dealloc
{
    [mLogData release];
    [super dealloc];
}
-(void)initWithCoreData
{    
    //TODO::init with core data
    if(!mLogData)
    {    
        NSManagedObjectContext* _managedObjectContext = MANAGED_CONTEXT;
        /*
         Fetch existing events.
         Create a fetch request; find the Event entity and assign it to the request; add a sort descriptor; then execute the fetch.
         */
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tree" inManagedObjectContext:_managedObjectContext];
        [request setEntity:entity];
        
        // Order the events by creation date, most recent first.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];
        [sortDescriptor release];
        [sortDescriptors release];
        
        // Execute the fetch -- create a mutable copy of the result.
        NSError *error = nil;
        NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResults == nil) {
            // Handle the error.
        }
        
        mLogData = [[NSMutableArray alloc]initWithArray:mutableFetchResults];     
        
        [mutableFetchResults release];
        [request release];
    }
}
-(NSUInteger)count
{
    return [mLogData count];
}

-(id)objectAtIndex:(NSUInteger)index
{
    if(index < [mLogData count])
    {
        return [mLogData objectAtIndex:index];
    }
    return nil;
}
-(void)addObject:(id)obj front:(Boolean)front
{
    if (!(obj && [obj isKindOfClass:[Tree class]])) {
        return;
    }
    //save to coredatas       
    NSManagedObjectContext* managedObjectContext = MANAGED_CONTEXT;
    NSLog(@"account count::%d", [self count]);
    //add location as event
    Tree* event = obj;
    
    @try {
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            // Handle the error.
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description] );
    }
    @finally {
        
    }
    if(front)
    {
        [mLogData insertObject:event atIndex:0];
    }
    else
    {
        [mLogData addObject:event];    
    }
    NSLog(@"account count::%d", [self count]);
}
-(void)addObject2Front:(id)obj
{
    [self addObject:obj front:YES];
}

-(void)addObject:(id)obj
{    
    [self addObject:obj front:NO];
}

-(void)removeObjectAtIndex:(NSUInteger)index
{
    if(index < [mLogData count])
    {
        //remove from coredatas
        NSManagedObject *logToDelete = [mLogData objectAtIndex:index];
        NSManagedObjectContext* managedObjectContext = MANAGED_CONTEXT;
        [managedObjectContext deleteObject:logToDelete];
        
        // Commit the change.
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            // Handle the error.
        }
        
        [mLogData removeObjectAtIndex:index];
        
    }    
}
-(void)removeObject:(id)obj
{
    NSUInteger l = [mLogData indexOfObject:obj];
    if(l!=NSNotFound)
    {
        [self removeObjectAtIndex:l];      
    }
}
-(void)removeAllObjects
{
    if([mLogData count]<=0)
    {
        return;
    }
    
    for (NSInteger i = [mLogData count]-1; i >=0 ;--i ) {
        [self removeObjectAtIndex:i];
    }
}
-(BOOL)replaceObject:(id)obj
{
    NSUInteger l = [mLogData indexOfObject:obj];
    if(l!=NSNotFound)
    {
        NSManagedObjectContext* managedObjectContext = MANAGED_CONTEXT;
        // Commit the change.
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            // Handle the error.
            return NO;
        }
        
        [mLogData replaceObjectAtIndex:l withObject:obj];        
    }
    
    return YES;
}
@end
