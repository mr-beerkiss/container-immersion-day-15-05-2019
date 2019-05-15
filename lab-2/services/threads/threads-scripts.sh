aws logs create-log-group --log-group-name "/ecs/threads-task-def"

aws ecs register-task-definition --cli-input-json file://threads-task-def.json


aws elbv2 create-target-group \
	--region us-east-1 \
	--name threads-cntr-tg \
	--vpc-id vpc-0bb700c40177ef85e \
	--port 3000 \
	--protocol HTTP \
	--target-type ip \
	--health-check-protocol HTTP \
	--health-check-path / \
	--health-check-interval-seconds 6 \
	--health-check-timeout-seconds 5 \
	--healthy-threshold-count 2 \
	--unhealthy-threshold-count 2 \
	--query "TargetGroups[0].TargetGroupArn" \
	--output text


aws elbv2 create-rule \
    --region us-east-1 \
    --listener-arn arn:aws:elasticloadbalancing:us-east-1:955592929652:listener/app/Container-Labs-alb/7f45051cdc783d86/10d4c113c5b52b88 \
    --priority 2 \
    --conditions Field=path-pattern,Values='/api/threads*' \
    --actions Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:us-east-1:955592929652:targetgroup/threads-cntr-tg/e95ab649f4a7977e
    
aws ecs create-service \
    --region us-east-1 \
    --cluster my_first_ecs_cluster \
    --service-name threads-service \
    --cli-input-json file://threads-service.json
    
