# ---------------------------------------------------------------------------------------------------------------------
# DATA SOURCES
# ---------------------------------------------------------------------------------------------------------------------

# get AWS region name
data "aws_region" "current" {}

# get AWS Account ID
data "aws_caller_identity" "current" {}

# get AWS Account alias name
data "aws_iam_account_alias" "current" {}
