pipeline {
	environment {
		def antVersion = 'Ant1.9.9'
	}

	agent any
	stages {
		stage('Initialize') {
			steps {
				bitbucketStatusNotify(buildState: 'INPROGRESS')
				echo 'Notifying Starting to Developers'
				notifyBuild('STARTED')
				withEnv( ["ANT_HOME=${tool antVersion}"] ) {
					echo 'ANT_HOME = ' + ANT_HOME
					bat(/"$ANT_HOME\bin\ant.bat" -version/)
				}
				echo 'env.BRANCH_NAME  = ' + BRANCH_NAME
				echo 'env.BUILD_NUMBER = ' + BUILD_NUMBER
				echo 'env.JOB_NAME     = ' + JOB_NAME
				echo 'env.JENKINS_HOME = ' + JENKINS_HOME
				echo 'env.WORKSPACE    = ' + env.WORKSPACE
			}
		}
		stage('Build') {
			steps {
				echo 'Starting Build'
				withEnv( ["ANT_HOME=${tool antVersion}"] ) {
					bat(/"$ANT_HOME\bin\ant.bat" -file "$env.WORKSPACE\DELIVERY\ac4_acme\build.xml"  && exit %%ERRORLEVEL%%/)
				}
				echo 'Build Complete'
			}
		}
	}
	post {
//		always {
			// Run regardless of the completion status of the Pipeline run.
//		}
//		changed {
			// Only run if the current Pipeline run has a different status from the previously completed Pipeline.
//		}
		failure {
			// Only run if the current Pipeline has a "failed" status, typically denoted in the web UI with a red indication.
			echo 'Notifying Failure to Bitbucket'
			bitbucketStatusNotify(buildState: 'FAILED')
			echo 'Notifying Failure to Developers'
			notifyBuild('FAILED')
		}
		success {
			// Only run if the current Pipeline has a "success" status, typically denoted in the web UI with a blue or green indication.
			echo 'Build Sucessfull, Archiving Artifacts to Jenkins'
			archiveArtifacts artifacts: 'build/*.zip'
			echo 'Notifying Success to Bitbucket'
			bitbucketStatusNotify(buildState: 'SUCCESSFUL')
			echo 'Notifying Success to Developers'
			notifyBuild(buildState: 'SUCCESSFUL')
		}
//		unstable {
			// Only run if the current Pipeline has an "unstable" status, usually caused by test failures, code violations, etc. Typically denoted in the web UI with a yellow indication.
//		}
//		aborted {
			// Only run if the current Pipeline has an "aborted" status, usually due to the Pipeline being manually aborted. Typically denoted in the web UI with a gray indication
//		}
	}

}

def notifyBuild(String buildStatus = 'STARTED') {
	// build status of null means successful
	buildStatus =  buildStatus ?: 'SUCCESSFUL'
	
	// Default values
	def colorName = 'RED'
	def colorCode = '#FF0000'
	def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
	def summary = "${subject} (${env.BUILD_URL})"
	def details = """<p>${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
	<p>Check console output at "<a href="${env.BUILD_URL}">${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>"</p>"""
	
	// Override default values based on build status
	if (buildStatus == 'STARTED') {
	color = 'YELLOW'
	colorCode = '#FFFF00'
	} else if (buildStatus == 'SUCCESSFUL') {
	color = 'GREEN'
	colorCode = '#00FF00'
	} else {
	color = 'RED'
	colorCode = '#FF0000'
	}
	
	// Send notifications
//	slackSend (color: colorCode, message: summary)
	
//	hipchatSend (color: color, notify: true, message: summary)
	
	emailext (
		subject: subject,
		body: details,
		recipientProviders: [[$class: 'DevelopersRecipientProvider']]
	)
 }

