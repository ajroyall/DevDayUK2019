# Azure Functions

## About this Solution
### LOANAMORT
A procedural cobol program compiled to .NET
### LOANAMORTSCREENS
.NET console application providing a screen set for a user to call the LOANAMORT program
### LoanAmortFunctions
C# project that produces the Azure function
### LoanAmortUnitTests
.NET MFUnit project that tests the LOANAMORT program
### LoanAmortWebUI
.NET Core web application running a React.js front end - pending rewrite without node.js
### LoanAmortWpfClient
COBOL WPF project - pending removal?

## Software Requirements
1. Visual Studio 2017 (I'm currently using version 15.8.7)
2. Azure Workflow for Visual Studio
3. Visual COBOL for Visual Studio 2017 4.0 or Enterprise Developer for Visual Studio 2017 4.0
4. Docker for windows (Possible not needed if building on Azure DevOps)
NB Azure DevOps was previously called Visual Studio Team Services (VSTS)

## Other Prerequisites
Azure account/Microsoft account
DockerHub account (I'm not sure this is strictly necessary, but I wasn't able to download docker windows without signing up)

## Getting the source code
* Download as zip or git clone from here - https://github.com/cobol-cloud/vs-demo (Not up to date atm)

## Version Control 
The version control is optional, if you aren't interested in the Continuous Integration/Deployment, it's enough to have a local copy of the code on your machine.
* Create a new organization & project on Azure DevOps (previously Visual Studio Team Services)
    * https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/create-organization?view=vsts
    * https://docs.microsoft.com/en-us/azure/devops/organizations/projects/create-project?view=vsts&tabs=new-nav
* Check out using Visual Studio - https://docs.microsoft.com/en-us/azure/devops/user-guide/work-team-explorer?view=vsts
* Copy source code into check-out and commit (and push changed to remote repo)

## Building and Running
* Rebuild solution

### "Original" application
DotNet compiled Screenset based GUI for running the Cobol Program.
* Start debugging the LOANAMORTSCREENS project

### Functions + WebApp
Note: In order to call the functions from a JavaScript webapp, CORS needs to be enabled on the functions deployment. This is handled locally with the local.settings.json file

Azure functions API and a separate .NET Core web application using the React.js framework
* Start debugging the LoanAmortFunctions project
    * Using a web browser go to the following URL: http://localhost:7071/api/Function1?p=10000&t=24&r=2.6 (the port might be different, the Functions console will list the URL)
* Start debugging the LoanAmortWebUI application
    * Page should automatically open in a browser when ready.
    * Use the locally hosted functions URL in the top field: http://localhost:7071/api/Function1 (Don't include query parameters, these will be appended by the input fields)
* Run the tests
    * Using the Micro Focus Unit Testing Tool Window (if it's not already open, from the View menu, select "Micro Focus Unit Testing")
    * Select "Run All"

## Setup & Deploy to Azure App Service
Note: In order to call the functions from a JavaScript webapp, CORS needs to be enabled on the functions deployment. This can be done using the platform settings page - https://docs.microsoft.com/en-us/azure/azure-functions/functions-how-to-use-azure-function-app-settings#cors

We're only deploying the functions app here. While setting up the App Service, it's worth also setting up Application Insights (This can also be done later - https://docs.microsoft.com/en-us/azure/azure-functions/functions-monitoring)
* This can be done through the portal or the IDE, note if you use the portal you'll still end up using the IDE to deploy
    * Portal
        * How To - https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-first-azure-function
        * Follow the IDE steps for publishing
    * IDE
        * Ensure that Visual Studio is logged in with your Microsoft/Azure account
        * How To -  https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-your-first-function-visual-studio
    * The MF_DOTNET_PLATFORM environment variable needs to be set with the value "Azure" (No Quotes) on the Azure App Server (this issue might be specific to Azure Functions, as there is no web.config) - https://docs.microsoft.com/en-us/azure/azure-functions/functions-how-to-use-azure-function-app-settings#manage-app-service-settings

## Running from Azure
Once it's been deployed the easiest way to test is using the function URL within a web browser, alternatively you can plug the URL into WPF application and test it that way. You can get the Function URL from the function page on the Azure portal - https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-first-azure-function (In the first image, the "</> Get Function URL" link near the top right of the page)

# Continuous Integration/Deployment (Dedicated Build Agent)
## Creating a Build Agent
* Create a new Windows VM on Azure - https://docs.microsoft.com/en-us/azure/virtual-machines/windows/quick-create-portal
* Install the required software
    * Visual Studio Build Tools
    * Visual COBOL Build Tools 4.0
    * A Visual COBOL License (Trial license will work for 60 days, otherwise you'll need a full license. If you want to use Personal Edition, you'll need to install the full Visual Studio and Visual COBOL programs in order to use the GUI interfaces for requesting the licence - TODO need to confirm)
    * (Optional) Required for deployment
        * When deploying an Azure Function, the application will require the managed runtime and a some other assemblies, these are added as references in the function project which means that they will be copied into the output folder when building the project and subsequently deployed alongside the functions app.
        * If you look at the *.csproj file for the LoanAmortFunctions project you'll see references to MicroFocus.COBOL.Runtime.dll and other Micro Focus dlls. The references will have a hint path which points to where it's locating these files on your local machine. Assuming the build agent has Visual COBOL Build Tools, rather than the full Visual COBOL or Enterprise Developer products installed, this hint path will be different on the BuildAgent. You will need to manually create this hint path on the Build Agent VM and copy all of these files here.
    * VSTS Agent - https://docs.microsoft.com/en-us/vsts/pipelines/agents/v2-windows?view=vsts
* Configure the VSTS Agent - https://docs.microsoft.com/en-us/vsts/pipelines/agents/v2-windows?view=vsts

## VSTS Build Pipeline
Point to repository (VSTS/GitHub) - https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started-designer?view=vsts&tabs=new-nav
* Use Node (6.4.x) - Required for building of WebUI application
* Use Nuget (4.4.1) - Required for building of WebUI application
* Nuget Restore
* Visual Studio build step - https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/build/visual-studio-build?view=vsts
* Command line step - mfurunil.exe to run tests and generate NUnit results - https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/utility/command-line?view=vsts&tabs=yaml
* Publish Test Results step - https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/test/publish-test-results?view=vsts&tabs=yaml
* Publish Artifact - https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/utility/publish-build-artifacts?view=vsts
* (optional) Azure App Service Deploy - https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/deploy/azure-rm-web-app-deployment?view=vsts
    * The app service deploy can be done as part of the build, however I think this is generally for automatic deployment to UAT/staging systems. For proper control over the release management process, you'll want to create a separate release pipeline so that you can control which builds are deployed into production.

## VSTS Release Pipeline
New Release
* Azure App Service Deploy
    * Using build artifact
    * Point to Azure App Service

# Continuous Integration/Deployment (Hosted with Docker)
Azure DevOps allows you to build in the cloud using Hosted Build Agents - https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/hosted?view=vsts&tabs=yaml
These build agents are virtual machines that are provisioned on demand and then shutdown and deleted after the build completes (or after a 30 minute timeout, this is important later). There are 6 different agents that come with a variety of software pre-installed, one of which is a Windows Container image that comes with docker. - https://github.com/Microsoft/azure-pipelines-image-generation/blob/master/images/win/WindowsContainer1803-Readme.md
Looking at the change history, it doesn't look like this page is updated much. I've found the current information on the Azure DevOps site. I can't find a direct link to this information, but if you look at the project settings page on Azure DevOps, there is an "Agent pools" page, in the list of pools is the "Hosted Windows Container", select this and then view the details tab (near the top of the contents container) and this looks like the right version.

1. Create an Azure Container Registry (ACR)
2. Build docker container & push to ACR
3. Create, Update and run a YAML build pipeline
4. Deploy using an Azure release pipeline

## Create an Azure Container Registry (ACR)
Create a private ACR on the azure portal - https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-portal

## Building the docker container
Note: This is where the process gets slightly iffy. It's really important that the docker image we create is based on a specific version of the microsoft/dotnet-framework image. The actual version will change over time as microsoft update the Hosted Build Agents.

Why is a specific version needed? The hosted build agents we'll be using are done using a fresh Virtual Machine for each build, which means the agent will need to pull our docker image every single time. Each build has a 30 minute timeout, which isn't long enough to pull all the layers of the Docker image. However, the agent has some pre-cached docker images on it which greatly reduces the time it takes to pull and run our image. Using the cached base image has reduced the pull and run time from over 30 minutes to ~6 minutes, which leaves plenty of time to do the actual build.

Note: Building/running windows containers on a host machine with an earlier version of windows is generally incompatible - https://docs.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/version-compatibility
If you have a new enough version of windows (>1803) you can build the docker container image locally. I've ended up using Azure DevOps to first build the docker container that will then be used for the build. 

## Building the docker container with Azure DevOps
Note: In order to build the docker image in the cloud, I needed a way to get the installers and dockerfile onto the build agent. I couldn't quite work out how to get an Azure fileshare working, so ended up creating a new git repository and just dumping the files into there. This probably needs revisiting...

1. In the AmortLoan project, create a new git repo (DockerBuildImage)
2. Commit the installers, dockerfile and license file to the repository. (Note: the web UI doesn’t allow files larger than 20mb to be committed, but you can get around this size limit by using a git client/visual studio to commit the changes).
3. Created a build pipeline
    a. Docker build step to build the image
    b. Docker push step to upload the image to the ACT

## Azure DevOps Build Pipeline
The source code repository contains a YAML file which defines the build pipeline. - https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started-yaml?view=vsts
The build pipeline we are using is refered to as a container job. Rather than running the build directly within a Hosted build agent, it runs the build within a docker container that is running on the Hosted Windows Container Agent - https://docs.microsoft.com/en-us/azure/devops/pipelines/process/container-phases?view=vsts&tabs=yaml

For reference, these are the tasks that the pipeline makes use of
* Use Nuget (4.4.1) - Required for building of functions application
* Nuget Restore
* Visual Studio build step - https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/build/visual-studio-build?view=vsts
* Command line step - mfurunil.exe to run tests and generate NUnit results - https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/utility/command-line?view=vsts&tabs=yaml
* Publish Test Results step - https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/test/publish-test-results?view=vsts&tabs=yaml
* Publish Artifact - https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/utility/publish-build-artifacts?view=vsts

1. Create a build pipeline using the AmortLoans repository as the source. Use a YAML configuration and point it at the "azure-pipelines.yml" file

## VSTS Release Pipeline
Create a new release pipeline - https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started-designer?view=vsts&tabs=new-nav#create-a-release-pipeline
* Azure App Service Deploy
    * Using build artifact
    * Point to Azure App Service

# Problems to Solve
1. How do we recommend customer builds docker image? and subsequently keeps it up-to-date?
2. What dockerfile and binaries are we supplying to the customer? What about license file (I've stored it in my git repo, azure dev-ops has secure file storage, should it be uploaded there)?
3.Capacity issues, during period of high demand, disk I/O on the hosted build agents seems to really suffer which can lead to very slow builds/potential time outs(Not really much we can do, but it's good to be aware of this)