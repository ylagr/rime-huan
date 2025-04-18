import re
from collections import OrderedDict

DATA_LINE_RE = re.compile(r'^(.)\t[a-z]+;([a-z][a-z])')
table = OrderedDict()

with open('../moran.chars.dict.yaml', 'r') as f:
    for l in f:
        if m := re.match(DATA_LINE_RE, l):
            char = m[1]
            code = m[2]
            if char not in table:
                table[char] = []
            if code not in table[char]:
                table[char].append(code)

for (char, codes) in table.items():
    for code in codes:
        print(f'{char} {code}')
