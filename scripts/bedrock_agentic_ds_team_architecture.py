from diagrams import Diagram, Cluster
from diagrams.aws.general import User
from diagrams.aws.ml import Bedrock, Sagemaker, SagemakerModel
from diagrams.aws.storage import S3
from diagrams.aws.analytics import Glue
from diagrams.aws.integration import SQS
from diagrams.aws.management import Cloudwatch
from diagrams.aws.security import IAMRole

with Diagram("Agentic Data Science Team for Fraud Detection", filename="../generated-diagrams/bedrock_agentic_ds_team_architecture", show=False):
    user = User("Experimenter")
    with Cluster("Bedrock Agentic DS Team"):
        bedrock = Bedrock("Bedrock Agent")
        s3_artifacts = S3("Artifacts/Data")
        s3_fraud = S3("Fraud Parquet Data")
        glue = Glue("Data Discovery/ETL")
        sagemaker = Sagemaker("Model Training/Deployment")
        endpoint = SagemakerModel("Inference Endpoint")
        sqs = SQS("Workflow Events")
        cloudwatch = Cloudwatch("Monitoring")
        data_agent_role = IAMRole("Data Agent IAM Role")
        user >> bedrock
        bedrock >> glue >> s3_artifacts
        bedrock >> sagemaker >> endpoint
        sagemaker >> s3_artifacts
        bedrock >> sqs
        endpoint >> cloudwatch
        bedrock >> cloudwatch
        # Data agent reads/cleans from S3 Parquet
        bedrock >> data_agent_role >> s3_fraud
        s3_fraud >> glue
