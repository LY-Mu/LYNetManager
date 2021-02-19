//
//  LYNetManager+Form.h
//  Example
//
//  Created by mu on 2021/2/19.
//  Copyright © 2021 babo. All rights reserved.
//

#import "LYNetManager.h"

/// 此类请求头是 表单提交
@interface LYNetManager (Form)

+ (LYURLSessionTask *)ly_formGet:(NSString *)url parameters:(NSDictionary *)params headers:(NSDictionary *)headers successBlock:(LYResponseSuccessBlock)successBlock
      failureBlock:(LYResponseFailBlock)failureBlock;

+ (LYURLSessionTask *)ly_formPost:(NSString *)url parameters:(NSDictionary *)params headers:(NSDictionary *)headers successBlock:(LYResponseSuccessBlock)successBlock
       failureBlock:(LYResponseFailBlock)failureBlock;


@end
