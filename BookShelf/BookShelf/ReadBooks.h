//
//  ReadBooks.h
//  BookShelf
//
//  Created by mac on 12-9-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadBooks : UIViewController<UITextViewDelegate>
{
@private
    UITextView * textView;
    int currentPage;
    int allPage;
    UIBarButtonItem * button04 ;
}
@property (nonatomic ,retain) NSString* str;


-(void)downPage;


-(void)upPage;

@end
