//
//  ViewController.m
//  HandelXMLFile
//
//  Created by YXT on 2017/1/9.
//  Copyright © 2017年 YXT. All rights reserved.
//

#import "ViewController.h"
#import "XMLManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [XMLManager xmlAnalysis:^(NSString *filePath) {
       
        NSArray *a = [NSArray arrayWithContentsOfFile:filePath];
        NSLog(@"%@",a);
    }];
}


@end
