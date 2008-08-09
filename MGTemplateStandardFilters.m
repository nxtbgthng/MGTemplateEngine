//
//  MGTemplateStandardFilters.m
//
//  Created by Matt Gemmell on 13/05/2008.
//  Copyright 2008 Instinctive Code. All rights reserved.
//

#import "MGTemplateStandardFilters.h"


#define UPPERCASE		@"uppercase"
#define LOWERCASE		@"lowercase"
#define CAPITALIZED		@"capitalized"
#define DATE_FORMAT		@"date_format"
#define COLOR_FORMAT	@"color_format"


@implementation MGTemplateStandardFilters


- (NSArray *)filters
{
	return [NSArray arrayWithObjects:
			UPPERCASE, LOWERCASE, CAPITALIZED, 
			DATE_FORMAT, COLOR_FORMAT, 
			nil];
}


- (NSObject *)filterInvoked:(NSString *)filter withArguments:(NSArray *)args onValue:(NSObject *)value
{
	if ([filter isEqualToString:UPPERCASE]) {
		return [[NSString stringWithFormat:@"%@", value] uppercaseString];
		
	} else if ([filter isEqualToString:LOWERCASE]) {
		return [[NSString stringWithFormat:@"%@", value] lowercaseString];
		
	} else if ([filter isEqualToString:CAPITALIZED]) {
		return [[NSString stringWithFormat:@"%@", value] capitalizedString];
		
	} else if ([filter isEqualToString:DATE_FORMAT]) {
		// Formats NSDates according to Unicode syntax: 
		// http://unicode.org/reports/tr35/tr35-4.html#Date_Format_Patterns 
		// e.g. "dd MM yyyy" etc.
		if ([value isKindOfClass:[NSDate class]] && [args count] == 1) {
			NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
			[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
			NSString *format = [args objectAtIndex:0];
			[dateFormatter setDateFormat:format];
			return [dateFormatter stringFromDate:(NSDate *)value];
		}
		
	} else if ([filter isEqualToString:COLOR_FORMAT]) {
		if ([value isKindOfClass:[NSColor class]] && [args count] == 1) {
			NSString *format = [[args objectAtIndex:0] lowercaseString];
			if ([format isEqualToString:@"hex"]) {
				// Output color in hex format RRGGBB (without leading # character).
				NSColor *color = [(NSColor *)value colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
				if (!color) { // happens if the colorspace couldn't be converted
					return @"000000"; // black
				} else {
					NSString *colorHex = [NSString stringWithFormat:@"%02x%02x%02x", 
										  (int)([color redComponent] * 255), 
										  (int)([color greenComponent] * 255), 
										  (int)([color blueComponent] * 255)];
					return colorHex;
				}
			}
		}
		
	}
	
	return value;
}


@end
