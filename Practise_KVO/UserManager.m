//
//  UserManager.m
//  Practise_KVO
//
//  Created by Claris on 2016.03.12.Saturday.
//  Copyright © 2016 tickCoder. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager
+ (instancetype)sharedInstance {
    static UserManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.userid = 0;
        self.username = @"lucy";
        self.person = [[Person alloc] init];
        self.person.name = @"instance";
        self.person.PIN = 111;
    }
    return self;
}


+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    return YES;
}

+ (BOOL)automaticallyNotifiesObserversOfPerson {
    return YES;
}

+ (BOOL)automaticallyNotifiesObserversOfUserid {
    return NO;
}

+ (BOOL)automaticallyNotifiesObserversOfUsername {
    return YES;
}

- (void)setUserid:(NSInteger)userid {
    if (userid < 0) {
        return;
    }
    
    [self willChangeValueForKey:@"userid"];
    _userid = userid;
    [self didChangeValueForKey:@"userid"];
}
@end
