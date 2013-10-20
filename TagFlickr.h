//
//  TagFlickr.h
//  SPoT
//
//  Created by Marcin Ekonomiuk on 21.04.2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagFlickr : NSObject
@property (strong,nonatomic) NSString* tagName;
@property (strong,nonatomic) NSMutableArray* photos;

@end
