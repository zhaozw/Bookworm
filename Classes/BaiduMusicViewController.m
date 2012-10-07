//
//  BaiduMusicViewController.m
//  Hayate
//
//  Created by 韩 国翔 on 11-12-2.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "BaiduMusicViewController.h"


@implementation BaiduMusicViewController

@synthesize musicSearcher;
@synthesize musicTable;
@synthesize isLoading;
@synthesize inputOverLayer;
@synthesize loadingOverLayer;
@synthesize musicList;
@synthesize connList;
@synthesize isFinished;
@synthesize theRequest;
@synthesize currentElement;
@synthesize rootElement;
@synthesize currentUrl;
@synthesize currentFile;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [connList release];
    [currentUrl release];
    [currentElement release];
    [currentFile release];
    [rootElement release];
    [musicList release];
    [theRequest release];
    [inputOverLayer release];
    [loadingOverLayer release];
    [musicTable release];
    [musicSearcher release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction)cancelLoading:(id)sender
{
    [self stopWaitting];   
}

-(void)dismissLoadingOverLayer
{
    if([self.loadingOverLayer superview]!=nil)
    {
        [self.loadingOverLayer removeFromSuperview];
    }
}

-(void)dismissInputOverLayer
{
    if([self.inputOverLayer superview]!=nil)
    {
        [self.inputOverLayer removeFromSuperview];
    }
}

-(void)startWaitting
{
    self.loadingOverLayer.alpha=0.0f;
    UIActivityIndicatorView *actView=(UIActivityIndicatorView *)[self.loadingOverLayer viewWithTag:101];
    [actView startAnimating];
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4f];
    self.loadingOverLayer.alpha=0.6f;
    [self.view addSubview:self.loadingOverLayer];
    [UIView commitAnimations];
}

-(void)stopWaitting
{
    self.loadingOverLayer.alpha=0.6f;
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4f];
    self.loadingOverLayer.alpha=0.0f;
    [UIView commitAnimations];
    
    [self performSelector:@selector(dismissLoadingOverLayer) withObject:nil afterDelay:0.4f];
}

-(void)hideInput
{
    [self.musicSearcher resignFirstResponder];
}

-(void)hideSearchBar
{
    [APPDELEGETE playButtonSound];
    [self hideInput];
    
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"音乐搜索" style:UIBarButtonItemStylePlain target:self action:@selector(showSearchBar)]autorelease];
    
    self.inputOverLayer.alpha=0.6;
    CGRect oldFrame=self.musicTable.frame;
    CGRect newFrame=CGRectMake(0, 0, oldFrame.size.width, oldFrame.size.height);
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4f];
    self.musicTable.frame=newFrame;
    self.inputOverLayer.alpha=0.0;
    [self performSelector:@selector(dismissInputOverLayer) withObject:nil afterDelay:0.4f];
    [UIView commitAnimations];
}

-(void)showSearchBar
{
    [APPDELEGETE playButtonSound];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(hideSearchBar)]autorelease];
    
    self.inputOverLayer.alpha=0.0f;
    CGRect oldFrame=self.musicTable.frame;
    CGRect newFrame=CGRectMake(0, 44, oldFrame.size.width, oldFrame.size.height);
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4f];
    self.musicTable.frame=newFrame;
    self.inputOverLayer.alpha=0.6f;
    [self.musicTable addSubview:self.inputOverLayer];
    [UIView commitAnimations];
}

-(void)checkFinished:(NSTimer *)timer
{
    count++;
    if(!self.isLoading&&count>=1)
    {
        [timer invalidate];
        [self stopWaitting];
    }
    if(count>10)
    {
        [timer invalidate];
        [self stopWaitting];
        self.isLoading=NO;
    }
}

-(void)startRequest:(NSString *)musicName
{ 
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    self.musicList=[[[NSMutableArray alloc] init] autorelease];
    NSData *resultData=[BaiduMusicHelper getDataByMusicName:musicName];
    
    if(resultData!=nil)
    {
        //将gb2312转化成utf-8重新解析，要不然会报错
        // Error Domain=NSXMLParserErrorDomain Code=31 "The operation couldn’t be completed. (NSXMLParserErrorDomain error 31.)"
        NSMutableString *newXML=[[NSMutableString alloc] initWithData:resultData encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
        [newXML replaceCharactersInRange:[newXML rangeOfString:@"gb2312"] withString:@"utf-8"];
        NSXMLParser *musicParser=[[NSXMLParser alloc] initWithData:[newXML dataUsingEncoding:NSUTF8StringEncoding]];
        [musicParser setDelegate:self];
        [musicParser parse];
        [musicParser release];
        [newXML release];
        [pool release];
    }
}

-(void)searchMusicByMusicName:(NSString *)musicName
{
    [self hideSearchBar];
    [self startWaitting];
    self.isLoading=YES;
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(checkFinished:) userInfo:nil repeats:YES];
    [NSThread detachNewThreadSelector:@selector(startRequest:) toTarget:self withObject:musicName];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"baidu_bg.jpg"]];
    img.alpha=0.3;
    self.musicTable.backgroundView=img;
    [img release];
    self.connList=[[[NSMutableArray alloc] init] autorelease];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"音乐搜索" style:UIBarButtonItemStylePlain target:self action:@selector(showSearchBar)]autorelease];
//    [self searchMusicByMusicName:@"不分手的恋爱"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.musicSearcher=nil;
    self.musicTable=nil;
    self.inputOverLayer=nil;
    self.loadingOverLayer=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//搜索百度歌曲,播放等待动画
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchMusicByMusicName:self.musicSearcher.text];
}

