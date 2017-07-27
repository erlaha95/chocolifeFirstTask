//
//  Currency.m
//  CurrencyApp
//
//  Created by Yerlan Ismailov on 27.07.17.
//  Copyright © 2017 ismailov.com. All rights reserved.
//

#import "Currency.h"

@implementation Currency

-(id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        [copy setBaseName:[self.baseName copyWithZone:zone]];
        [copy setCurrencyName:[self.currencyName copyWithZone:zone]];
        [copy setDateUtcStr:[self.dateUtcStr copyWithZone:zone]];
        [copy setPrice:[self.price copyWithZone:zone]];
        [copy setDateUtcStr:[self.dateUtcStr copyWithZone:zone]];
    }
    
    return copy;
}

-(instancetype)init {
    if (self) {
        self = [super init];
        
        self.isInterested = YES;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        
        //NSDictionary *fields = dictionary[@"fields"];
        NSString *name = dictionary[@"name"];
        NSArray *chunk = [name componentsSeparatedByString:@"/"];
        self.isInterested = YES;
        self.baseName = chunk.firstObject;
        self.currencyName = chunk[1];
        self.price = dictionary[@"price"];
        self.dateTS = dictionary[@"ts"];
        self.dateUtcStr = dictionary[@"utctime"];
    
        
    }
    return self;
}

-(NSString *)dateLocalStr {
    //NSDate *utcDate = [NSDate dateWithTimeIntervalSince1970:self.dateTS.integerValue];
    NSDateFormatter *utcDateFormatter = [[NSDateFormatter alloc] init];
    [utcDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *utcDate = [utcDateFormatter dateFromString:self.dateUtcStr];
    
    NSDateFormatter *localDateFormatter = [NSDateFormatter new];
    [localDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [localDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [localDateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *localDateStr = [localDateFormatter stringFromDate:utcDate];
    
    return localDateStr;
}

-(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    return [dateFormatter dateFromString:self.dateLocalStr];
    
}

@end
