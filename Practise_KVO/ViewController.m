//
//  ViewController.m
//  Practise_KVO
//
//  Created by Claris on 2016.03.12.Saturday.
//  Copyright © 2016 tickCoder. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "NextViewController.h"
#import "UserManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *personInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *useridLabel;
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
    _useridLabel.text = [NSString stringWithFormat:@"%@'s userid is %ld", [[UserManager sharedInstance] username], (long)[UserManager sharedInstance].userid];
    
    [[UserManager sharedInstance] addObserver:self forKeyPath:@"userid" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    /*
     remove不能多次，所以要确保super没有作此操作，可以在context中作区分，比如使用唯一标识符
     You should use -removeObserver:forKeyPath:context: instead of -removeObserver:forKeyPath: whenever possible because it allows you to more precisely specify your intent. When the same observer is registered for the same key path multiple times, but with different context pointers each time, -removeObserver:forKeyPath: has to guess at the context pointer when deciding what exactly to remove, and it can guess wrong.
     */
    [[UserManager sharedInstance] removeObserver:self forKeyPath:@"userid" context:nil];
    [_person removeObserver:self forKeyPath:@"PIN" context:nil];
}

- (IBAction)randomBtnAction:(id)sender {
    NSInteger randomPIN = (NSInteger)arc4random();
    _person.PIN = randomPIN;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"PIN"] && object == _person) {
        _personInfoLabel.text = [NSString stringWithFormat:@"%@'s PIN is %ld", _person.name, (long)_person.PIN];
    } else if ([keyPath isEqualToString:@"userid"] && object == [UserManager sharedInstance]) {
        _useridLabel.text = [NSString stringWithFormat:@"%@'s userid is %ld", [[UserManager sharedInstance] username], (long)[UserManager sharedInstance].userid];
    } else {
        // 若当前类无法捕捉到这个KVO，那很有可能他的super中有，若无此则会截断KVO，造成其super异常
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end
