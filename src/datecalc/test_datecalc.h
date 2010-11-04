#include "datecalc/datecalc.h"

#include "cxxtest/TestSuite.h"
#include <string>
#include <iostream>

using namespace datecalc;

class datecalcTest : public CxxTest::TestSuite
{
public:
    void setUp()
    {
    }
    void tearDown()
    {
    }

    void test_day2date()
    {
        for (std::size_t day(1); day < 800000; ++day) {
            date_s d1, d2;
            day2date(day, d1);
            std::size_t day2(date2day(d1));
            day2date(day2, d2);
            TS_ASSERT_EQUALS(day, day2);
            TS_ASSERT_EQUALS(d1.year, d2.year);
            TS_ASSERT_EQUALS(d1.month, d2.month);
            TS_ASSERT_EQUALS(d1.day, d2.day);
        }
    }
};
