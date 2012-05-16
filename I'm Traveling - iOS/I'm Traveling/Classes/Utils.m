//
//  Utils.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 3..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "Utils.h"
#import "SettingsManager.h"
#import "Const.h"
#import "CommonCrypto/CommonDigest.h"

static char encodingTable[64] = {
	'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
	'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
	'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
	'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/' };

@implementation NSData (VQBase64)

- (id)initWithString:(NSString *)string {
    if ((self = [super init])) {
        [self initWithBase64EncodedString:string];
    }
    return self;
	
}


+ (NSData *) dataWithBase64EncodedString:(NSString *) string {
    return [[[NSData allocWithZone:nil] initWithBase64EncodedString:string] autorelease];
}

- (id) initWithBase64EncodedString:(NSString *) string {
    NSMutableData *mutableData = nil;
	
    if( string ) {
        unsigned long ixtext = 0;
        unsigned long lentext = 0;
        unsigned char ch = 0;
        unsigned char inbuf[4], outbuf[3];
        short i = 0, ixinbuf = 0;
        BOOL flignore = NO;
        BOOL flendtext = NO;
        NSData *base64Data = nil;
        const unsigned char *base64Bytes = nil;
		
        // Convert the string to ASCII data.
        base64Data = [string dataUsingEncoding:NSASCIIStringEncoding];
        base64Bytes = [base64Data bytes];
        mutableData = [NSMutableData dataWithCapacity:[base64Data length]];
        lentext = [base64Data length];
		
        while( YES ) {
            if( ixtext >= lentext ) break;
            ch = base64Bytes[ixtext++];
            flignore = NO;
			
            if( ( ch >= 'A' ) && ( ch <= 'Z' ) ) ch = ch - 'A';
            else if( ( ch >= 'a' ) && ( ch <= 'z' ) ) ch = ch - 'a' + 26;
            else if( ( ch >= '0' ) && ( ch <= '9' ) ) ch = ch - '0' + 52;
            else if( ch == '+' ) ch = 62;
            else if( ch == '=' ) flendtext = YES;
            else if( ch == '/' ) ch = 63;
            else flignore = YES;
			
            if( ! flignore ) {
                short ctcharsinbuf = 3;
                BOOL flbreak = NO;
				
                if( flendtext ) {
                    if( ! ixinbuf ) break;
                    if( ( ixinbuf == 1 ) || ( ixinbuf == 2 ) ) ctcharsinbuf = 1;
                    else ctcharsinbuf = 2;
                    ixinbuf = 3;
                    flbreak = YES;
                }
				
                inbuf [ixinbuf++] = ch;
				
                if( ixinbuf == 4 ) {
                    ixinbuf = 0;
                    outbuf [0] = ( inbuf[0] << 2 ) | ( ( inbuf[1] & 0x30) >> 4 );
                    outbuf [1] = ( ( inbuf[1] & 0x0F ) << 4 ) | ( ( inbuf[2] & 0x3C ) >> 2 );
                    outbuf [2] = ( ( inbuf[2] & 0x03 ) << 6 ) | ( inbuf[3] & 0x3F );
					
                    for( i = 0; i < ctcharsinbuf; i++ )
                        [mutableData appendBytes:&outbuf[i] length:1];
                }
				
                if( flbreak )  break;
            }
        }
    }
	
    self = [self initWithData:mutableData];
    return self;
}

#pragma mark -

- (NSString *) base64Encoding {
    return [self base64EncodingWithLineLength:0];
}

- (NSString *) base64EncodingWithLineLength:(unsigned int) lineLength {
    const unsigned char     *bytes = [self bytes];
    NSMutableString *result = [NSMutableString stringWithCapacity:[self length]];
    unsigned long ixtext = 0;
    unsigned long lentext = [self length];
    long ctremaining = 0;
    unsigned char inbuf[3], outbuf[4];
    unsigned short i = 0;
    unsigned short charsonline = 0, ctcopy = 0;
    unsigned long ix = 0;
	
    while( YES ) {
        ctremaining = lentext - ixtext;
        if( ctremaining <= 0 ) break;
		
        for( i = 0; i < 3; i++ ) {
            ix = ixtext + i;
            if( ix < lentext ) inbuf[i] = bytes[ix];
            else inbuf [i] = 0;
        }
		
        outbuf [0] = (inbuf [0] & 0xFC) >> 2;
        outbuf [1] = ((inbuf [0] & 0x03) << 4) | ((inbuf [1] & 0xF0) >> 4);
        outbuf [2] = ((inbuf [1] & 0x0F) << 2) | ((inbuf [2] & 0xC0) >> 6);
        outbuf [3] = inbuf [2] & 0x3F;
        ctcopy = 4;
		
        switch( ctremaining ) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
		
        for( i = 0; i < ctcopy; i++ )
            [result appendFormat:@"%c", encodingTable[outbuf[i]]];
		
        for( i = ctcopy; i < 4; i++ )
            [result appendString:@"="];
		
        ixtext += 3;
        charsonline += 4;
		
        if( lineLength > 0 ) {
            if( charsonline >= lineLength ) {
                charsonline = 0;
                [result appendString:@"\n"];
            }
        }
    }
	
    return [NSString stringWithString:result];
}

