resource "awscc_rolesanywhere_trust_anchor" "pca_trust_anchor" {
  depends_on = [
    aws_acmpca_certificate_authority.ira_root_ca
  ]
  name    = "acm-pca_trust_anchor"
  enabled = true
  source = {
    source_type = "AWS_ACM_PCA"
    source_data = {
      acm_pca_arn = aws_acmpca_certificate_authority.ira_root_ca.arn
    }
  }
}

resource "awscc_rolesanywhere_profile" "ira_workshop_profile" {
  depends_on = [
    aws_acmpca_certificate.intermediate
  ]
  name                        = "ira_workshop_profile"
  role_arns                   = [aws_iam_role.ira_workshop_role.arn]
  duration_seconds            = 3600
  require_instance_properties = false
  enabled                     = true
}

output "acm_trust_anchor_arn" {
  value = awscc_rolesanywhere_trust_anchor.pca_trust_anchor.trust_anchor_arn
}

output "ira_workshop_profile" {
  value = awscc_rolesanywhere_profile.ira_workshop_profile.profile_arn
}

