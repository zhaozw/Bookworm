//
//  MyBookShellCell.m
//  BookShelf
//
//  Created by mac on 12-9-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyBookShellCell.h"

@implementation MyBookShellCell

@synthesize label;
@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BookShelfCell.png"]];
        imageView.frame = CGRectMake(0, 0, 320, 139);
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 139)];
        label.backgroundColor = [UIColor clearColor];
        [label addSubview:imageView];
        [self addSubview:label];
        [label release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
