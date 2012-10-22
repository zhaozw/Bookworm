//
//  ReadBooks.m
//  BookShelf
//
//  Created by mac on 12-9-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReadBooks.h"

@implementation ReadBooks

@synthesize str;

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
  //  [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    //隐藏导航栏上面的横条
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
   [UIView commitAnimations];
    
    
   // self.view.backgroundColor = [UIColor grayColor];
    
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"green.png"]];
    imageView.frame = CGRectMake(0, 0, 320,480 - 44);
    
    [self.view addSubview:imageView];
    [imageView release];
    
    
    //自定义工具栏
    UIToolbar * toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 480 - 44, 320, 44)];
    toolBar.tintColor = [UIColor grayColor];
    [self.view addSubview:toolBar];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 480 - 44)];
    [self.view addSubview:textView];
    textView.text = self.str;
    
    textView.font = [UIFont italicSystemFontOfSize:20];
    textView.inputAccessoryView = imageView;
    
    textView.textColor = [UIColor blackColor];
    
    textView.backgroundColor = [UIColor grayColor];
    
    
    
    textView.editable = NO;
    [textView release];
    
    NSLog(@"%f",textView.contentSize.height);
    
    //计算textView的总页数
    allPage = textView.contentSize.height / 430 + 1;
    //设置当前页为1
    currentPage = 1;
    //为工具栏设置按钮
    UIBarButtonItem * button01 = [[UIBarButtonItem alloc] initWithTitle:@"我的书架" style:UIBarButtonItemStylePlain target:self action:@selector(onClick)];
    UIBarButtonItem * button02 = [[UIBarButtonItem alloc] initWithTitle:@"上一页" style:UIBarButtonItemStylePlain target:self action:@selector(upPage)];
    button02.tag = 200;
    UIBarButtonItem * button03 = [[UIBarButtonItem alloc] initWithTitle:@"下一页" style:UIBarButtonItemStylePlain target:self action:@selector(downPage)];
    button03.tag = 300;
    button04 = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%d/%d",currentPage,allPage] style:UIBarButtonItemStylePlain target:self action:@selector(hello)];
    button04.tag = 110;
    //将工具栏按钮添加到一个数组里面
    NSArray * array = [[NSArray alloc] initWithObjects:button01,button02,button03,button04, nil];
    //给工具栏添加按钮
    [toolBar setItems:array animated:YES];
    [button01 release];
    [button02 release];
    [button03 release];
    [button04 release];
    
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [textView addGestureRecognizer:pan];
    
    [pan release];
}


- (void)pan:(UIPanGestureRecognizer *)pan{
    CGPoint  point = [pan translationInView:textView];
    if (point.x < -5 && point.x > -10) {
        [pan setTranslation:CGPointMake(0, 0) inView:textView];
        [self upPage];
        return;
    }else if (point.x > 5 && point.x < 10) {
        [self downPage];
        [pan setTranslation:CGPointMake(0, 0) inView:textView];
        return;
    }
    [pan setTranslation:CGPointMake(0, 0) inView:textView];
    NSLog(@"%f",point.x);
    return;
}


//点击上一页时响应的事件
-(void)upPage{
    if (currentPage == 1) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"这已是第一页" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        [alertView release];
        return;
    }
    currentPage = currentPage - 1;
    NSLog(@"%d",currentPage);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [textView setContentOffset:CGPointMake(0, (currentPage - 1) * 430) animated:YES];
    [UIView commitAnimations];
//    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    
   
    [UIView commitAnimations];
    
    [button04 setTitle:[NSString stringWithFormat:@"%d/%d",currentPage,allPage]];
    return;
}
//点击下一页时响应的事件
-(void)downPage{
    if (currentPage == allPage) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"这已是最后一页" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        [alertView release];
        return;
    }
    currentPage = currentPage + 1;
    
    NSLog(@"%d",currentPage);
    [button04 setTitle:[NSString stringWithFormat:@"%d/%d",currentPage ,allPage]];
    
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [textView setContentOffset:CGPointMake(0, (currentPage - 1) * 430) animated:YES];
    [UIView commitAnimations];
   
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    [UIView commitAnimations];
    
    return;
}

-(void)hello{
    return;
}


////此视图将要出现时隐藏导航栏和最上面的横条
//-(void)viewWillAppear:(BOOL)animated{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.35];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
//    //隐藏导航栏上面的横条
//    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    
//    //隐藏导航栏
//    //self.navigationController.navigationBar.hidden = YES;
//    [UIView commitAnimations];
//    self.view.backgroundColor = [UIColor grayColor];
//}

//点击我的书架时回到主页
- (void)onClick{
    [self dismissModalViewControllerAnimated:YES];
    return;
}

@end
