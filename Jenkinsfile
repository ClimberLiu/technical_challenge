pipeline {
    agent any
    stages {
        stage('Docker Build') {
            steps {
                sh "docker build -t i322669/tech-challenge:${env.BUILD_NUMBER} ."
            }
        }
        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
                    sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
                    sh "docker push i322669/tech-challenge:${env.BUILD_NUMBER}"
                }
            }
        }
        stage('Docker Remove Image') {
            steps {
                sh "docker rmi i322669/tech-challenge:${env.BUILD_NUMBER}"
            }
        }
        stage('Apply Kubernetes Files') {
            steps {
                withKubeConfig([credentialsId: 'kubeconfig']) {
                    sh 'cat k8s-tech-challenge.yaml | sed "s/{{BUILD_NUMBER}}/$BUILD_NUMBER/g" | kubectl apply -f -'
                }
            }
        }
    }
    post {
        success {
            slackSend(message: "Pipeline is successfully completed.")
        }
        failure {
            slackSend(message: "Pipeline failed!!! Please check.")
        }
    }
}