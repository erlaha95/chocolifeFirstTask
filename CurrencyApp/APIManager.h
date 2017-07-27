//
//  APIManager.h
//  CurrencyApp
//
//  Created by Yerlan Ismailov on 26.07.17.
//  Copyright © 2017 ismailov.com. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface APIManager : NSObject

+ (id)sharedManager;


#pragma mark endpoints

@property BOOL hasAuthHeader;


- (void)downloadCurrencyExchangeRate:(NSDictionary *)params andSuccess:(void (^)(id response))success andFailure:(void (^)(NSError *error))failure;




@end
