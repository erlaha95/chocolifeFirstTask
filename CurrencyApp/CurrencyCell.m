//
//  CurrencyCell.m
//  CurrencyApp
//
//  Created by Yerlan Ismailov on 27.07.17.
//  Copyright © 2017 ismailov.com. All rights reserved.
//

#import "CurrencyCell.h"

@implementation CurrencyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


-(void)configureCell:(Currency*)currency {
    
    self.currencyNameLabel.text = currency.currencyName;
    self.priceLabel.text = [NSString stringWithFormat:@"%.02f", currency.price.floatValue];
}



@end