#pragma 表格数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.musicList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"MusicCell";
    MusicCell *cell=(MusicCell *)[self.musicTable dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        NSArray *objlist=[[NSBundle mainBundle] loadNibNamed:@"MusicCell" owner:self options:nil];
        for(id obj in objlist)
        {
            if([obj isKindOfClass:[MusicCell class]])
            {
                cell=(MusicCell *)obj;
            }
        }
    }
    FileModel *fileInfo=[self.musicList objectAtIndex:indexPath.row];
    fileInfo.fileID=[NSString stringWithFormat:@"%d",indexPath.row];//这里设置的不是文件的唯一标示符，是为了在MusicCell点击按钮时获取行号使用
    cell.musicName.text=fileInfo.fileName;
    cell.musicSize.text=fileInfo.fileSize;
    cell.fileInfo=fileInfo;
    if(fileInfo.isP2P)
    {
        [cell.musicDown setTitle:@"P2P" forState:UIControlStateNormal];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

#pragma mark XMLParse

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"%@",parseError);
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElement=elementName;
    if([elementName isEqualToString:@"durl"]||[elementName isEqualToString:@"p2p"])
    {
        self.rootElement=elementName;
        self.currentFile=[[FileModel alloc] init];
        self.currentFile.fileReceivedData=[[[NSMutableData alloc] init] autorelease];
        self.currentFile.fileReceivedSize=@"0";
        self.currentFile.fileID=@"";
        self.currentFile.fileName=self.musicSearcher.text;
        self.currentFile.fileSize=@"未知";
        self.currentFile.fileURL=@"";
        self.currentFile.isDownloading=NO;
        self.currentFile.isP2P=NO;
    }
}

//3种对象URL DURL P2P,
//一般durl没有内容的连接不能用，所以就解析durl
-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    NSString *tmpurl=[[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    if([self.rootElement isEqualToString:@"durl"])
    {
        if([self.currentElement isEqualToString:@"encode"])
        {
            self.currentUrl=tmpurl;
            NSRange range=[self.currentUrl rangeOfString:[self.currentUrl lastPathComponent]];
            self.currentUrl=[self.currentUrl substringToIndex:range.location];
        }
        if([self.currentElement isEqualToString:@"decode"])
        {
            self.currentUrl=[self.currentUrl stringByAppendingString:tmpurl];
        }
        self.currentFile.fileURL=self.currentUrl;
    }
    if([self.rootElement isEqualToString:@"p2p"])
    {
        if([self.currentElement isEqualToString:@"url"])
        {
            self.currentUrl=tmpurl;
            self.currentFile.fileURL=self.currentUrl;
        }
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"durl"]||[elementName isEqualToString:@"p2p"])
    {
        if((![self.currentFile.fileURL isEqualToString:@""])&&self.currentFile.fileURL!=nil)
        {
            [self.musicList addObject:self.currentFile];
        }
        [self.currentFile release];
        self.rootElement=@"";
        self.currentElement=@"";
    }
}

-(void)beginRequest:(ASIHTTPRequest *)request
{
    [request startAsynchronous];
}

//得到可下载音乐地址列表后，对每个下载文件地址进行一次请求，获取每个文件的名字和大小
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    for(FileModel *file in self.musicList)
    {
        if([file.fileSize isEqualToString:@"未知"]||file.fileSize==nil)
        {
            self.isFinished=NO;
            ASIHTTPRequest *urlRequest=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:file.fileURL]];
            [urlRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
            urlRequest.delegate=self;
            [urlRequest setUserInfo:[NSDictionary dictionaryWithObject:file forKey:@"File"]];
            [NSThread detachNewThreadSelector:@selector(beginRequest:) toTarget:self withObject:urlRequest];
            [self.connList addObject:urlRequest];
            while (self.isFinished) 
            {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }
    }
    self.isLoading=NO;
}

-(void)requestReceivedResponseHeaders:(ASIHTTPRequest *)request
{
    NSDictionary *fileInfo=request.userInfo;
    NSString *url=((FileModel *)[fileInfo objectForKey:@"File"]).fileURL;
    for(FileModel *file in self.musicList)
    {
        if([file.fileURL isEqualToString:url])
        {
            file.fileSize=[CommonHelper getFileSizeString:[[request responseHeaders] objectForKey:@"Content-Length"]];
            //把文件名称提取出来,这里返回的文件名称是乱码，用UTF-8和gb2312和网上的其它方法都不行，有的朋友说是文件的问题，文件是在Windows上创建的放到mac下，自动的文件名称就成乱码了，这个真不清楚，我只是提取了文件类型，有明白的朋友告诉我一下哈，谢谢
            NSString *fileName=[[request responseHeaders] objectForKey:@"Content-Disposition"];
            NSInteger firstIndex=[fileName rangeOfString:@"."].location;
            fileName=[fileName substringFromIndex:firstIndex];
            NSInteger lastIndex=[fileName rangeOfString:@"\""].location;
            fileName=[fileName substringToIndex:lastIndex];
            file.fileName=[file.fileName stringByAppendingString:fileName];
            
            file.fileSize=[CommonHelper getFileSizeString:[[request responseHeaders] objectForKey:@"Content-Length"]];
        }
    }
    self.isFinished=YES;
    [self.musicTable reloadData];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"错误%@",[request error]);
}
@end

