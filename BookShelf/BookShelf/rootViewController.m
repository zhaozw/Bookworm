//
//  rootViewController.m
//  BookShelf
//
//  Created by mac on 12-9-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "rootViewController.h"

@implementation rootViewController

static int cnt;

-(void)dealloc{
    [dataArray release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage * backgroundImage = [UIImage imageNamed:@"BookShelfCell@2x.png"];
    
    UIColor * backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    self.view.backgroundColor = backgroundColor;
    
    //将每本书的封面图片以字符串的形式存取到数组中
    dataArray = [[NSArray alloc] initWithObjects:@"aizaixianjingderizi.jpeg",@"anshizhangda.jpeg",@"bubizhidaowoshishui.jpeg",@"dangnigudannihuixiangqishui.jpeg",@"hudielaiguozheshijie.jpeg",@"liaiyigeIDdejuli.jpeg",@"shalou.jpeg",@"shinian.jpeg",@"tangyi.jpeg",@"tiaopin.jpeg",@"wobushinideyuanjia.jpeg",@"woyaowomenzaiyiqi.jpeg",@"xiaofudequnbai.jpeg",@"xiaoyaodejinsechengbao.jpeg",@"zuishuxidemoshengren.jpeg",@"zuoer.jpg",@"zuoerzhongjie.jpeg",@"aizaixianjingderizi.jpeg", nil];
    //设置导航栏上的标题
    self.navigationItem.title = @"迷你小书屋";
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    mainScrollView.backgroundColor = [UIColor redColor];
    //设置mainScrollView的大小
    mainScrollView.contentSize = CGSizeMake(640, 460);
    [self.view addSubview:mainScrollView];
    [mainScrollView release];
    mainScrollView.delegate = self;
    //隐藏水平和垂直滚动条
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    
    //将分页开关打开
    mainScrollView.pagingEnabled = YES;
    //静止来回晃动
    mainScrollView.bounces = NO;
    
   // mainScrollView.scrollEnabled = NO;
    
    _tableView[0] = [[UITableView alloc] initWithFrame:CGRectMake(0 , 0,320,416) style:UITableViewStylePlain];
    _tableView[0].delegate = self;
    _tableView[0].dataSource = self;
    _tableView[0].backgroundColor = [UIColor grayColor];
    [mainScrollView addSubview:_tableView[0]];
    [_tableView[0] release];
    //静止来回晃动
    _tableView[0].bounces = NO;
    _tableView[0].tag = 100;
    
    _tableView[1] = [[UITableView alloc] initWithFrame:CGRectMake(320 ,0,320,416) style:UITableViewStylePlain];
    _tableView[1].delegate = self;
    _tableView[1].dataSource = self;
    _tableView[1].backgroundColor = [UIColor orangeColor];
    [mainScrollView addSubview:_tableView[1]];
    [_tableView[1] release];
    //静止来回晃动
    _tableView[1].bounces = NO;
    _tableView[1].tag = 200;

    
}
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


//cell的行高
/*
 @interface NSIndexPath (UITableView)
 
 + (NSIndexPath *)indexPathForRow:(NSInteger)row inSection:(NSInteger)section;
 
 @property(nonatomic,readonly) NSInteger section;
 @property(nonatomic,readonly) NSInteger row;
 
 @end
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 139;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyBookShellCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil) {
        cell = [[MyBookShellCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ID"];
    }
    //将cell设置成点击时不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //如果是第一个表格视图
    if (tableView.tag == 100) {
        for (int i = 0; i < 3; i++) {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(10 + ((320 - 40) / 3 + 10) * i, 5, (320 - 40) / 3, 119);
            button.tag = cnt;//将cnt设置成button的tag，方便获取
            [button setImage:[UIImage imageNamed:[dataArray objectAtIndex:cnt++]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button];
        }
    }
    //如果是第二个表格视图
    if (tableView.tag == 200) {
        for (int i = 0; i < 3; i++) {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = cnt;   //将cnt设置成button的tag，方便获取
            button.frame = CGRectMake(10 + ((320 - 40) / 3 + 10) * i, 5, (320 - 40) / 3, 119);
            [button setImage:[UIImage imageNamed:[dataArray objectAtIndex:cnt++]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button];
        }
    }
    return cell;
}


- (void)onClick:(UIButton *)sender{
    ReadBooks * readBook = [[ReadBooks alloc] init];
    if (sender.tag == 0) {
        //获取aizaixianjingderizi.txt里面的内容
        readBook.str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"aizaixianjingderizi" ofType:@"txt" ]encoding:NSUTF8StringEncoding error:nil];
    }
    if (sender.tag == 1) {
        readBook.str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"anshizhangda" ofType:@"txt" ]encoding:NSUTF8StringEncoding error:nil];
    }
    if (sender.tag == 2) {
        readBook.str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bubizhidaowoshishui" ofType:@"txt" ]encoding:NSUTF8StringEncoding error:nil];
    }
    if (sender.tag == 3) {
        readBook.str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dangnigudannihuixiangqishui" ofType:@"txt" ]encoding:NSUTF8StringEncoding error:nil];
    }
    if (sender.tag == 4) {
        readBook.str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hudielaiguozheshijie" ofType:@"txt" ]encoding:NSUTF8StringEncoding error:nil];
    }
    if (sender.tag == 5) {
        readBook.str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"liaiyigeIDdejuli" ofType:@"txt" ]encoding:NSUTF8StringEncoding error:nil];
    }
    if (sender.tag == 6) {
        readBook.str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shalou" ofType:@"txt" ]encoding:NSUTF8StringEncoding error:nil];
    }
    if (sender.tag == 7) {
        readBook.str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shinian" ofType:@"txt" ]encoding:NSUTF8StringEncoding error:nil];
    }
    if (sender.tag == 8) {
        readBook.str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tangyi" ofType:@"txt" ]encoding:NSUTF8StringEncoding error:nil];
    }
    
    if (sender.tag == 9) {
        readBook.str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tiaopin" ofType:@"txt" ]encoding:NSUTF8StringEncoding error:nil];
    }
    if (sender.tag == 10) {
        readBook.str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wobushinideyuanjia" ofType:@"txt" ]encoding:NSUTF8StringEncoding error:nil];
    }
    if (sender.tag == 11) {
        readBook.str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"woyaowomenzaiyiqi" ofType:@"txt" ]encoding:NSUTF8StringEncoding error:nil];
    }
    if (sender.tag == 12) {
        readBook.str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"xiaofudequnbai" ofType:@"txt" ]encoding:NSUTF8StringEncoding error:nil];
    }
    if (sender.tag == 13) {
        readBook.str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"xiaoyaodejinsechengbao" ofType:@"txt" ]encoding:NSUTF8StringEncoding error:nil];
    }
    if (sender.tag == 14) {
        readBook.str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"zuishuxidemoshengren" ofType:@"txt" ]encoding:NSUTF8StringEncoding error:nil];
    }
    if (sender.tag == 15) {
        readBook.str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"zuoer" ofType:@"txt" ]encoding:NSUTF8StringEncoding error:nil];
    }
    if (sender.tag == 16) {
        readBook.str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"zuoerzhongjie" ofType:@"txt" ]encoding:NSUTF8StringEncoding error:nil];
    }
    if (sender.tag == 17) {
        readBook.str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"aizaixianjingderizi" ofType:@"txt" ]encoding:NSUTF8StringEncoding error:nil];
    }
    //设置翻转模式
    [readBook setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:readBook animated:YES];
    //[self.navigationController pushViewController:readBook animated:YES];
    return;
}




-(void)viewWillAppear:(BOOL)animated{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    //打开状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //打开导航栏
   // self.navigationController.navigationBar.hidden = NO;
    [UIView commitAnimations];
    return;
}

@end
