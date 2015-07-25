//
//  HJYMainViewController.m
//  MakePdfFile
//
//  Created by JyHu on 14-4-30.
//  Copyright (c) 2014年 JyHu. All rights reserved.
//

#import "HJYMainViewController.h"
#import <CoreText/CoreText.h>
#import "HJYMakePdf.h"
#import "MakePdfFile.h"
#import "HJYPDFViewController.h"

@interface HJYMainViewController ()

- (IBAction)createPDF:(id)sender;

@end

@implementation HJYMainViewController

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"show" style:UIBarButtonItemStyleDone target:self action:@selector(showPDF)];
}

- (void)showPDF
{
    HJYPDFViewController *pdfVC = [[HJYPDFViewController alloc] init];
    pdfVC.pdfName = @"user.pdf";
    [self.navigationController pushViewController:pdfVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createPDF:(id)sender
{
//    [self mypdf];
    [MakePdfFile drawPDFWithIndex:-1];
}

-(NSString*)getPDFFileName
{
    NSString* fileName = @"test.pdf";
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    
    NSLog(@"%@",pdfFileName);
    
    return pdfFileName;
    
}

@end
