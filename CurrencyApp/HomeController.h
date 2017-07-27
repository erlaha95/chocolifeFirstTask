//
//  HomeController.h
//  CurrencyApp
//
//  Created by Yerlan Ismailov on 26.07.17.
//  Copyright © 2017 ismailov.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsVC.h"

@interface HomeController : UIViewController<UITableViewDelegate, UITableViewDataSource, SaveProtocol>

@property (weak, nonatomic) IBOutlet UILabel *alertLabel;


@end
