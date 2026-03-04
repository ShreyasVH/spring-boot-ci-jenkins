def VERSION = ''
pipeline {
    agent any

    stages {
      stage("Show Details") {
        steps {
          script {
            echo env.BRANCH_NAME

            env.VERSION = sh(
              script: 'mvn -q -Dexec.executable=echo -Dexec.args=\'${project.version}\' --non-recursive exec:exec',
              returnStdout: true
            ).trim()

             echo "VERSION=${env.VERSION}"
          }
        }
      }

      stage("Build image") {
        when {
          expression {
            return env.BRANCH_NAME == 'main'
          }
        }
        steps {
          script {
            sh """
                docker build --build-arg VERSION=${env.VERSION} -t spring-boot-ci-jenkins .
            """
          }
        }
      }

      stage("Tag image") {
        when {
          expression {
            return env.BRANCH_NAME == 'main'
          }
        }
        steps {
          script {
            sh "docker tag spring-boot-ci-jenkins shreyasvh/spring-boot-ci-jenkins:${env.VERSION}"
            sh 'docker tag spring-boot-ci-jenkins shreyasvh/spring-boot-ci-jenkins:latest'

            sh 'docker images'
          }
        }
      }

      stage("Docker login") {
        when {
          expression {
            return env.BRANCH_NAME == 'main'
          }
        }
        steps {
          script {
            withCredentials([usernamePassword(
              credentialsId: 'docker-creds',
              usernameVariable: 'DOCKER_USERNAME',
              passwordVariable: 'DOCKER_PASSWORD'
            )]) {
              sh '''
                echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
              '''
            }
          }
        }
      }

      stage("Docker push") {
        when {
          expression {
            return env.BRANCH_NAME == 'main'
          }
        }
        steps {
          script {
            sh "docker push shreyasvh/spring-boot-ci-jenkins:${env.VERSION}"
            sh 'docker push shreyasvh/spring-boot-ci-jenkins:latest'
          }
        }
      }
    }
}
