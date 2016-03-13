//
//  UserManager.h
//  Practise_KVO
//
//  Created by Claris on 2016.03.12.Saturday.
//  Copyright © 2016 tickCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface UserManager : NSObject
+ (instancetype)sharedInstance;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, assign) NSInteger userid;
@property (nonatomic, strong) Person *person;
@end
