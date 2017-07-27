//
//  SettingsVC.m
//  CurrencyApp
//
//  Created by Yerlan Ismailov on 27.07.17.
//  Copyright © 2017 ismailov.com. All rights reserved.
//

#import "SettingsVC.h"
#import "CurrencySettingsCell.h"

@interface SettingsVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingsVC

-(instancetype)init {
    if (self) {
        self = [super initWithNibName:@"SettingsVC" bundle:nil];
        
    }
    
    return self;
}

- (IBAction)saveBtnTapped:(id)sender {
    
    if (self.mainCurrency != nil) {
        [self.delegate didUpdateMainCurrency:self.mainCurrency updatedCurrencies:self.currencies];
    }
    
//    [self.delegate didUpdateCurrenciesInterest:self.currencies];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.title = @"Настройки";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CurrencySettingsCell" bundle:nil] forCellReuseIdentifier:@"CurrencySettingsCell"];
    
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.currencies[indexPath.row].isInterested) {
        CurrencySettingsCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.switchInterest.on = YES;
        
    }
    
    self.mainCurrency= self.currencies[indexPath.row];
    self.mainCurrency.baseName = self.currencies[indexPath.row].currencyName;
    
    [self.tableView reloadData];
    
    NSLog(@"didSelect %@. Price: %@", self.mainCurrency.currencyName, self.mainCurrency.price);
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CurrencySettingsCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currencies.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CurrencySettingsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CurrencySettingsCell"];
    
    cell.currencyNameLabel.text = self.currencies[indexPath.row].currencyName;
    cell.switchInterest.on = self.currencies[indexPath.row].isInterested;
    cell.switchInterest.tag = indexPath.row;
    [cell.switchInterest addTarget:self action:@selector(didChangeInterest:) forControlEvents:UIControlEventValueChanged];
    
    if ([self.currencies[indexPath.row].currencyName isEqualToString:self.mainCurrency.currencyName]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)didChangeInterest:(UISwitch*)sender {
    Currency *cur = self.currencies[sender.tag];
    cur.isInterested = sender.isOn;
    [self.currencies replaceObjectAtIndex:sender.tag withObject:cur];
}

@end
