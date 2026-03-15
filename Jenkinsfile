pipeline {
    agent { label 'jenkins_node' }

    environment {
        // Use Jenkins credentials for sensitive info
        DB_CREDS = credentials('postgres-db-credentials') 
    }

    stages {
        stage('Checkout') {
            steps {
                // Pull your migrations folder and docker-compose.yml
                checkout scm 
            }
        }

        stage('Database Migration') {
            steps {
                script {
                    // Start the DB if it isn't running and trigger Flyway
                    // We override env vars here to use Jenkins secrets
                    sh """
                    POSTGRES_USER=${DB_CREDS_USR} \
                    POSTGRES_PASSWORD=${DB_CREDS_PSW} \
                    docker-compose up -d db
                    
                    POSTGRES_USER=${DB_CREDS_USR} \
                    POSTGRES_PASSWORD=${DB_CREDS_PSW} \
                    docker-compose up flyway
                    """
                }
            }
        }

        // stage('Verify') {
        //     steps {
        //         // Optional: Check if the migration was recorded in Flyway history
        //         sh "docker-compose exec -T db psql -U ${DB_CREDS_USR} -d my_app_db -c 'SELECT * FROM flyway_schema_history;'"
        //     }
        // }
    }

    post {
        always {
            // Clean up the Flyway container but keep the DB running
            sh "docker-compose rm -f flyway"
        }
        failure {
            echo "Migration failed! Check SQL syntax in your V__ files."
        }
    }
}
