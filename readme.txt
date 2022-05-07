Assignmet Challenge to create below resources using terraform:
1. VPC
2. ALB - this should route traffic to ECS Service
3. ECS Service - This can be a dummy service that connects to RDS
4. RDS
5. Route53

Explanation:

VPC id defined with three subnets each in public, private.
ALB is defined and configured to ECS Service.
here assumed ECS Service is hosting an wordpress site which talks to RDS, although a simple container can be built which runs a python script that checks connection to RDS.
RDS Provision with mysql engine, generated a random password to demonstrate passwords cannot be exposed anywhere in the code. the same password can be stored into SSM to further use. 
created a zone and inserted a sample record type NS,A  

Confifuration files can be further improvised with defining resources name prefix matching to env name ex: dev, qa, stg etc
used muliple terraform features like data, variables, modules,locals, functions like element, file, slice etc.

ATTACHED TERRAFORM PLAN in file ./terraform-plan.txt & terraform-plan screen shot for reference