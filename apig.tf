
// api gateway
resource "aws_api_gateway_rest_api" "MyDemoAPI" {
  name        = "MyDemoAPI"
  description = "This is my API for demonstration purposes"
}

// api gateway mock resource
resource "aws_api_gateway_resource" "MyDemoResource" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  parent_id   = aws_api_gateway_rest_api.MyDemoAPI.root_resource_id
  path_part   = "mydemoresource"
}

// api gateway method
resource "aws_api_gateway_method" "MyDemoMethod" {
  rest_api_id   = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id   = aws_api_gateway_resource.MyDemoResource.id
  http_method   = "GET"
  authorization = "NONE"
}

// api gateway sns resource
resource "aws_api_gateway_resource" "SNSResource" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  parent_id   = aws_api_gateway_rest_api.MyDemoAPI.root_resource_id
  path_part   = "test"
}

// api gateway method
resource "aws_api_gateway_method" "SNSMethod" {
  rest_api_id   = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id   = aws_api_gateway_resource.SNSResource.id
  http_method   = "POST"
  authorization = "NONE"
   request_parameters   = {
        "method.request.querystring.Message"  = false
        "method.request.querystring.Subject"  = false
        "method.request.querystring.TopicArn" = true
    }
}

// api gateway integration
/*
After setting up an api method you must integrate it with something ... lambda, sns etc.
Service proxy - api in front of aws services.
*/
# resource "aws_api_gateway_integration" "MyDemoIntegration" {
#   rest_api_id          = aws_api_gateway_rest_api.MyDemoAPI.id
#   resource_id          = aws_api_gateway_resource.MyDemoResource.id
#   http_method          = aws_api_gateway_method.MyDemoMethod.http_method
#   type = "AWS"
#   integration_http_method = "POST"

# }

// api gateway deployment