output "credential-helper-cli" {
  value = format("aws_signing_helper credential-process --trust-anchor-arn %s --role-arn %s --profile-arn %s --private-key <file> --certificate <file> --intermediates <file>",
    awscc_rolesanywhere_trust_anchor.pca_trust_anchor.trust_anchor_arn, 
    aws_iam_role.ira_workshop_role.arn,
    awscc_rolesanywhere_profile.ira_workshop_profile.profile_arn,
    )
}
