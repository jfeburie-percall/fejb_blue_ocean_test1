pipeline {
	environment {
		def antVersion = 'Ant1.10.1'
		ANT_HOME2=tool antVersion
	}

	agent any
	stages {
		stage('Initialize') {
			steps {
				script {
					echo 'ANT_HOME = '
					withEnv( ["ANT_HOME=${tool antVersion}"] ) {
						echo ANT_HOME
					}
					echo 'ANT_HOME2 = ' + ${ANT_HOME2}
				}
			}
		}
		stage('Build') {
			steps {
				echo 'Starting Build'
				echo 'Build Complete'
			}
		}
	}
}
