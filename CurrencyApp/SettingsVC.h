//
//  SettingsVC.h
//  CurrencyApp
//
//  Created by Yerlan Ismailov on 27.07.17.
//  Copyright © 2017 ismailov.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Currency.h"

@protocol SaveProtocol <NSObject>

@required
-(void)didUpdateMainCurrency:(Currency*)currency updatedCurrencies:(NSArray<Currency*>*)updatedCurrencies;

//@required
//-(void)didUpdateCurrenciesInterest:(NSArray<Currency*>*)updatedCurrencies;

@end


@interface SettingsVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray<Currency*> *currencies;
@property (nonatomic) id <SaveProtocol> delegate;
@property (copy, nonatomic) Currency *mainCurrency;

@end
