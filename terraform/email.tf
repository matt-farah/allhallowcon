######## SES Zone configuration and verification ########
resource "aws_ses_domain_identity" "allhallowcon_com" {
    domain = "allhallowcon.com"
}

# Route 53 DNS record to verify the email address
resource "aws_route53_record" "photobooth_verification" {
    zone_id = aws_route53_zone.allhallowcon_com.id
    name = "_amazonses.${aws_ses_domain_identity.allhallowcon_com.id}"
    type = "TXT"
    ttl = 300
    records = [aws_ses_domain_identity.allhallowcon_com.verification_token]
}

resource "aws_ses_domain_identity_verification" "photobooth_verification" {
    domain = aws_ses_domain_identity.allhallowcon_com.id
    depends_on = [ aws_route53_record.photobooth_verification ]
}

######## SES destination emails ########

resource "aws_ses_email_identity" "george" {
    email = "duplico@dupli.co"
}

######## SES Email Identity and policy ########

resource "aws_iam_user" "photobooth_user" {
    name = "PhotoboothEmailUser"
}

resource "aws_iam_access_key" "photobooth_key" {
    user = aws_iam_user.photobooth_user.name
}

data "aws_iam_policy_document" "policy_document" {
    statement {
        actions   = ["ses:SendEmail", "ses:SendRawEmail"]
        resources = [aws_ses_domain_identity.allhallowcon_com.arn, aws_ses_email_identity.george.arn]
        # condition {
        #     test     = "StringEquals"
        #     variable = "ses:FromAddress"
        #     values   = ["printer@1512.link"]
        # }
    }
}

resource "aws_iam_policy" "photobooth_policy" {
    name   = "PhotoboothEmailPolicy"
    policy = data.aws_iam_policy_document.policy_document.json
}

resource "aws_iam_user_policy_attachment" "user_policy" {
    user       = aws_iam_user.photobooth_user.name
    policy_arn = aws_iam_policy.photobooth_policy.arn
}

######## Credential output ########

output "smtp_username" {
    value = aws_iam_access_key.photobooth_key.id
}

output "smtp_password" {
    value     = aws_iam_access_key.photobooth_key.ses_smtp_password_v4
    sensitive = true
}
