//
//  ViewController.m
//  UnitTestDemo
//
//  Created by hechao on 2018/12/27.
//  Copyright © 2018 hechao. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupUI];
    NSString *test = @"test";
    NSNumber *number;
    if (!number) {
        NSLog(@"%@", number);
    }
}

#pragma mark - Actions

- (void)testPush:(UIButton *)sender {
    TestViewController *testVC = [[TestViewController alloc] init];
    [self.navigationController pushViewController:testVC animated:YES];
}

#pragma mark - Private Methods

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmpButton setTitle:@"Push TestVC" forState:UIControlStateNormal];
    [tmpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    tmpButton.bounds = CGRectMake(0, 0, 200, 44);
    tmpButton.center = self.view.center;
    [tmpButton addTarget:self action:@selector(testPush:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tmpButton];
}

@end
