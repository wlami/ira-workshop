# First define the root CA

resource "aws_acmpca_certificate_authority" "ira_root_ca" {
  type = "ROOT"

  certificate_authority_configuration {
    key_algorithm     = "RSA_4096"
    signing_algorithm = "SHA512WITHRSA"

    subject {
      organization = "Example Corp."
      country      = "DE"
      locality     = "Munich"
      state        = "Bavaria"
      common_name  = "iamrolesanywhere-workshop-root-ca"
    }
  }
}

# Create a certificate that is based on a root CA template (x.509 extensions for CAs)

resource "aws_acmpca_certificate" "ira_root_ca_certificate" {
  certificate_authority_arn   = aws_acmpca_certificate_authority.ira_root_ca.arn
  certificate_signing_request = aws_acmpca_certificate_authority.ira_root_ca.certificate_signing_request
  signing_algorithm           = "SHA512WITHRSA"

  template_arn = "arn:${data.aws_partition.current.partition}:acm-pca:::template/RootCACertificate/V1"

  validity {
    type  = "DAYS"
    value = 7
  }
}

# Associate the certificate with the CA

resource "aws_acmpca_certificate_authority_certificate" "root_ca_association" {
  certificate_authority_arn = aws_acmpca_certificate_authority.ira_root_ca.arn

  certificate       = aws_acmpca_certificate.ira_root_ca_certificate.certificate
  certificate_chain = aws_acmpca_certificate.ira_root_ca_certificate.certificate_chain
}

# ----------------------

# Now let's define our intermediate CA that is going to issue our client certificates
resource "aws_acmpca_certificate_authority" "intermediate" {
  type = "SUBORDINATE"

  certificate_authority_configuration {
    key_algorithm     = "RSA_2048"
    signing_algorithm = "SHA512WITHRSA"

    subject {
      organization        = "Example Corp."
      organizational_unit = "DEMO OU"
      country             = "DE"
      locality            = "Munich"
      state               = "Bavaria"
      common_name         = "intermediate-ca-ira"
    }
  }
}

# Define the x.509 parameters for the intermediate CA

resource "aws_acmpca_certificate" "intermediate" {
  certificate_authority_arn   = aws_acmpca_certificate_authority.ira_root_ca.arn
  certificate_signing_request = aws_acmpca_certificate_authority.intermediate.certificate_signing_request
  signing_algorithm           = "SHA512WITHRSA"


  template_arn = "arn:${data.aws_partition.current.partition}:acm-pca:::template/SubordinateCACertificate_PathLen0/V1" # PathLen0 = only issue end entity certificates

  validity {
    type  = "DAYS"
    value = 6
  }
}

# And associate the cert with the intermediate CA

resource "aws_acmpca_certificate_authority_certificate" "intermediate" {
  certificate_authority_arn = aws_acmpca_certificate_authority.intermediate.arn
  certificate               = aws_acmpca_certificate.intermediate.certificate
  certificate_chain         = aws_acmpca_certificate.intermediate.certificate_chain
}
