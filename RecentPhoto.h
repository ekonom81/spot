//
//  RecentPhoto.h
//  SPoT
//
//  Created by Marcin Ekonomiuk on 28.04.2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentPhoto : NSObject
+(NSArray*)recentPhotos;
+(void)addPhoto:(id)photo;

@end
