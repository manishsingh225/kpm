#challenge 3

import sys
import json
obj = {"a":{"b":{"c":"h","g":"h"},"f":"e"}}
input = "a"


def test_rec(input,obj1):
    if input in obj1.keys():
        print(obj1[input])
    else:
        for each in obj1.keys():
            if type(obj1[each]) is dict:
                test_rec(input,obj1[each])

if  __name__ == "__main__":
    input = sys.argv[1]
    test_rec(input,obj)

