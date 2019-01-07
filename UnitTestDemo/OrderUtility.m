//
//  OrderUntility.m
//  UnitTestDemo
//
//  Created by hechao on 2018/12/27.
//  Copyright © 2018 hechao. All rights reserved.
//

#import "OrderUtility.h"
#import "CouponUtility.h"

@implementation OrderUtility

+ (NSString *)convertToFormatedStringFromPayAmount:(NSDecimalNumber *)payAmount {
    if (!payAmount) {
        return @"--";
    }
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundDown
                                       scale:2
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    
    NSDecimalNumber *formatedAmountNumber = [payAmount decimalNumberByRoundingAccordingToBehavior:roundUp];
    return formatedAmountNumber.stringValue;
}

+ (NSDecimalNumber *)calculatePayAmountWithPrice:(NSDecimalNumber *)price {
    if (price == nil || [price doubleValue] == 0) {
        return nil;
    }
    
    NSDecimalNumber *couponNumber = [CouponUtility fetchAvaiableCoupon];
    NSDecimalNumber *payAmount = price;
    if ([couponNumber doubleValue]) {
        payAmount = [price decimalNumberBySubtracting:couponNumber];
    }
    
    return payAmount;
}

+ (void)fetchConfigInfoCompletedBlock:(void (^)(NSDictionary *configs))completedBlock{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 模拟网络请求3秒返回数据
        if (completedBlock) {
            completedBlock(@{});
        }
    });
}

- (void)fetchOrderConfigInfoCompletedBlock:(void (^)(NSDictionary *configs))completedBlock {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 模拟网络请求3秒返回数据
        if (completedBlock) {
            completedBlock(@{});
        }
    });
}

@end
