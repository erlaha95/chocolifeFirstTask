//
//  APIManager.m
//  CurrencyApp
//
//  Created by Yerlan Ismailov on 26.07.17.
//  Copyright © 2017 ismailov.com. All rights reserved.
//

#import "APIManager.h"
#import "AFNetworking.h"

#define kAPI_BASE @"https://finance.yahoo.com/webservice/v1/"

@implementation APIManager

+ (id)sharedManager {
    static APIManager *sharedAPIManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAPIManager = [[self alloc] init];
    });
    return sharedAPIManager;
}

#pragma mark Endpoints

- (void)downloadCurrencyExchangeRate:(NSDictionary *)params andSuccess:(void (^)(id response))success andFailure:(void (^)(NSError *error))failure {
    
    self.hasAuthHeader = NO;
    NSString *endpoint = @"symbols/allcurrencies/quote?format=json";
    [self callGetAPIWithURL:endpoint andParams:params andSuccess:success andFailure:failure];
}


#pragma mark Common Methods

- (void)callPutAPIWithURL:(NSString *)path andParams:(NSDictionary *)params andSuccess:(void (^)(id response))success andFailure:(void (^)(NSError *error))failure {
    
    path = [NSString stringWithFormat:@"%@%@", kAPI_BASE, path];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
//    NSString *email = (NSString*)[[EGOCache globalCache]objectForKey:@"email"];
//    NSString *password = (NSString*)[[EGOCache globalCache]objectForKey:@"password"];
//    NSLog(@"User Defaults: \n Email: %@ \npassword: %@", email, password);
    
//    if (self.hasAuthHeader == YES) {
//        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:email password:password];
//    }
    
    NSLog(@"path PUT = %@" , path);
    NSMutableDictionary* paramsDic = [params mutableCopy];
    
    [manager PUT:path parameters:paramsDic success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        failure(error);
    }];
    
}

- (void)callPostAPIWithURL:(NSString *)path andParams:(NSDictionary *)params andSuccess:(void (^)(id response))success andFailure:(void (^)(NSError *error))failure {
    
    path = [NSString stringWithFormat:@"%@%@", kAPI_BASE, path];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
//    NSString *email = (NSString*)[[EGOCache globalCache]objectForKey:@"email"];
//    NSString *password = (NSString*)[[EGOCache globalCache]objectForKey:@"password"];
//    NSLog(@"User Defaults: \n Email: %@ \npassword: %@", email, password);
//    
//    if (self.hasAuthHeader == YES) {
//        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:email password:password];
//    }
    
    NSLog(@"path POST = %@" , path);
    NSMutableDictionary* paramsDic = [params mutableCopy];
    
    [manager POST:path parameters:paramsDic progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        failure(error);
    }];
    
}

- (void)callPostAPIWithURLAndImage:(NSString *)path andParams:(NSDictionary *)params images:(NSArray*)imagesArray andSuccess:(void (^)(id response))success andFailure:(void (^)(NSError *error))failure {
    
    path = [NSString stringWithFormat:@"%@%@", kAPI_BASE, path];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
//    NSString *email = (NSString*)[[EGOCache globalCache]objectForKey:@"email"];
//    NSString *password = (NSString*)[[EGOCache globalCache]objectForKey:@"password"];
//    NSLog(@"User Defaults: \n Email: %@ \npassword: %@", email, password);
//    
//    if (self.hasAuthHeader == YES) {
//        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:email password:password];
//    }
    
    NSLog(@"path POSTAndImage = %@" , path);
    NSMutableDictionary* paramsDic = [params mutableCopy];
    
    [manager POST:path parameters:paramsDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        int index = 1;
        
        if (imagesArray.count == 1) {
            NSData *imageData = UIImageJPEGRepresentation(imagesArray.firstObject, 0.6);
            NSString *imageName = @"image";
            NSString *fileName = @"tournamentBGImage";
            [formData appendPartWithFileData:imageData name:imageName fileName:fileName mimeType:@"image/jpeg"];
        } else {
            for (UIImage *image in imagesArray) {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
                
                NSString *imageName = [[NSString alloc]initWithFormat:@"image_%d", index];
                NSString *fileName = [[NSString alloc]initWithFormat:@"file_%d", index];
                [formData appendPartWithFileData:imageData name:imageName fileName:fileName mimeType:@"image/jpeg"];
                index++;
            }
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
    //    [manager POST:path parameters:paramsDic progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
    //        success(responseObject);
    //    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
    //        failure(error);
    //    }];
    
}


- (void)callGetAPIWithURL:(NSString *)path andParams:(NSDictionary *)params andSuccess:(void (^)(id response))success andFailure:(void (^)(NSError *error))failure {
    
    path = [NSString stringWithFormat:@"%@%@", kAPI_BASE, path];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    
//    NSString *email = (NSString*)[[EGOCache globalCache]objectForKey:@"email"];
//    NSString *password = (NSString*)[[EGOCache globalCache]objectForKey:@"password"];
//    NSNumber *userId = (NSNumber*)[[EGOCache globalCache]objectForKey:@"userId"];
//    NSLog(@"User Defaults: \n Email: %@ \npassword: %@ \nuserId: %@", email, password, userId.stringValue);
//    
//    if (self.hasAuthHeader == YES) {
//        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:email password:password];
//    }
    
    NSLog(@"path GET = %@" , path);
    NSMutableDictionary* paramsDic = [params mutableCopy];
    
    [manager GET:path parameters:paramsDic progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        failure(error);
    }];
    
}
@end

