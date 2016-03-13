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
    
    /*
     注册通知
     
     observer:观察者，也就是KVO通知的订阅者。订阅着必须实现
     observeValueForKeyPath:ofObject:change:context:方法 keyPath：描述将要观察的属性，相对于被观察者。 options：KVO的一些属性配置；有四个选项。 context: 上下文，这个会传递到订阅着的函数中，用来区分消息，所以应当是不同的。
     options所包括的内容
     
     NSKeyValueObservingOptionNew：change字典包括改变后的值 NSKeyValueObservingOptionOld:change字典包括改变前的值 NSKeyValueObservingOptionInitial:注册后立刻触发KVO通知 NSKeyValueObservingOptionPrior:值改变前是否也要通知（这个key决定了是否在改变前改变后通知两次）
     */
    [[UserManager sharedInstance] addObserver:self forKeyPath:@"userid" options:NSKeyValueObservingOptionNew context:nil];
    
    [[UserManager sharedInstance] addObserver:self forKeyPath:@"person.PIN" options:NSKeyValueObservingOptionNew context:nil];
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
    
    /*
     一般在remove的时候会这么写，因为remove的时候，无法判读啊remove是否成功了
     @try {
        [object removeObserver:self forKeyPath:keyPath];
     }
     @catch (NSException *exception) {
        NSLog(@%@,exception);
     }
     */
    [[UserManager sharedInstance] removeObserver:self forKeyPath:@"userid" context:nil];
    [_person removeObserver:self forKeyPath:@"PIN" context:nil];
}

- (IBAction)randomBtnAction:(id)sender {
    NSInteger randomPIN = (NSInteger)arc4random();
    _person.PIN = randomPIN;
    
    [UserManager sharedInstance].person.PIN = (NSInteger)arc4random();
    
    [UserManager sharedInstance].userid = (NSInteger)arc4random();// -1
    NSLog(@"%ld", (long)[UserManager sharedInstance].userid);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"PIN"] && object == _person) {
        _personInfoLabel.text = [NSString stringWithFormat:@"%@'s PIN is %ld", _person.name, (long)_person.PIN];
    } else if ([keyPath isEqualToString:@"userid"] && object == [UserManager sharedInstance]) {
        _useridLabel.text = [NSString stringWithFormat:@"%@'s userid is %ld", [[UserManager sharedInstance] username], (long)[UserManager sharedInstance].userid];
    } else if ([keyPath isEqualToString:@"person.PIN"] && object == [UserManager sharedInstance]) {
        _useridLabel.text = [NSString stringWithFormat:@"%ld", (long)[UserManager sharedInstance].person.PIN];
    } else {
        // 若当前类无法捕捉到这个KVO，那很有可能他的super中有，若无此则会截断KVO，造成其super异常
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
    [change objectForKey:NSKeyValueChangeKindKey];
}
@end
