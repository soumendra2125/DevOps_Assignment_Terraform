pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    stages {
        stage('Create_Infra') {
            steps {
                script {
                    git branch: 'main', url: 'https://github.com/soumendra2125/DevOps_Assignment_Terraform.git'
                    // Run Terraform to create infrastructure
                    sh '''
                    pwd
                    cd root
                    terraform init
                    terraform apply -auto-approve
                    '''
                    
                    // Get instance details
                    frontend_ip = sh(script: "terraform output Frontend_public_IP_Address", returnStdout: true).trim()
                    backend_ip = sh(script: "terraform output Backend_public_IP_Address", returnStdout: true).trim()
                    
                    echo "Frontend IP: ${frontend_ip}"
                    echo "Backend IP: ${backend_ip}"

                    // Provision instances with scripts
                    sh '''
                    terraform provisioners {
                        connection {
                            type        = "ssh"
                            user        = "ubuntu"
                            private_key = file("./laptop-keys.pem")
                            host        = "${frontend_ip}"
                        }
                        provisioner "file" {
                            source      = "frontend.sh"
                            destination = "/home/ubuntu/frontend.sh"
                        }
                        provisioner "remote-exec" {
                            inline = [
                                "chmod +x /home/ubuntu/frontend.sh",
                                "/home/ubuntu/frontend.sh"
                            ]
                        }
                    }
                    terraform provisioners {
                        connection {
                            type        = "ssh"
                            user        = "ubuntu"
                            private_key = file("./laptop-keys.pem")
                            host        = "${backend_ip}"
                        }
                        provisioner "file" {
                            source      = "backend.sh"
                            destination = "/home/ubuntu/backend.sh"
                        }
                        provisioner "file" {
                            source      = "docker-compose.yml"
                            destination = "/home/ubuntu/backend.sh"
                        }
                        provisioner "remote-exec" {
                            inline = [
                                "chmod +x /home/ubuntu/backend.sh",
                                "/home/ubuntu/backend.sh"
                            ]
                        }
                    }
                    '''
                }
            }
        }
        stage('Deploy_Apps') {
            steps {
                script {
                    // Assume the docker images have already been built and pushed to DockerHub
                    def frontend_image = 'soumendra08/frontend:1.0.0'
                    def backend_image = 'soumendra08/backend:1.0.0'

                    // Pull and run frontend container
                    sh '''
                    ssh -o StrictHostKeyChecking=no -i "laptop-keys.pem" ubuntu@${frontend_ip} "
                    sudo docker pull ${frontend_image} &&
                    sudo docker run --name frontend-app -p 80:80 ${frontend_image}
                    "
                    '''

                    // Pull and run backend container
                    sh '''
                    ssh -o StrictHostKeyChecking=no -i "laptop-keys.pem" ubuntu@${backend_ip} "
                    sudo docker pull ${backend_image} &&
                    sudo docker compose up
                    "
                    '''
                }
            }
        }
        stage('Test_Solution') {
            steps {
                script {
                    // Check if frontend is running
                    def frontend_status = sh(script: "curl -s -o /dev/null -w '%{http_code}' http://${frontend_ip}", returnStdout: true).trim()
                    if (frontend_status == '200') {
                        echo "Frontend is running"
                    } else {
                        error "Frontend is not running"
                    }

                    // Check backend by connecting to the database (adjust the connection string as needed)
                    // This assumes you have a script or a command to test the backend
                    // sh '''
                    // ssh -o StrictHostKeyChecking=no -i $PRIVATE_KEY_PATH ubuntu@${backend_ip} "
                    // PGPASSWORD=yourpassword psql -h localhost -U yourusername -d yourdatabase -c 'SELECT 1'
                    // "
                    // '''
                }
            }
        }
    }
    post {
        always {
            script {
                // Clean up Terraform resources
                sh '''
                cd terraform
                terraform destroy -auto-approve
                '''
            }
        }
        
    }
}