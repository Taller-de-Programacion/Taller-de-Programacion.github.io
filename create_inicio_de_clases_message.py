
import sys
from datetime import datetime

start_date = datetime.strptime(sys.argv[1], "%d/%m/%Y")
end_date = datetime.strptime(sys.argv[2], "%d/%m/%Y")

assert start_date < end_date

assert datetime.today().year == start_date.year == end_date.year

year = start_date.year
if start_date.month < 5:
    quarter_num = "1er"
    quarter_str = "primer"
    month =  min(3, start_date.month)
    post_date = f"01/{month:02}/{year}"
    post_date_rev = f"{year}-{month:02}-01"
else:
    quarter_num = "2do"
    quarter_str = "segundo"
    month =  min(8, start_date.month)
    post_date = f"01/{month:02}/{year}"
    post_date_rev = f"{year}-{month:02}-01"

start_date = f'{start_date:%d/%m/%Y}'
end_date = f'{end_date:%d/%m/%Y}'
year = str(year)

fname = f"{post_date_rev}-Inicio-de-Clases-{quarter_str}-Cuat.-{year}.md"
fdir = f'news/_posts/{year}'

with open(".inicio-de-clases.md", "rt") as f:
    template = f.read()

import os
os.system(f"mkdir '{fdir}'")

replacements = [
        (
            "{year}", year
            ),
        (
            "{quarter_num}", quarter_num
            ),
        (
            "{quarter_str}", quarter_str
            ),
        (
            "{post_date}", post_date
            ),
        (
            "{start_date}", start_date
            ),
        (
            "{end_date}", end_date
            ),
        ]

post = template

for tag, value in replacements:
    assert isinstance(value, str)
    print(tag, "-->", value, file=sys.stderr)
    post = post.replace(tag, value)

with open(fdir + "/" + fname, 'wt') as f:
    f.write(post)
