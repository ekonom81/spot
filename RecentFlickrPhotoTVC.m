//
//  RecentFlickrPhotoTVC.m
//  SPoT
//
//  Created by Marcin Ekonomiuk on 22.04.2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "RecentFlickrPhotoTVC.h"
#import "FlickrFetcher.h"
#import "RecentPhoto.h"

@interface RecentFlickrPhotoTVC ()

@end

@implementation RecentFlickrPhotoTVC


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.photos=[RecentPhoto recentPhotos];
}
@end
