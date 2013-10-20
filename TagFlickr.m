//
//  TagFlickr.m
//  SPoT
//
//  Created by Marcin Ekonomiuk on 21.04.2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "TagFlickr.h"

@implementation TagFlickr

@synthesize tagName=_tagName;

-(void)setTagName:(NSString *)tagName
{
    _tagName =tagName;
}

-(NSString*)tagName
{
    return _tagName;
}

-(NSMutableArray*)photos
{
    if (!_photos)
        _photos = [[NSMutableArray alloc]init];
    
    return _photos;
}

@end
