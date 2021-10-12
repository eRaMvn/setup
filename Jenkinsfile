pipeline {
    agent any
    parameters {
        string(name: 'folder_name', description: 'Folder to store all of the file results into')
        string(name: 'organization', description: 'The name of the organization')
        string(name: 'email', description: 'The email to send the report to. Default is security-monitoring@csod.com', defaultValue: 'security-monitoring@csod.com')
        string(name: 'security_account_id', description: 'Account ID of the security account', defaultValue: '647707365366')
        string(name: 'logging_account_id', description: 'Account ID of the logging account', defaultValue: '681260366894')
        string(name: 'dome9_bundle_id', description: 'The bundle id to run', defaultValue: '191804')
    }
    environment {
        dome9_id = credentials('dome9_id')
    }
    stages {
        stage('Clean up the workspace') {
            steps {
                sh  """
                rm *.json || echo 'No json file exist in current directory'
                rm *.csv || echo 'No csv file exist in current directory'
                rm *.xlsx || echo 'No xlsx file exist in current directory'
                """
            }
        }
        stage('Run Dome9 Assessment') {
            steps {
                sh  "python3 run_dome9_scan.py -i ${params.account_id} -k $dome9_id -s $dome9_secret -b ${params.dome9_bundle_id}"
            }
        }
        stage('Run custom checks') {
            parallel {
                stage('Check if account is enrolled to Dome9') {
                    steps {
                        sh "python3 check_dome9_enrollment.py -i ${params.account_id} -k $dome9_id -s $dome9_secret"
                    }
                }
                stage('Check if GuardDuty is enabled') {
                    steps {
                        sh "python3 check_guardduty.py -i ${params.account_id} -si ${params.security_account_id} -r ${params.region} -n security-guardduty-check"
                    }
                }
                stage('Check if itsec role exists in the account') {
                    steps {
                        sh "python3 check_itsec_role_exists.py -i ${params.account_id} -n security-validation-role"
                    }
                }
                stage('Check if CF stacks deployed with PLK') {
                    steps {
                        sh "python3 check_cf_stack.py -i ${params.account_id} -r ${params.region} -n security-validation-role"
                    }
                }
                stage("Check svc-tenable's permissions") {
                    steps {
                        sh "python3 check_svc_tenable.py -i ${params.account_id} -n security-validation-role"
                    }
                }
                stage("Check console access") {
                    steps {
                        sh "python3 check_console_access.py -i ${params.account_id} -n security-validation-role"
                    }
                }
                stage("Check if vpc flow log is centralized") {
                    steps {
                        sh "python3 check_vpc_flow_log_centralization.py -i ${params.account_id} -li ${params.logging_account_id} -r ${params.region} -n security-validation-role -l security-account-validator"
                    }
                }
                stage("Check cloudtrail configuration") {
                    steps {
                        sh "python3 check_trail_config.py -i ${params.account_id} -li ${params.security_account_id} -r ${params.region} -n security-validation-role -l security-account-validator"
                    }
                }
                stage("Check approved users and roles") {
                    steps {
                        sh "python3 check_approved_iam.py -i ${params.account_id} -n security-validation-role"
                    }
                }
                stage("Check role integration with Okta") {
                    steps {
                        sh "python3 check_okta_group.py -i ${params.account_id} -n security-validation-role -k $dome9_id -s $dome9_secret -oo $okta_office_api -om $okta_mgmt_api"
                    }
                }
                stage("Validate Instance IQ") {
                    steps {
                        sh "python3 check_instance_iq_status.py -i ${params.account_id} -r ${params.region} -n security-validation-role"
                    }
                }
                stage("Validate Aurora Revocation Lambda") {
                    steps {
                        sh "python3 check_aurora_revocation_lambda.py -i ${params.account_id} -r ${params.region} -n security-validation-role"
                    }
                }
            }
        }
        stage('Generate report') {
            steps {
                sh "python3 generate_report.py -i ${params.account_id} -k $dome9_id -s $dome9_secret -b ${params.dome9_bundle_id}"
            }
        }
        stage('Send email') {
            steps {
                sh "echo 'Please see the attached files for the validation result' | mail -s 'Validation result for ${params.account_id}' -a security_validation_report.xlsx ${params.email}"
            }
        }
    }
}
