pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "nafees68/angular-minikube:latest"
        WEB_URL = "http://192.168.49.2:30001" // Replace with your service URL
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo "Cloning repository...."
                git credentialsId: 'github-cred', url: 'https://github.com/abdulnafees68/project-mg1.git', branch: 'main'
                
                // List files in the workspace to verify the clone
                sh "ls -la"
            }
        }

        stage('Install Dependencies') {
            steps {
                echo "Installing dependencies..."
                sh "npm ci"
            }
        }

        stage('Build Angular App') {
            steps {
                echo "Building Angular app..."
                sh "npm run build -- --configuration production --build-optimizer --aot"
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t $DOCKER_IMAGE ."
                
                withCredentials([usernamePassword(credentialsId: 'docker-hub-password', usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                    echo "Logging in to Docker Hub..."
                    sh """
                        echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin
                        docker push $DOCKER_IMAGE
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo "Deploying to Kubernetes..."
                sh """
                    pwd
                    ls -la
                    kubectl apply -f k8s/deployment.yml
                    kubectl apply -f k8s/service.yml
                    kubectl rollout status deployment/angular-app
                """
            }
        }

        stage('Check if Webpage is Running') {
            steps {
                script {
                    echo "Checking if webpage is up..."
                    retry(5) {
                        sleep 10 // Wait for 10 seconds before checking
                        def response = sh(script: "curl --write-out '%{http_code}' --silent --output /dev/null $WEB_URL", returnStdout: true).trim()
                        if (response == '200') {
                            echo "Webpage is up and running!"
                        } else {
                            error "Webpage is not accessible. HTTP response code: $response"
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            sh 'docker system prune -f'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed, investigate errors above.'
        }
    }
}
