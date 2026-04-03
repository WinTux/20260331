pipeline {
	agent any
	tools {
		terraform 'Terraform_1.9'
	}
	environment {
		APP_NAME = "ProySpring"
		JAR_PATH = "target/${APP_NAME}.jar"
		ANSIBLE_ROLE_PATH = "roles/springboot/files"
	}
	stages {
		stage('Checkout') {
			steps {
				checkout scm
			}
		}
		stage('Compilación & pruebas') {
			steps {
				dir('ProySpring') {
					sh '''
					./mvnw clean package -DskipTests=false
					mv target/ejemplo*.jar target/ProySpring.jar
					'''
				}
			}
			post {
				success {
					echo "Compilación y pruebas ... OK!"
				}
				failure {
					error("Fallaron los tests. Pipeline detenido.")
				}
			}
		}
		stage('Copiar el JAR al rol de Ansible') {
			steps {
				sh """
				cp ${JAR_PATH} ${ANSIBLE_ROLE_PATH}/ProySpring.jar
				ls -lh ${ANSIBLE_ROLE_PATH}
				"""
			}
		}
		stage('Terraform validate') {
			steps {
				withCredentials([[
                                $class: 'AmazonWebServicesCredentialsBinding',
                                credentialsId: 'aws-credentials'
                                ], file(credentialId: 'clasesdevops-pem', variable: 'AWS_KEY_FILE')]) {
                                        sh '''
                                        terraform init
					terraform validate
                                        terraform plan -var="ruta_private_key=${AWS_KEY_FILE}" -out=tfplan
                                        terraform apply -auto-approve tfplan
                                        '''
				}
			}
		}
		stage('Deploy con Ansible') {
			steps {
				sh """
				ansible-playbook -i inventory main.yml
				"""
			}
		}
		stage('Terraform Destroy') {
			steps {
				input message: "Deseas destruir la infraestructura?"
				withCredentials([[
                                $class: 'AmazonWebServicesCredentialsBinding',
                                credentialsId: 'aws-credentials'
                                ], file(credentialId: 'clasesdevops-pem', variable: 'AWS_KEY_FILE')]) {
					sh """
					terraform destroy -auto-approve -var="ruta_private_key=${AWS_KEY_FILE}"
				}	"""
			}
		}
	}
	post {
		success {
			echo "Pipeline completado correctamente."
		}
		failure {
			echo "Error en el pipeline."
		}
	}
}
