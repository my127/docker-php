pipeline {
    agent none
    options {
        buildDiscarder(logRotator(daysToKeepStr: '30'))
    }
    triggers { cron(env.BRANCH_NAME ==~ /^main$/ ? 'H H(0-6) 1 * *' : '') }
    environment {
        BUILDKIT_PROGRESS = 'plain'
    }
    stages {
        stage('Matrix') {
            matrix {
                axes {
                    axis {
                        name 'BUILD'
                        // values 'php56 php70', 'php71 php72', 'php73 php74', 'php80'
                        values 'php80'
                    }
                }
                stages {
                    stage('Build, Test, Publish') {
                        agent { label 'my127ws-preview' }
                        stages {
                            stage('Setup') {
                                steps {
                                    script {
                                        sh 'docker run --rm --privileged multiarch/qemu-user-static --reset -p yes'
                                        env.CONTEXT = sh(script: 'docker buildx create --use', returnStdout: true).trim()
                                    }
                                }
                            }
                            stage('Build') {
                                steps {
                                    sh './build.sh'
                                }
                            }
                            // stage('Test') {
                            //     steps {
                            //         sh './test.sh'
                            //     }
                            // }
                            stage('Publish') {
                                environment {
                                    DOCKER_REGISTRY_CREDS = credentials('docker-registry-credentials')
                                }
                                when {
                                    branch 'main'
                                }
                                steps {
                                    sh 'echo "$DOCKER_REGISTRY_CREDS_PSW" | docker login --username "$DOCKER_REGISTRY_CREDS_USR" --password-stdin docker.io'
                                    sh './build.sh --push'
                                }
                                post {
                                    always {
                                        sh 'docker logout docker.io'
                                    }
                                }
                            }
                        }
                        post {
                            always {
                                sh 'docker buildx rm "${CONTEXT}"'
                                cleanWs()
                            }
                        }
                    }
                }
            }
        }
    }
}
