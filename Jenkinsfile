
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
                doGenerateSubmoduleConfigurations: false, 
                userRemoteConfigs: [[credentialsId: 'git-cridential', url: 'https://navapon@bitbucket.org/3dsinteractive/tesco2018.git']]
              ])
            } else {
              checkout([
                $class: 'GitSCM', 
                branches: [[name: "*/${params.BRANCH}"]], 
                doGenerateSubmoduleConfigurations: false, 
                userRemoteConfigs: [[credentialsId: 'git-cridential', url: 'https://navapon@bitbucket.org/3dsinteractive/tesco2018.git']]
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

    stage('Run Container') {
      steps {
        sh "docker rm -f ${containerName} || true" 
        sh "docker run --network=mtlapizone --rm -d -e 'DB=root:password@tcp(mysql:3306)/esale' -e 'MINIO_ENDPOINT=minio:9000' -e 'MINIO_ACCESS_KEY=HA7SUZICZA2SK0LFWG71' -e 'MINIO_SECRET_KEY=UScYocFOOqBGXCW6bt8SrsYL2WOJeUqjH3OvAsPM' --name ${containerName} -p 8081:8080 ${containerName}:dev"
      }
    }
  
  }
}