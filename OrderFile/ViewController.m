//
//  ViewController.m
//  OrderFile
//
//  Created by 58 on 2020/7/6.
//  Copyright © 2020 58. All rights reserved.
//

#import "ViewController.h"
#import "SymbolTools.h"
#import "SSZipArchive.h"
@interface ViewController ()

@end

@implementation ViewController

+(void)load{
    [SSZipArchive isFilePasswordProtectedAtPath:@"root"];
    NSLog(@"打印了+[ViewController load]方法");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   NSString *filePath =  [SymbolTools zz_outPutOrderFilePath];
    NSLog(@"%@",filePath);
}




@end
