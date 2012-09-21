//
//  MIABProtocols.h
//  MessageInABottle
//
//  Created by Karl Schmidt on 2012-09-20.
//  Copyright (c) 2012 Adrian Crook & Associates. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@protocol MIABOGBottle<FBGraphObject>

@property (retain, nonatomic) NSString        *id;
@property (retain, nonatomic) NSString        *url;

@end

@protocol MIABOGThrowBottleAction<FBOpenGraphAction>

@property (retain, nonatomic) id<MIABOGBottle>    bottle;

@end


