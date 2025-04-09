# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
resource "aws_lambda_function" "codebuild_invoker" {
  filename         = var.builder_archive_path
  function_name    = local.codebuild_invoker_function_name
  description      = "AFT Lambda Layer - CodeBuild Invoker"
  role             = aws_iam_role.codebuild_invoker_lambda_role.arn
  handler          = "codebuild_invoker.lambda_handler"
  source_code_hash = var.builder_archive_hash
  memory_size      = 1024
  runtime          = "python3.8"
  timeout          = 900

  vpc_config {
    subnet_ids         = var.aft_vpc_private_subnets
    security_group_ids = var.aft_vpc_default_sg
  }
}

/*
  NB: The following CodeBuild project (`python-layer-builder-aft-common-68y6gxoc`) no longer executes successfully
  as a required Python package fails to install as follows:

  ERROR: Could not find a version that satisfies the requirement whaaaaat==0.5.2 (from aft-common)

  I believe we are safe to ignore this issue for the time being however - hence I have simply commented it out below to
  allow the remainder of the Terraform to successfully deploy - as the infrastructure this CodeBuild execution stands up
  is already in place. The only real fix I can see is to update the entire AFT project, which seems overkill whilst what
  we have is working for now...
*/

# data "aws_lambda_invocation" "invoke_codebuild_job" {
#   function_name = aws_lambda_function.codebuild_invoker.function_name
#
#   input = <<JSON
# {
#   "codebuild_project_name": "${aws_codebuild_project.codebuild.name}"
# }
# JSON
# }

# output "lambda_layer_build_status" {
#   value = jsondecode(data.aws_lambda_invocation.invoke_codebuild_job.result)["Status"]
# }
