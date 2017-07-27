//
//  HomeController.m
//  CurrencyApp
//
//  Created by Yerlan Ismailov on 26.07.17.
//  Copyright © 2017 ismailov.com. All rights reserved.
//

#import "HomeController.h"
#import "APIManager.h"
#import "Currency.h"
#import "CurrencyCell.h"
#import "CurrencyApp+CoreDataModel.h"
#import "CurrencyModel+CoreDataClass.h"
#import "CurrencyModel+CoreDataProperties.h"

#import "AppDelegate.h"

@interface HomeController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HomeController {
    NSMutableArray<Currency*> *currencies;
    NSMutableArray<Currency*> *currenciesUsd;
    
    UIBarButtonItem *refreshBarButton;
    Currency *mainCurrency;
    
    NSManagedObjectContext *managedObjectContext;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    managedObjectContext = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CurrencyCell" bundle:nil] forCellReuseIdentifier:@"CurrencyCell"];
    
    
    // load data from CoreData
    [self loadCoreData];
    
    // if nothing was fetched from CoreData
    if (currencies == nil && currenciesUsd == nil) {
        currencies = [[NSMutableArray alloc] init];
        currenciesUsd = [[NSMutableArray alloc] init];
        
        // download data from network
        [self downloadData];
        
    } else {
        
        // check when data was updated
        Currency *cur = [currencies firstObject];
        
        // if  more then 12 hours
        if ([cur.date timeIntervalSinceNow] > 12*60*60) {
            // download data from network
            [self downloadData];
        }
        
    }
    
    [self setupNavBarItems];
    
    
}

-(void)setupNavBarItems {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStylePlain target:self action:@selector(showSettingsVC)];
    
    refreshBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(refreshData)];
    
    self.navigationItem.leftBarButtonItem = refreshBarButton;
}

#pragma mark - Custom methods
-(void) refreshData {
    
    [self downloadData];
    
//    refreshBarButton.customView.transform = CGAffineTransformMakeScale(0, 0);
//    [UIView animateWithDuration:1.0 delay:0.5 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
//        refreshBarButton.customView.transform = CGAffineTransformIdentity;
//    } completion:^(BOOL finished) {
//        
//    }];
    
}

-(void) changeNavBarTitle:(NSString*)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    label.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:30];
    label.textColor = [UIColor whiteColor];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
}

-(void)showSettingsVC {
    
    SettingsVC *vc = [[SettingsVC alloc] init];
    vc.delegate = self;
    vc.currencies = currenciesUsd;
    
    if (mainCurrency == nil) {
        Currency *cur = [Currency new];
        cur.currencyName = [currencies firstObject].baseName;
        cur.baseName = [[currencies firstObject] baseName];
        cur.price = [NSNumber numberWithDouble:1.00000];
        cur.dateUtcStr = [[currencies firstObject] dateUtcStr];
        mainCurrency = cur;
    }
    
    vc.mainCurrency = mainCurrency;
    
    [self showViewController:vc sender:nil];
}

#pragma mark - SaveProtocol methods
-(void)didUpdateMainCurrency:(Currency *)currency updatedCurrencies:(NSArray<Currency *> *)updatedCurrencies {
    
    mainCurrency = currency;
    
    double price = currency.price.doubleValue;
    NSLog(@"price: %f", price);
    
    // with not interested
    currenciesUsd = [updatedCurrencies mutableCopy];
    
    
    NSMutableArray<Currency*> *temp = [[NSMutableArray alloc] init];
    for (int i = 0; i < currenciesUsd.count; i++) {
        if (currenciesUsd[i].isInterested) {
            Currency *cur = [Currency new];
            cur.price = [NSNumber numberWithDouble:price/currenciesUsd[i].price.doubleValue];
            cur.currencyName = currenciesUsd[i].currencyName;
            cur.baseName = currenciesUsd[i].baseName;
            cur.dateUtcStr = currenciesUsd[i].dateUtcStr;
            
            [temp addObject:cur];
        }
        
    }
    
    currencies = [temp mutableCopy];
    
    [self.tableView setContentOffset:CGPointZero animated:YES];
    [self changeNavBarTitle:currency.currencyName];

    [self.tableView reloadData];
}



#pragma mark - Networking
-(void)downloadData {
    [[APIManager sharedManager] downloadCurrencyExchangeRate:nil andSuccess:^(id response) {
        
        //NSLog(@"Response: %@", response);
        NSArray *resources = response[@"list"][@"resources"];
        
        NSMutableArray *tempCurrenciesArr = [NSMutableArray new];
        for (NSDictionary *item in resources) {
            
            NSDictionary *resource = item[@"resource"];
            NSDictionary *fields = resource[@"fields"];
            NSString *name = fields[@"name"];
            NSArray *chunk = [name componentsSeparatedByString:@"/"];
            
            if (chunk.count > 1) {
                Currency *currency = [[Currency alloc] initWithDictionary:fields];
                
                [self saveInCoreDataObject:currency];
                
                [tempCurrenciesArr addObject:currency];
            }
            
        }
        
        currencies = tempCurrenciesArr;
        currenciesUsd = [[NSMutableArray alloc] initWithArray:tempCurrenciesArr];
        
        [self changeNavBarTitle:currencies[0].baseName];
        
        self.alertLabel.hidden = YES;
        [self.tableView reloadData];
        
    } andFailure:^(NSError *error) {
        
        self.alertLabel.hidden = NO;
        NSLog(@"ERROR: %@", error.debugDescription);
        
    }];

}

#pragma mark - CoreData manipulating methods
-(void)saveInCoreDataObject:(Currency*)currency {
    CurrencyModel *model = [[CurrencyModel alloc] initWithContext:managedObjectContext];
    model.base = currency.baseName;
    model.name = currency.currencyName;
    model.price = currency.price.doubleValue;
    model.lastUpdate = currency.dateUtcStr;
    model.isInterested = currency.isInterested;
    
    @try {
        
        NSError *error = nil;
        [managedObjectContext save:&error];
    } @catch (NSException *exception) {
        NSLog(@"Saving in CoreData - Eception: %@", exception.debugDescription);
    }
    
}

-(void)loadCoreData {
    
    NSFetchRequest<CurrencyModel*> *currencyRequest = [CurrencyModel fetchRequest];
    
    @try {
        
        NSError *error = nil;
        NSArray<CurrencyModel*> *currencyModelArray = [managedObjectContext executeFetchRequest:currencyRequest error:&error];
        
        NSMutableArray<Currency*> *tempArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < currencyModelArray.count; i ++) {
            
            Currency *currency = [[Currency alloc] init];
            currency.baseName = currencyModelArray[i].base;
            currency.currencyName = currencyModelArray[i].name;
            currency.price = [NSNumber numberWithDouble:currencyModelArray[i].price];
            currency.dateUtcStr = currencyModelArray[i].lastUpdate;
            currency.isInterested = currencyModelArray[i].isInterested;
            
            [tempArr addObject:currency];
        }
        
        currenciesUsd = [[NSMutableArray alloc] initWithArray:tempArr];
        currencies = [[NSMutableArray alloc] initWithArray:tempArr];
        
    } @catch (NSException *exception) {
        
        NSLog(@"CoreData - failed to fetch: %@", exception.debugDescription);
        
    }
    
}

#pragma mark - UITableViewDataSource methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return currencies.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CurrencyCell *cell  = [self.tableView dequeueReusableCellWithIdentifier:@"CurrencyCell"];
    
    [cell configureCell:currencies[indexPath.row]];
    
    return cell;
}

@end