@end


@implementation Utils

+ (BOOL)loggedIn
{
	NSString *key = SETTING_KEY_USER_ID;
	return [[SettingsManager manager] getSettingForKey:key] != nil;
}

+ (NSInteger)userId
{
	NSString *key = SETTING_KEY_USER_ID;
	return [[[SettingsManager manager] getSettingForKey:key] integerValue];
}

+ (NSString *)userName
{
	NSString *key = SETTING_KEY_USER_NAME;
	return [[SettingsManager manager] getSettingForKey:key];
}

+ (NSString *)email
{
	NSString *key = SETTING_KEY_EMAIL;
	return [[SettingsManager manager] getSettingForKey:key];
}

// hashed password
+ (NSString *)password
{
	NSString *key = SETTING_KEY_PASSWORD;
	return [[SettingsManager manager] getSettingForKey:key];
}

+ (void)logout
{
	NSString *key = SETTING_KEY_USER_ID;
	[[SettingsManager manager] clearSettingForKey:key];
	
	key = SETTING_KEY_USER_NAME;
	[[SettingsManager manager] clearSettingForKey:key];
	
	key = SETTING_KEY_EMAIL;
	[[SettingsManager manager] clearSettingForKey:key];
	
	key = SETTING_KEY_PASSWORD;
	[[SettingsManager manager] clearSettingForKey:key];
	
	[[SettingsManager manager] flush];
}

+ (NSString *)getHtmlFromUrl:(NSString *)url
{
	NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
	return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

+ (id)parseJSON:(NSString *)json
{
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	return [[parser autorelease] objectWithString:json];
}

+ (NSString *)writeJSON:(id)object
{
	SBJsonWriter *writer = [[SBJsonWriter alloc] init];
	return [[writer autorelease] stringWithObject:object];
}

+ (NSInteger)getCellIdWithLatitude:(double)latitude longitude:(double)longitude
{
	// ((ABS(ROUND(경도 + 90,2)) * 100) * 36000) + ((ABS(ROUND(위도 + 180,2)) * 100));
	return ABS( round( ( latitude + 90 ) * 100 ) / 100 ) * 100 * 36000 + ABS( round( ( longitude + 180 ) * 100 ) / 100 ) * 100;
}

+ (NSString *)dateWithDate:(NSDate *)date
{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.dateStyle = NSDateFormatterMediumStyle;
	return [formatter stringFromDate:date];
}

+ (NSString *)dateWithDate:(NSDate *)date andTimezone:(NSTimeZone *)timezone
{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.timeZone = timezone;
	formatter.dateStyle = NSDateFormatterMediumStyle;
	return [formatter stringFromDate:date];
}

+ (NSString *)onlyDateWithDate:(NSDate *)date
{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.dateFormat = @"d";
	return [formatter stringFromDate:date];
}

+ (NSString *)timeWithDate:(NSDate *)date
{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.timeStyle = NSDateFormatterShortStyle;
	return [formatter stringFromDate:date];
}

+ (NSString *)timeWithDate:(NSDate *)date andTimezone:(NSTimeZone *)timezone
{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.timeZone = timezone;
	formatter.timeStyle = NSDateFormatterShortStyle;
	return [formatter stringFromDate:date];
}

+ (NSString *)stringWithDate:(NSDate *)date andTime:(NSDate *)time
{
	NSTimeZone *timezone = [NSTimeZone localTimeZone];
	return [NSString stringWithFormat:@"%@\n%@", [Utils dateWithDate:date andTimezone:timezone], [Utils timeWithDate:time andTimezone:timezone]];
}

// Upload를 위한 Date 형식
+ (NSString *)dateStringForUpload:(NSDate *)date
{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
	return [formatter stringFromDate:date];
}

+ (NSString *)sha1:(NSString *)input
{
	NSData *data = [input dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	uint8_t digest[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1( data.bytes, data.length, digest );
	
	NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	for( int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++ )
		[output appendFormat:@"%02x", digest[i]];
	
	return output;
}

+ (NSString *)decodeURI:(NSString *)input
{
	return [input stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)imageToBase64:(UIImage *)image
{
	return [UIImagePNGRepresentation( image ) base64Encoding];
}

@end
