//
//  LYNetProtobufRequest.h
//  Example
//
//  Created by mu on 2021/2/19.
//  Copyright © 2021 babo. All rights reserved.
//

#import "LYNetManager.h"

@interface LYNetProtobufRequest : LYNetManager

+ (LYURLSessionTask *)ly_protobufGet:(NSString *)url parameters:(NSDictionary *)params headers:(NSDictionary *)headers successBlock:(LYResponseSuccessBlock)successBlock
      failureBlock:(LYResponseFailBlock)failureBlock;

+ (LYURLSessionTask *)ly_protobufPost:(NSString *)url parameters:(NSDictionary *)params headers:(NSDictionary *)headers successBlock:(LYResponseSuccessBlock)successBlock
       failureBlock:(LYResponseFailBlock)failureBlock;

@end

