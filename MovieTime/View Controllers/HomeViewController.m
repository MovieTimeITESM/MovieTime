//
//  HomeViewController.m
//  MovieTime
//
//  Created by Iliana García on 10/26/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *displayData;
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) NSArray *lists;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.displayData.delegate = self;
    // Do any additional setup after loading the view.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.movies count] + [self.lists count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieViewCell" forIndexPath:indexPath];
    return cell;
}

@end
