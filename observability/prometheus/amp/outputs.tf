################################################################################
# Workspace
################################################################################

output "workspace_arn" {
  description = "Amazon Resource Name (ARN) of the workspace"
  value       = aws_prometheus_workspace.k8s-cluster.arn
}

output "workspace_id" {
  description = "Identifier of the workspace"
  value       = aws_prometheus_workspace.k8s-cluster.id
}

output "workspace_prometheus_endpoint" {
  description = "Prometheus endpoint available for this workspace"
  value       = aws_prometheus_workspace.k8s-cluster.prometheus_endpoint
}