//
//  TestOneViewController.m
//  UnitTestDemo
//
//  Created by hechao on 2018/12/30.
//  Copyright © 2018 hechao. All rights reserved.
//

#import "TestOneViewController.h"

@interface TestOneViewController ()

@end

@implementation TestOneViewController

#pragma mark - LifeCycle

- (void)dealloc {
#if DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Inherit

#pragma mark - Events

#pragma mark - Delegate

#pragma mark - Public Methods

#pragma mark - Private Methods

#pragma mark - XXX //各个独立业务和独立功能的分段

#pragma mark - Properties

@end
