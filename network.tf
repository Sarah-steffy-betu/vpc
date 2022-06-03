# # ###################################################### central vpc
# resource "aws_vpc" "AO_vpc" {
#   cidr_block           = "172.16.0.0/16"
#   enable_dns_hostnames = true
#   enable_dns_support   = true

#   tags = {
#     Name = "AO_vpc"
#   }
# }

# # ######################################################### public subnet  
# resource "aws_subnet" "AO_public_subnet" {
#   vpc_id                  = aws_vpc.AO_vpc.id
#   cidr_block              = "172.16.1.0/24"
#   map_public_ip_on_launch = true
#   availability_zone       = "eu-west-3a"


#   tags = { Name = "AO_bastion_public_subnet" }
# }
# # ##########################################################  private subnet A 
# resource "aws_subnet" "AO_private_subnet_A" {
#   vpc_id                  = aws_vpc.AO_vpc.id
#   cidr_block              = "172.16.2.0/24"
#   map_public_ip_on_launch = false
#   availability_zone       = "eu-west-3a"

#   tags = { Name = "AO_bastion_private_subnet" }
# }
# #########################################################  private subnet  B 
# resource "aws_subnet" "AO_private_subnet_B" {
#   vpc_id                  = aws_vpc.AO_vpc.id
#   cidr_block              = "172.16.3.0/24"
#   map_public_ip_on_launch = false
#   availability_zone       = "eu-west-3a"

#   tags = { Name = "AO_private_subnet_B" }
# }
# #########################################################  private subnet  C
# resource "aws_subnet" "AO_private_subnet_C" {
#   vpc_id                  = aws_vpc.AO_vpc.id
#   cidr_block              = "172.16.4.0/24"
#   map_public_ip_on_launch = false
#   availability_zone       = "eu-west-3a"

#   tags = { Name = "AO_private_subnet_C" }
# }

# # ########################################################### internet get away 

# resource "aws_internet_gateway" "AO_gateway" {

#   vpc_id = aws_vpc.AO_vpc.id

#   tags = {
#     Name = "AO_gateway"
#   }
# }
# ########################################################  EIP NAT  
# resource "aws_eip" "AO_eip_NAT" {
#   depends_on = [
#     aws_internet_gateway.AO_gateway
#   ]
# }
# ########################################################  NAT getway  
# resource "aws_nat_gateway" "AO_NAT_getway" {
#   allocation_id = aws_eip.AO_eip_NAT.id
#   subnet_id     = aws_subnet.AO_public_subnet.id

#   tags = {
#     Name = "AO_NAT_getway"
#   }
# }

# ########################################################## route default
# resource "aws_route" "default_route" {
#   route_table_id         = aws_vpc.AO_vpc.default_route_table_id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.AO_gateway.id
# }

# ############################################################ rouate table  

# resource "aws_route_table" "AO_bastion_priVATE_RT" {

#   vpc_id = aws_vpc.AO_vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id         = aws_nat_gateway.AO_NAT_getway.id

#   }

#   tags = {
#     Name = "AO_bastion_Private_RT"
#   }
# }

# resource "aws_route_table_association" "AO_private_association" {
#   subnet_id      = aws_subnet.AO_private_subnet_A.id
#   route_table_id = aws_route_table.AO_bastion_priVATE_RT.id
# }
