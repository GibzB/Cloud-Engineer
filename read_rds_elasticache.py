from diagrams import Cluster, Diagram, Edge
from diagrams.aws.network import Route53, CloudFront, ElbApplicationLoadBalancer
from diagrams.aws.security import WAF, Shield
from diagrams.aws.compute import EC2Instance
from diagrams.aws.database import RDSMysqlInstance, ElasticacheForRedis
from diagrams.aws.storage import SimpleStorageServiceS3

with Diagram("AWS Architecture (ElastiCache + RDS + Read Replicas)", show=False, direction="TB"):
    
    # Users
    users = Route53("Route 53 (DNS Requests)")

    # AWS Security Layer (Shield + WAF)
    with Cluster("AWS Edge Security"):
        cloudfront = CloudFront("CloudFront CDN")
        shield = Shield("AWS Shield (DDoS Protection)")
        waf = WAF("AWS WAF (Firewall)")

        users >> Edge(label="DNS Resolution") >> cloudfront >> shield >> waf

    # Load Balancing
    alb = ElbApplicationLoadBalancer("Application Load Balancer")
    waf >> Edge(label="Filtered Traffic") >> alb

    # Compute Layer (EC2 + Laravel)
    with Cluster("Auto Scaling Web Servers"):
        ec2 = EC2Instance("EC2 Laravel App")
        alb >> Edge(label="Distributes Requests") >> ec2

    # Caching Layer (ElastiCache)
    with Cluster("Cache Layer"):
        redis = ElasticacheForRedis("ElastiCache (Redis)")
        ec2 >> Edge(label="Check Cache First") >> redis

    # Database Layer (RDS)
    with Cluster("Database Tier"):
        db_primary = RDSMysqlInstance("RDS MySQL (Primary)")
        db_replica = RDSMysqlInstance("RDS MySQL (Read Replica)")

        redis >> Edge(label="Cache Miss (Query Read Replica)") >> db_replica
        db_replica >> Edge(color="brown", style="dotted", label="Sync with Primary") >> db_primary

    # File Storage
    s3 = SimpleStorageServiceS3("Amazon S3")
    ec2 >> Edge(label="File Uploads") >> s3
