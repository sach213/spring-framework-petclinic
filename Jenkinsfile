node	{
    def app

    environment {
        // Define environment variables
        AWS_REGION = 'ap-south-1' // Specify your AWS region
        ECR_REPOSITORY = 'dev/ecommerce_pos'  // Replace with your ECR repository name
        ECR_URI = "116981781220.dkr.ecr.ap-south-1.amazonaws.com/dev/ecommerce_pos"  // ECR URI format
        IMAGE_NAME = 'pos-billing' // Docker image name
        IMAGE_TAG = 'latest' // Docker image tag
        KUBECONFIG = '/path/to/kubeconfig' // Path to your kubeconfig for EKS
    }

    stage('Clone repository') {
        checkout scm
    }

        stage("Package jar file with Maven"){
            dir('spring-framework-petclinic'){
                sh "mvn clean package -DskipTests"
                sh "ll"
                sh "pwd"
                sh "ls"
            }
        }
	
    stage('Build image with Docker') {
        dir('Ecommerce_POS-master/PosBilling') {
            app = docker.build("pos-billing:${env.BUILD_NUMBER}")
	    sh "docker ps"
        }
    }

        stage('Login to AWS ECR') {
            steps {
                script {
                    // Login to AWS ECR using the AWS CLI
                    sh '''
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_URI}
                    '''
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                script {
                    // Push Docker image to ECR
                    sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ECR_URI}:${IMAGE_TAG}"
                    sh "docker push ${ECR_URI}:${IMAGE_TAG}"
                }
            }
        }
   stage("Deploy to Dev?") {
        dir('Ecommerce_POS-master/PosBilling/kubernetes') {
		      def namespace = "dev"

               def imagetag="${env.BUILD_NUMBER}"
               deploy(namespace,imagetag)    
        }
    }

}

def deploy(namespace,imagetag) {
    // Create a copy for this environment
    sh "cp deployment.yaml deployment.${namespace}.yaml"
    sh "cp namespace.yaml namespace.${namespace}.yaml"
    sh "cp service.yaml service.${namespace}.yaml"


    // String replace namespaces
    sh "sed -i.bak s/XX_NAMESPACE_XX/$namespace/g deployment.${namespace}.yaml"
    sh "sed -i.bak s/XX_NAMESPACE_XX/$namespace/g namespace.${namespace}.yaml"
    sh "sed -i.bak s/XX_NAMESPACE_XX/$namespace/g service.${namespace}.yaml"               
              


    // Create namespace
    kubectl(namespace, "apply -f namespace.${namespace}.yaml")

    // String replace the image name in the deployment and create the deployment
    sh "sed -i.bak s/XX_IMAGETAG_XX/$imagetag/g deployment.${namespace}.yaml"
    kubectl(namespace, "apply -f deployment.${namespace}.yaml")
        
    // Create service
    kubectl(namespace, "apply -f service.${namespace}.yaml")  
 
}

def kubectl(namespace,cmd) {
    return sh(script: "kubectl --kubeconfig /var/lib/jenkins/config --namespace=${namespace} ${cmd}", returnStdout: true)
 }
