pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "nafees68/angular-minikube:latest"
        ARGOCD_APP_NAME = "angular-app" // Name of the Argo CD application
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo "Cloning repository...."
                git credentialsId: 'github-cred', url: 'https://github.com/abdulnafees68/project-mg1.git', branch: 'main'
                
                // List files in the workspace to verify the clone
                sh "ls -la"
                sh "ls -la k8s" // Check if the k8s folder exists
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

        stage('Trigger Argo CD Sync') {
            steps {
                echo "Triggering Argo CD sync..."
                script {
                    // Use Argo CD CLI or API to trigger a sync
                    sh """
                        argocd app sync $ARGOCD_APP_NAME
                        argocd app wait $ARGOCD_APP_NAME
                    """
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
