//
//  Currency.h
//  CurrencyApp
//
//  Created by Yerlan Ismailov on 27.07.17.
//  Copyright © 2017 ismailov.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Currency : NSObject<NSCopying>

@property (copy, nonatomic) NSString *baseName;
@property (copy, nonatomic) NSString *currencyName;
@property (strong, nonatomic) NSNumber *price;

@property (copy, nonatomic) NSString *dateUtcStr;
@property (assign, nonatomic) NSNumber *dateTS;
@property (readonly, nonatomic) NSString *dateLocalStr;
@property (nonatomic) BOOL isInterested;



@end
