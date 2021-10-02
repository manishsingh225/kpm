from logging import Filter
import boto3
import os
import json
import sys


def test_rec(input,obj1):
    if input in obj1.keys():
        print("Value For keyword : {} is {}".format(input,obj1[input]))
    else:
        for each in obj1.keys():
            if type(obj1[each]) is dict:
                test_rec(input,obj1[each])
            elif type(obj1[each]) is list:
                if len(obj1[each]) == 0:
                    continue
                else:
                    test_rec(input,obj1[each][0])


def instance_meta(instance_name, input):
    os.environ["AWS_PROFILE"] = "<AWS_PROFILE>"
    ec2_client =  boto3.client("ec2" , region_name='<AWS_REGION')

    ec2_details = ec2_client.describe_instances(Filters=[{'Name': 'tag:Name','Values': [instance_name]}]) # tag:<key>  key can be any tag assigned to the ec2 instance based on which it selects the ec2 instance 
    print("=============Instance Meta Data ============================")
    print(ec2_details)
    print("============================================================")
    test_rec(input,ec2_details)


if  __name__ == "__main__":
    if len(sys.argv) == 3:
        instance_name = sys.argv[1]
        input = sys.argv[2]
        print(instance_name , input)
        instance_meta(instance_name,input)
    else:
        print("Pass instance name and keyword to search or check no of parameter pass only 2 Req.")