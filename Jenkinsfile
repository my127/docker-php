pipeline {
    agent none
    options {
        buildDiscarder(logRotator(daysToKeepStr: '30'))
    }
    environment {
        COMPOSE_DOCKER_CLI_BUILD = 1
        DOCKER_BUILDKIT = 1
    }
    triggers { cron(env.BRANCH_NAME ==~ /^main$/ ? 'H H(0-6) 1 * *' : '') }
    stages {
        stage('Matrix') {
            matrix {
                axes {
                    axis {
                        name 'BUILD'
                        // values 'php56|php70', 'php71|php72', 'php73|php74', 'php80|php81', 'php82'
                        values 'php83'
                    }
                    axis {
                        name 'PLATFORM'
                        values 'linux-amd64', 'linux-arm64'
                    }
                }
                environment {
                    TAG_SUFFIX = "-${PLATFORM}"
                }
                stages {
                    stage('Build, Test, Publish') {
                        agent { label "${PLATFORM}" }
                        stages {
                            stage('Build') {
                                steps {
                                    sh './build.sh'
                                }
                            }
                            stage('Test') {
                                steps {
                                    sh './test.sh'
                                }
                            }
                            stage('Publish') {
                                environment {
                                    DOCKER_REGISTRY_CREDS = credentials('docker-registry-credentials')
                                }
                                when {
                                    branch 'main'
                                }
                                steps {
                                    sh 'echo "$DOCKER_REGISTRY_CREDS_PSW" | docker login --username "$DOCKER_REGISTRY_CREDS_USR" --password-stdin docker.io'
                                    sh 'docker compose config --services | grep -E "${BUILD}" | xargs docker compose push'
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
                                sh 'docker compose down -v --rmi local'
                                cleanWs()
                            }
                        }
                    }
                }
            }
        }
        stage('Publish main image') {
            agent { label "linux-amd64" }
            environment {
                DOCKER_REGISTRY_CREDS = credentials('docker-registry-credentials')
            }
            when {
                branch 'main'
            }
            steps {
                sh './manifest-push.sh'
            }
            post {
                always {
                    sh 'docker logout docker.io'
                    cleanWs()
                }
            }
        }
    }
}
