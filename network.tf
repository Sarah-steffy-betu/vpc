# # ###################################################### central vpc
 resource "aws_vpc" "Gr10_vpc" {
   cidr_block           = "172.16.0.0/16"
   enable_dns_hostnames = true
   enable_dns_support   = true

   tags = {
     Name = "Gr10_vpc"
   }
 }

# # ######################################################### public subnet  
 resource "aws_subnet" "Gr10_public_subnet" {
   vpc_id                  = aws_vpc.Gr10_vpc.id
   cidr_block              = "172.16.1.0/24"
   map_public_ip_on_launch = true
   availability_zone       = "eu-west-3a"


   tags = { Name = "Gr10_public_subnet" }
 }
# # ##########################################################  private subnet
 resource "aws_subnet" "Gr10_private_subnet" {
   vpc_id                  = aws_vpc.Gr10_vpc.id
  cidr_block              = "172.16.2.0/24"
   map_public_ip_on_launch = false
   availability_zone       = "eu-west-3a"

   tags = { Name = "Gr10_private_subnet" }
 }


# # ########################################################### internet get away 

 resource "aws_internet_gateway" "Gr10_gateway" {

  vpc_id = aws_vpc.Gr10_vpc.id

   tags = {
     Name = "Gr10_gateway"
   }
 }
 ########################################################  EIP NAT  
 resource "aws_eip" "Gr10_eip_NAT" {
   depends_on = [
     aws_internet_gateway.Gr10_gateway
   ]
 }
 ########################################################  NAT getway  
 resource "aws_nat_gateway" "Gr10_NAT_getway" {
   allocation_id = aws_eip.Gr10_eip_NAT.id
   subnet_id     = aws_subnet.Gr10_public_subnet.id

   tags = {
     Name = "Gr10_NAT_getway"
   }
 }

 ########################################################## route default
 resource "aws_route" "default_route" {
   route_table_id         = aws_vpc.Gr10_vpc.default_route_table_id
    destination_cidr_block = "0.0.0.0/0"
   gateway_id             = aws_internet_gateway.Gr10_gateway.id
 }

 ############################################################ rouate table  

 resource "aws_route_table" "Gr10_private_rt" {

   vpc_id = aws_vpc.Gr10_vpc.id
   route {
     cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.Gr10_NAT_getway.id

   }

   tags = {
     Name = "Gr10_Private_rt"
   }
 }

 resource "aws_route_table_association" "Gr10association" {
   subnet_id      = aws_subnet.Gr10_private_subnet.id
   route_table_id = aws_route_table.Gr10_private_rt.id
}
