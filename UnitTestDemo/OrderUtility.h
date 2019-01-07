//
//  OrderUntility.h
//  UnitTestDemo
//
//  Created by hechao on 2018/12/27.
//  Copyright © 2018 hechao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderUtility : NSObject

/**
 格式化的金额字符串，小数点后最后位或者最后两位均为0，就去掉0 eg 1.00 -- 1 1.20 -- 1.2

 @param payAmount 金额
 @return 格式化的金额字符串
 */
+ (NSString *)convertToFormatedStringFromPayAmount:(nullable NSDecimalNumber *)payAmount;

/**
 计算应支付金额

 @param price 商品价格
 @return 支付金额
 */
+ (NSDecimalNumber *)calculatePayAmountWithPrice:(nullable NSDecimalNumber *)price;

+ (void)fetchConfigInfoCompletedBlock:(void (^)(NSDictionary *configs))completedBlock;

- (void)fetchOrderConfigInfoCompletedBlock:(void (^)(NSDictionary *configs))completedBlock;

@end

NS_ASSUME_NONNULL_END
