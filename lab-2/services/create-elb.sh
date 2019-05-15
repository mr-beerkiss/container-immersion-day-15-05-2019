#!/usr/bin/env bash
aws elbv2 create-target-group \
	--region us-east-1 \
	--name monolith-cntr-tg \
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
	
aws elbv2 describe-listeners \
    --region us-east-1 \
    --query "Listeners[0].ListenerArn" \
    --load-balancer-arn arn:aws:elasticloadbalancing:us-east-1:955592929652:loadbalancer/app/Container-Labs-alb/7f45051cdc783d86 \
    --output text
    
 aws elbv2 modify-listener \
    --region us-east-1 \
    --listener-arn arn:aws:elasticloadbalancing:us-east-1:955592929652:listener/app/Container-Labs-alb/7f45051cdc783d86/10d4c113c5b52b88 \
    --query "Listeners[0].ListenerArn" \
    --default-actions Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:us-east-1:955592929652:targetgroup/monolith-cntr-tg/cb93043bf458d514 \
    --output text
    
aws ecs create-service \
    --region us-east-1 \
    --cluster my_first_ecs_cluster \
    --service-name monolith-service \
    --cli-input-json file://ecs-service.json