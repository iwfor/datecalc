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
#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <string>

using namespace datecalc;

void usage();

int main(int argc, char *argv[])
{
    if (argc < 2) {
        usage();
    }
    unsigned i = 1;
    std::string command(argv[i++]);
    if (!strcmp(argv[1], "--getday")) {
        if (argc < 5) {
            usage();
        }
        date_s d;
        d.year = std::atoi(argv[i++]);
        d.month= std::atoi(argv[i++]);
        d.day = std::atoi(argv[i++]);
        unsigned absday(date2day(d));
        std::cout << "Leap? " << (isleapyear(d.year) ? 'y' : 'n') << std::endl;
        std::cout << "YearDay: " << year2day(d.year) << std::endl;
        std::cout << "Day: " << absday << std::endl;

        date_s d2;
        day2date(year2day(d.year), d2);
        std::cout << "On Year: " << d2.year << "-" << d2.month << "-" << d2.day << std::endl;
    }
    else if (!std::strcmp(argv[1], "--add")) {
        if (argc < 6) {
            usage();
        }
        date_s d;
        d.year = std::atoi(argv[i++]);
        d.month= std::atoi(argv[i++]);
        d.day = std::atoi(argv[i++]);
        unsigned change(std::atoi(argv[i++]));
        unsigned absday(date2day(d));
        std::cout << "Initial Day: " << absday << std::endl;
        day2date(absday, d);
        std::cout << "Initial Date: " << d.year << "-" << d.month << "-" << d.day << std::endl;
        absday+= change;
        std::cout << "New Day: " << absday << std::endl;
        day2date(absday, d);
        std::cout << "New Date: " << d.year << "-" << d.month << "-" << d.day << std::endl;
    }
    else {
        usage();
    }
    if (argc < 4) {
        std::cout << "runner year month day" << std::endl;
        return 1;
    }
    return 0;
}

void usage()
{
    std::cout <<
        "runner [options]\n"
        "\n"
        "--getday <year> <month> <day>\n"
        << std::endl;
    std::exit(1);
}
