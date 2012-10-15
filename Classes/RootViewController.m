//
//  RootViewController.m
//  @rigoneri
//  
//  Copyright 2010 Rodrigo Neri
//  Copyright 2011 David Jarrett
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "RootViewController.h"
#import "MyLauncherItem.h"
#import "CustomBadge.h"
#import "ExamplesViewController.h"
#import "BaiduMusicViewController.h"
#import "DownloadViewController.h"
#import "PDFExampleViewController.h"
#import "LatestBooks.h"
#import "Tree.h"

@implementation RootViewController

-(void)loadView
{    
	[super loadView];
    self.title = @"Bookworm";
    
    //Add your view controllers here to be picked up by the launcher; remember to import them above       
    [[self appControllers] setObject:[ExamplesViewController class] forKey:@"ExamplesViewController"];
    [[self appControllers] setObject:[PDFExampleViewController class] forKey:@"PDFExampleViewController"];
   
    LatestBooks* latestBooks = [LatestBooks shareInstance];
    //API doc
    //title for book's title
    //iPhoneImage/iPadImage for image of this book
    //targetTitle:for book's name,find the book in the library(file name)
    //deletable:this item is deletable or not
	if([latestBooks countOfBooks]>0)
	{
        NSMutableArray* books = [[NSMutableArray alloc]init];
        for (NSInteger i = 0; i < [latestBooks countOfBooks]; ++i) {            
            Tree* item = [latestBooks bookInfo:i];
            [books addObject:[[MyLauncherItem alloc] initWithTitle:item.name
                 iPhoneImage:item.image
                   iPadImage:item.image
                      target:@"ExamplesViewController"
                 targetTitle:item.filename
                   deletable:YES]];
        }        
        [self.launcherView setPages:books singleArray:YES];
        [books release];
//		[self.launcherView setPages:[[NSMutableArray alloc ]initWithObjects:
//                                     [[NSMutableArray alloc ]initWithObjects:
//                                      [[MyLauncherItem alloc] initWithTitle:@"Item 1"
//                                                                 iPhoneImage:@"itemImage" 
//                                                                   iPadImage:@"itemImage-iPad"
//                                                                      target:@"ExamplesViewController"
//                                                                 targetTitle:@"Item 1 View"
//                                                                   deletable:YES],
//                                      nil],
//                                      nil]];
        
        
        // Set number of immovable items below; only set it when you are setting the pages as the 
        // user may still be able to delete these items and setting this then will cause movable 
        // items to become immovable.
        // [self.launcherView setNumberOfImmovableItems:1];
        
        // Or uncomment the line below to disable editing (moving/deleting) completely!
        // [self.launcherView setEditingAllowed:NO];
	}
    
    // Set badge text for a MyLauncherItem using it's setBadgeText: method
    [(MyLauncherItem *)[[[self.launcherView pages] objectAtIndex:0] objectAtIndex:0] setBadgeText:@"4"];
    
    // Alternatively, you can import CustomBadge.h as above and setCustomBadge: as below.
    // This will allow you to change colors, set scale, and remove the shine and/or frame.
    //[(MyLauncherItem *)[[[self.launcherView pages] objectAtIndex:0] objectAtIndex:1] setCustomBadge:[CustomBadge customBadgeWithString:@"2" withStringColor:[UIColor blackColor] withInsetColor:[UIColor whiteColor] withBadgeFrame:YES withBadgeFrameColor:[UIColor blackColor] withScale:0.8 withShining:NO]];
    
    //[(MyLauncherItem *)[[[self.launcherView pages] objectAtIndex:0] objectAtIndex:0] setCustomBadge:[CustomBadge customBadgeWithString:@"6" withStringColor:[UIColor whiteColor] withInsetColor:[UIColor redColor] withBadgeFrame:YES withBadgeFrameColor:[UIColor whiteColor] withScale:1 withShining:NO]];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(FileDownloadSuccess:) name:kFileDownloadSuccess object:nil];
}
-(void)FileDownloadSuccess:(NSNotification *)notification
{
    if (notification) {
      FileModel* fileModel =  (FileModel*)notification.object;
        if (fileModel) {
            NSMutableArray * items = [[NSMutableArray alloc]initWithObjects:[[MyLauncherItem alloc] initWithTitle:@"Item x"
                                                                                                      iPhoneImage:@"itemImage"
                                                                                                        iPadImage:@"itemImage-iPad"
                                                                                                           target:@"PDFExampleViewController"
                                                                                                      targetTitle:fileModel.fileName
                                                                                                        deletable:YES], nil];
            [self.launcherView addPages:items refreshhRightNow:YES];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	//If you don't want to support multiple orientations uncomment the line below
    //return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
	return [super shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}
- (void)viewDidLoad
{    
    UIBarButtonItem* newButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Download",@"") style: UIBarButtonItemStyleBordered target: self action: @selector(openDownload)];
    [[self navigationItem] setLeftBarButtonItem:newButton];
    [newButton release];

    
	// "Segmented" control to the right
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
                                            [NSArray arrayWithObjects:
                                             [UIImage imageNamed:@"up.png"],
                                             [UIImage imageNamed:@"down.png"],
                                             nil]];
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.frame = CGRectMake(0, 0, 90, 30.0);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.momentary = YES;
	   
	UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    [segmentedControl release];
    
	self.navigationItem.rightBarButtonItem = segmentBarItem;
    [segmentBarItem release];
}
- (IBAction)segmentAction:(id)sender
{
#define kOnlineStore 1
	// The segmented control was clicked, handle it here
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	NSLog(@"Segment clicked: %d", segmentedControl.selectedSegmentIndex);
    if(segmentedControl.selectedSegmentIndex == kOnlineStore)
    {
        [self openOnlineStore];
    }
}
-(IBAction)openOnlineStore
{
    UIViewController* controller = [[BaiduMusicViewController alloc]initWithNibName:@"BaiduMusicViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}
-(IBAction)openDownload
{
    UIViewController* controller = [[DownloadViewController alloc]initWithNibName:@"DownloadViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}
- (void)viewDidUnload 
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
