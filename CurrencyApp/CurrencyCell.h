//
//  CurrencyCell.h
//  CurrencyApp
//
//  Created by Yerlan Ismailov on 27.07.17.
//  Copyright © 2017 ismailov.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Currency.h"

@interface CurrencyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

-(void)configureCell:(Currency*)currency;

@end
