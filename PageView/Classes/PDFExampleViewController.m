    //
//  PDFExampleViewController.m
//  Leaves
//
//  Created by Tom Brow on 4/19/10.
//  Copyright 2010 Tom Brow. All rights reserved.
//

#import "PDFExampleViewController.h"
#import "Utilities.h"
#import "CommonHelper.h"


@implementation PDFExampleViewController
- (id)init:(NSString*)fileName
{
    if (self = [super init]) {        
        CFURLRef url = (CFURLRef)[NSURL fileURLWithPath:fileName];
		pdf = CGPDFDocumentCreateWithURL((CFURLRef)url);
    }
    return self;
}
- (id)init {
    if (self = [super init]) {
		//CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("paper.pdf"), NULL, NULL);
		//pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
		//CFRelease(pdfURL);
    }
    return self;
}

- (void)dealloc {
	CGPDFDocumentRelease(pdf);
    [super dealloc];
}

- (void) displayPageNumber:(NSUInteger)pageNumber {
	self.navigationItem.title = [NSString stringWithFormat:
								 @"Page %u of %u", 
								 pageNumber, 
								 CGPDFDocumentGetNumberOfPages(pdf)];
}

#pragma mark  LeavesViewDelegate methods

- (void) leavesView:(LeavesView *)leavesView willTurnToPageAtIndex:(NSUInteger)pageIndex {
	[self displayPageNumber:pageIndex + 1];
}

#pragma mark LeavesViewDataSource methods

- (NSUInteger) numberOfPagesInLeavesView:(LeavesView*)leavesView {
	return CGPDFDocumentGetNumberOfPages(pdf);
}

- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx {
	CGPDFPageRef page = CGPDFDocumentGetPage(pdf, index + 1);
	CGAffineTransform transform = aspectFit(CGPDFPageGetBoxRect(page, kCGPDFMediaBox),
											CGContextGetClipBoundingBox(ctx));
	CGContextConcatCTM(ctx, transform);
	CGContextDrawPDFPage(ctx, page);
}

#pragma mark UIViewController
-(void)loadView
{
    [super loadView];
    NSString* fileName = self.title;
    if(!fileName || fileName.length == 0)
    {
        CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("paper.pdf"), NULL, NULL);
		pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
		CFRelease(pdfURL);
    }
    else
    {
        NSString* filePath = [[CommonHelper getTargetFolderPath]stringByAppendingPathComponent:fileName];
        CFURLRef url = (CFURLRef)[NSURL fileURLWithPath:filePath];
        pdf = CGPDFDocumentCreateWithURL((CFURLRef)url);
    }

}

- (void) viewDidLoad {
	[super viewDidLoad];
        
	leavesView.backgroundRendering = YES;
	[self displayPageNumber:1];
}

@end
