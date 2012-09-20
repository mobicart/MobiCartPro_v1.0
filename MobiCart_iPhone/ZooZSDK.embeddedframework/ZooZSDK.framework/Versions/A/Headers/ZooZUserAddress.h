//
//  ZooZUserAddress.h
//  ZooZSDK
//
//  Created by ZooZ on 12/15/11.
//  Copyright (c) 2011 ZooZ.com All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZooZUserAddress : NSObject{
	NSString *country;
	NSString *state;
	NSString *city;
	NSString *streetAddress;
	NSString *zip;
}

@property(nonatomic, retain) NSString *country;
@property(nonatomic, retain) NSString *state;
@property(nonatomic, retain) NSString *city;
@property(nonatomic, retain) NSString *streetAddress;
@property(nonatomic, retain) NSString *zip;

@end
