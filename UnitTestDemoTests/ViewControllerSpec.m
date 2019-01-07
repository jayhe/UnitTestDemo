//
//  ViewControllerSpec.m
//  UnitTestDemo
//
//  Created by hechao on 2018/12/27.
//  Copyright 2018 hechao. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "ViewController.h"
#import "TestViewController.h"


SPEC_BEGIN(ViewControllerSpec)

describe(@"ViewController", ^{
    // UI测试
    context(@"Test Push", ^{
        it(@"should push to TestVC", ^{
            ViewController *vc = [[ViewController alloc] init];
            UINavigationController *mockNavController = [UINavigationController mock];
            [vc stub:@selector(navigationController) andReturn:mockNavController];
            
            [[mockNavController should] receive:@selector(pushViewController:animated:)];
            KWCaptureSpy *spy = [mockNavController captureArgument:@selector(pushViewController:animated:) atIndex:0];
            [vc testPush:nil];
            id obj = spy.argument;
            TestViewController *testVC = obj;
            [[testVC should] beKindOfClass:[TestViewController class]];
        });
    });
});

SPEC_END
