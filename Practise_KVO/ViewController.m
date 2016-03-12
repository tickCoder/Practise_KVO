//
//  ViewController.m
//  Practise_KVO
//
//  Created by Claris on 2016.03.12.Saturday.
//  Copyright © 2016 tickCoder. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *personInfoLabel;
- (IBAction)randomBtnAction:(id)sender;
@property (nonatomic, strong) Person *person;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _person = [[Person alloc] init];
    _person.name = @"jack";
    _person.PIN = 1;
    
    [_person addObserver:self forKeyPath:@"PIN" options:NSKeyValueObservingOptionNew context:nil];
    
    _personInfoLabel.text = [NSString stringWithFormat:@"%@'s PIN is %ld", _person.name, (long)_person.PIN];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)randomBtnAction:(id)sender {
    NSInteger randomPIN = arc4random();
    _person.PIN = randomPIN;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"PIN"] && object == _person) {
        _personInfoLabel.text = [NSString stringWithFormat:@"%@'s PIN is %ld", _person.name, (long)_person.PIN];
    }
}
@end
