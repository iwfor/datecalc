/*
 * Copyright (c) 2003-2010 Isaac W. Foraker, All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer
 *    in the documentation and/or other materials provided with the
 *    distribution.
 * 
 * 3. Neither the name of the copyright holder nor the names of its
 *    contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#include "datecalc/datecalc.h"
#include <cctype>
#include <cstring>

namespace {
	const unsigned days2month[] =   { 31,28,31,30,31,30,31,31,30,31,30,31 };
	const unsigned lydays2month[] = { 31,29,31,30,31,30,31,31,30,31,30,31 };
    const char *shortmonth[] = {
        "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT",
        "NOV", "DEC"
    };
    const char *longmonth[] = {
        "JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY",
        "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"
    };

	// These constants are used to determine the number of days in the
	// specified number of years, including days in leap years.
	// 400 years * 365 days + 100 leap days - 3 un-leap days = 146,097
	const unsigned year400 = 146097;
	// 100 years * 365 days + 25 leap days - 1 leap day = 36524
	const unsigned year100 = 36524;
	// 4 years * 365 days + 1 leap day = 1461
	const unsigned year4 = 1461;
	// 1 year
	const unsigned year1 = 365;
} // end anonymous namespace

namespace datecalc {


/**
 * Convert a day of the year from 1-365 to the month.  The day of the month
 * will be set in day, and the month will be returned.
 */
unsigned yday2month(unsigned &day, bool leapyear)
{
	const unsigned* chart = leapyear ? lydays2month : days2month;
	unsigned month;

	for (month = 0; month < 11; ++month) {
		if (day <= chart[month]) {
			// Return month index plus one to match calendar month
			return month+1;
		}
		day-= chart[month];
	}
	// At most, returns in month 12.
	return month+1;
}

unsigned mday2yday(unsigned month, unsigned day, bool leapyear)
{
	const unsigned* chart = leapyear ? lydays2month : days2month;
	--month;
	for (unsigned i = 0; i < month; ++i)
	{
		day+= chart[i];
	}
	return day;
}

bool isleapyear(unsigned year)
{
	if (!year)
		return false;
	if (!(year%400))
		return true;
	if (!(year%100) || (year <= 4))
		return false;
	if (!(year%4))
		return true;
	return false;
}


/**
 * Check if the given character is a separator character
 *
 * @param   c       Character to test
 * @return  true if c is a separator; false if c is not a separator.
 */
bool isseparator(char c)
{
    return std::isspace(c) || c == '-' || c == '/' || c == ',';
}


/**
 * @param   datestr The string formatted date
 * @param   day     The day value for the given date
 * @return  false on success; true on failure.
 */
bool date2day(const char *datestr, unsigned *day)
{
    unsigned t=0;

    *day = 0;

    // Skip any preceding space
    while (*datestr && std::isspace(*datestr))
        ++datestr;

    // Attempt to recognize the date format
    if (std::isdigit(*datestr)) {
        t = *datestr - '0';
        while (std::isdigit(*++datestr)) {
            t*= 10;
            t+= *datestr - '0';
        }
        if (!*datestr || !isseparator(*datestr))
            return true;
    } else if (std::isalpha(*datestr)) {
    } else
        return true;

    return false;
}


/**
 * @param	day		The number of days since the start of 1 A.D., Jan 1, 1 A.D. being day 1.
 * @return	the year calculated from day, where 1 is 1 A.D.
 */
unsigned day2year(unsigned day)
{
	// Add 1 if day is greater than 4 years to compensate for 4 A.D not being a
	// leap year.
	if (day > year1*4)
		day++;
	day+= 364;	// Add a year for non-existent 0 A.D.
	unsigned x = day%year400;
	unsigned y = x%year100;
	unsigned z = y%year4;
	return (day/year400)*400 + (x/year100)*100 + (y/year4)*4 + z/year1;
}


unsigned year2day(unsigned year)
{
	// If less than 8 A.D. then calculation is simple, because there were no
	// leap years yet.
	if (year < 8)
		return year * year1 - 364;
	unsigned x = year%400;
	unsigned y = x%100;
	unsigned z = y%4;
	// Subtract an extra 1 to account for 4 A.D. not being a leap year.  If
	// this is a leap year, subtract an extra 1 to account for the extra day in
	// the year.
	return (year/400)*year400 + (x/100)*year100 + (y/4)*year4 + z*year1 - 364
		- 1 - isleapyear(year);
}

void day2date(unsigned day, date_s &date)
{
	date.year = day2year(day);
	date.day = day - year2day(date.year) + 1;
	date.month = yday2month(date.day, isleapyear(date.year));
}

unsigned date2day(const date_s &date)
{
	unsigned day = year2day(date.year);
	day+= mday2yday(date.month, date.day, isleapyear(date.year)) - 1;

	return day;
}

void advanceday(date_s &date)
{
	unsigned day = date2day(date);
    ++day;
    day2date(day, date);
}

void advancemonth(date_s &date)
{
	if (date.month >= 12) {
		date.year++;
		date.month = 1;
	} else {
		date.month++;
	}
}

void advanceyear(date_s &date)
{
    ++date.year;
}

bool operator==(const date_s &d1, const date_s &d2)
{
	return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
}

bool operator!=(const date_s &d1, const date_s &d2)
{
	return d1.year != d2.year || d1.month != d2.month || d1.day != d2.day;
}

bool operator>=(const date_s &d1, const date_s &d2)
{
	return d1.year > d2.year ||
		(d1.year == d2.year && (d1.month > d2.month ||
		 (d1.month == d2.month && d1.day >= d2.day)));
}

bool operator<=(const date_s &d1, const date_s &d2)
{
	return d1.year < d2.year ||
		(d1.year == d2.year && (d1.month < d2.month ||
		 (d1.month == d2.month && d1.day <= d2.day)));
}

bool operator>(const date_s &d1, const date_s &d2)
{
	return d1.year > d2.year ||
		(d1.year == d2.year && (d1.month > d2.month ||
		 (d1.month == d2.month && d1.day > d2.day)));
}

bool operator<(const date_s &d1, const date_s &d2)
{
	return d1.year < d2.year ||
		(d1.year == d2.year && (d1.month < d2.month ||
		 (d1.month == d2.month && d1.day < d2.day)));
}

} // end namespace datecalc
