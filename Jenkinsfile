
def dockerImage

pipeline{
  agent any

  triggers {
    pollSCM('* * * * *')
  }

  environment {
    root = tool name: 'GO_1.11.1', type: 'go'
    registryCredential = 'dockerhub'
    containerName = 'play-golang'
    scannerHome = tool 'sonar'
    gitRepo = 'https://github.com/Navapon/play-golang1.11.git'
  }

  parameters {
        string(name: 'TAG', defaultValue: '', description: 'Input your tags to deploy')
        string(name: 'BRANCH', defaultValue: 'dev-docker', description: 'Input your branch to deploy ')
  }

  stages {
    stage('Git checkout tags') {
        steps {
          script {
            if (params.TAG != '') {
              checkout([
                $class: 'GitSCM', 
                branches: [[name: "refs/tags/${params.TAG}"]], 
                userRemoteConfigs: [[credentialsId: 'git-cridential', url: gitRepo]]
              ])
            } else {
              checkout([
                $class: 'GitSCM', 
                branches: [[name: "*/${params.BRANCH}"]], 
                userRemoteConfigs: [[credentialsId: 'git-cridential', url: gitRepo]]
              ])
            }
          }
        }
    }

    stage('Run GO Test') {
      steps{
        withEnv(["GOROOT=${root}", "PATH+GO=${root}/bin"]) {
          sh 'go version'
          sh 'GO111MODULE=on go mod download'
          sh 'CGO_ENABLED=0 go test ./... -coverprofile=coverage.out'
          sh 'ls -l'
        }
      }
    }

    stage('SonarQube analysis') {
      steps {
        withSonarQubeEnv('SONAR_SERVER') {
          sh "${scannerHome}/bin/sonar-scanner"
        }
      }
    }
   
    stage('Building Docker Image') {
      steps {
        script {
          dockerImage = docker.build(containerName + ":dev",'./')
        }
      }
    }

    stage("Shiping Docker Image") {
      steps {
        script {
          docker.withRegistry('',registryCredential) {
            dockerImage.push()
          }
        }
      }
    }

    stage("Deploying ") {
      steps {
          sh """
                
          """
      }
    }
  }
}