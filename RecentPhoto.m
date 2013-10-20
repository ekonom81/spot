//
//  RecentPhoto.m
//  SPoT
//
//  Created by Marcin Ekonomiuk on 28.04.2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "RecentPhoto.h"
#define RECENT_PHOTO_KEY @"RECENT_PHOTOS"
#define MAX_RECENT_PHOTOS 10

@implementation RecentPhoto

+(NSArray *)recentPhotos
{
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSArray *result=[[NSUserDefaults standardUserDefaults] valueForKey:RECENT_PHOTO_KEY];
    if(!result)
        result=[[NSArray alloc]init];
    
    return result;
}


+(void)addPhoto:(id)photo
{
    NSMutableArray *recentPhotos= [[[self class]recentPhotos]mutableCopy];
    if(![recentPhotos containsObject:photo]){
        if([recentPhotos count]>=MAX_RECENT_PHOTOS){
            [recentPhotos removeObject:[recentPhotos lastObject]];
        }
    }
    else
    {
        [recentPhotos removeObject:photo];
    }
    [recentPhotos insertObject:photo atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:[recentPhotos copy] forKey:RECENT_PHOTO_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end