//
//  rootViewController.h
//  BookShelf
//
//  Created by mac on 12-9-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBookShellCell.h"
#import "ReadBooks.h"

@interface rootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
@private
    UIScrollView * mainScrollView;
    UITableView * _tableView[2];
    NSArray * dataArray;
    UIButton * button;
}




@end
