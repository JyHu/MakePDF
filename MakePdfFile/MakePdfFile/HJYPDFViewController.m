//
//  HJYPDFViewController.m
//  MakePdfFile
//
//  Created by JyHu on 14-5-5.
//  Copyright (c) 2014年 JyHu. All rights reserved.
//

#import "HJYPDFViewController.h"

@interface HJYPDFViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *pdfWeb;

@end

@implementation HJYPDFViewController

@synthesize pdfName = _pdfName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"refresh" style:UIBarButtonItemStyleDone target:self action:@selector(showPDF)];
}

- (void)showPDF
{
    NSString* fileName = _pdfName;
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    
    
    NSURL *url = [NSURL fileURLWithPath:pdfFileName];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_pdfWeb setScalesPageToFit:YES];
    [_pdfWeb loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
