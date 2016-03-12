//
//  NextViewController.m
//  Practise_KVO
//
//  Created by Claris on 2016.03.12.Saturday.
//  Copyright © 2016 tickCoder. All rights reserved.
//

#import "NextViewController.h"
#import "UserManager.h"

@interface NextViewController ()
@property (weak, nonatomic) IBOutlet UILabel *useridLabel;
- (IBAction)randomBtnAction:(id)sender;
@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _useridLabel.text = [NSString stringWithFormat:@"%@'s userid is %ld", [[UserManager sharedInstance] username], (long)[UserManager sharedInstance].userid];
    [[UserManager sharedInstance] addObserver:self forKeyPath:@"userid" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)randomBtnAction:(id)sender {
    NSInteger randomPIN = (NSInteger)arc4random();
    [UserManager sharedInstance].userid = randomPIN;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"userid"] && object == [UserManager sharedInstance]) {
        _useridLabel.text = [NSString stringWithFormat:@"%@'s userid is %ld", [[UserManager sharedInstance] username], (long)[UserManager sharedInstance].userid];
    }
}

@end
