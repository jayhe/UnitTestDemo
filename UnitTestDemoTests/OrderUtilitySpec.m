//
//  OrderUtilitySpec.m
//  UnitTestDemo
//
//  Created by hechao on 2018/12/27.
//  Copyright 2018 hechao. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OrderUtility.h"
#import "CouponUtility.h"

SPEC_BEGIN(OrderUtilitySpec)

describe(@"OrderUtility", ^{
    __block NSString *formatedAmountString;
    __block NSDecimalNumber *payAmount;
    __block NSDecimalNumber *price;
    beforeAll(^{
        
    });
    beforeEach(^{
//        [CouponUtility stub:@selector(fetchAvaiableCoupon) andReturn:[NSDecimalNumber decimalNumberWithString:@"5.00"]];
    });
    afterAll(^{
        
    });
    afterEach(^{
        formatedAmountString = nil;
        payAmount = nil;
        price = nil;
    });
    
    //测试功能函数的各个分支
    context(@"convertToFormatedStringFromPayAmount", ^{
        it(@"payAmount is nil,,then formatedAmountString should be --", ^{
            formatedAmountString = [OrderUtility convertToFormatedStringFromPayAmount:nil];
            [[formatedAmountString should] equal:@"--"];
        });
        it(@"payAmount is 2.01,then formatedAmountString should be 2.01", ^{
            payAmount = [NSDecimalNumber decimalNumberWithString:@"2.01"];
            formatedAmountString = [OrderUtility convertToFormatedStringFromPayAmount:payAmount];
            [[formatedAmountString should] equal:@"2.01"];
        });
        it(@"payAmount is 2.10,then formatedAmountString should be 2.1", ^{
            payAmount = [NSDecimalNumber decimalNumberWithString:@"2.10"];
            formatedAmountString = [OrderUtility convertToFormatedStringFromPayAmount:payAmount];
            [[formatedAmountString should] equal:@"2.1"];
        });
        it(@"payAmount is 2.00,then formatedAmountString should be 2", ^{
            payAmount = [NSDecimalNumber decimalNumberWithString:@"2.00"];
            formatedAmountString = [OrderUtility convertToFormatedStringFromPayAmount:payAmount];
            [[formatedAmountString should] equal:@"2"];
        });
    });
    
    // 测试stub函数的返回：当单测依赖其他的外部变化的时候
    context(@"calculatePayAmountWithPrice", ^{
        it(@"price is 25 and coupon is 5,then repayAmount should be 20", ^{
            // stub函数只生效一次，it执行完后就清除了，如果想在context的每个it都生效可以将stub写在beforeEach中
            [CouponUtility stub:@selector(fetchAvaiableCoupon) andReturn:[NSDecimalNumber decimalNumberWithString:@"5.00"]];
            price = [NSDecimalNumber decimalNumberWithString:@"25.00"];
            NSDecimalNumber *repayAmount = [OrderUtility calculatePayAmountWithPrice:price];
            [[repayAmount should] equal:[NSDecimalNumber decimalNumberWithString:@"20.00"]];
        });
        it(@"price is 35,then repayAmount should be 20", ^{
            price = [NSDecimalNumber decimalNumberWithString:@"35.00"];
            NSDecimalNumber *repayAmount = [OrderUtility calculatePayAmountWithPrice:price];
            [[repayAmount should] equal:[NSDecimalNumber decimalNumberWithString:@"35.00"]];
        });
    });
    
    // 异步测试：耗时操作，接口测试，异步返回的情况
    context(@"fetchConfigInfoCompletedBlock", ^{
        it(@"configs should not be nil", ^{
            __block NSDictionary *tmpConfigs;
            [OrderUtility fetchConfigInfoCompletedBlock:^(NSDictionary * _Nonnull configs) {
                tmpConfigs = configs;
            }];
            [[expectFutureValue(tmpConfigs) shouldNotAfterWaitOf(5)] beNil];
        });
        // 未实现的测试用例，会输出一条log
        pending_(@"configs dueDate should not be nil", ^{
            
        });
    });
});

SPEC_END












