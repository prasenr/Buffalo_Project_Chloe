//
//  NSObject+UserUtil.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 4/30/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "NSObject+UserUtil.h"

@implementation UserUtil :NSObject

-(id)init {
    //TODO Looking into https://github.com/kishikawakatsumi/UICKeyChainStore
    //TODO create method to lookup keys if not produce keys
    
    return self;
};

-(void) produceKeys {
    [UserUtil keyDictionary][@"publickey"] = [UserUtil createRandomUDID];
    [UserUtil keyDictionary][@"dwkey"] = [UserUtil createRandomUDID];
    
    //TODO store keys
}

-(NSString *) getUserPublicKey {
    return [UserUtil keyDictionary][@"publickey"];
}

-(NSString *) getUserDWKey {
    return [UserUtil keyDictionary][@"dwkey"];
}

+(NSMutableDictionary *) keyDictionary {
    
    static NSMutableDictionary *_keyDictionary = nil;
    if(!_keyDictionary) {
        _keyDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return _keyDictionary;
}

+(NSString *) createRandomUDID {
    int NUMBER_OF_CHARS = 256;
    
    char data[NUMBER_OF_CHARS];
    for (int x=0;x<NUMBER_OF_CHARS;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:NUMBER_OF_CHARS encoding:NSUTF8StringEncoding];
}

@end
