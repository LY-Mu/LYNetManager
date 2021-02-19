//
//  LYNetFormRequest.h
//  Example
//
//  Created by mu on 2021/2/19.
//  Copyright © 2021 babo. All rights reserved.
//

#import "LYNetManager.h"

@interface LYNetFormRequest : LYNetManager

+ (LYURLSessionTask *)ly_formGet:(NSString *)url parameters:(NSDictionary *)params headers:(NSDictionary *)headers successBlock:(LYResponseSuccessBlock)successBlock
      failureBlock:(LYResponseFailBlock)failureBlock;

+ (LYURLSessionTask *)ly_formPost:(NSString *)url parameters:(NSDictionary *)params headers:(NSDictionary *)headers successBlock:(LYResponseSuccessBlock)successBlock
       failureBlock:(LYResponseFailBlock)failureBlock;

@end

