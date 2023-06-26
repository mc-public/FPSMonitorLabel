//
//  Header.h
//  
//
//  Created by 12345CPZ on 2023/6/26.
//

#ifndef WEAKPROXY
#define WEAKPROXY

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeakProxy : NSProxy

@property (nonatomic, weak, readonly,nullable) id target;

- (instancetype)initWithTarget:(id)target;

+ (instancetype)proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END


#endif /* WEAKPROXY */
