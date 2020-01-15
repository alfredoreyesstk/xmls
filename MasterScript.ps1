Write-Host "Inicio de Proceso = Masterscript Azure Devops"
set-location "c:\tmp\powerscripts\"

#validamos si no hay un proceso ya iniciado
$file = "C:\tmp\powerscripts\Estatus.txt"
$FileExists = Test-Path $file
if ($FileExists -eq $True)
{
	 Write-Host "SI existe el archivo"
	 $Estatus = get-Content $file
	Write-Host "Estatus:" + $Estatus
	if ($Estatus -eq "Procesando" ) {
		Write-Host "Procesando, no se ejecuta"
	   break
	}Else {
		Write-Host "No Procesando, SI se ejecuta"
		.\CreateLogFile.ps1 
	}
}
else
{
    Write-Host "no existe el archivo, lo creamos"
	#Creamos el archivo
	.\CreateLogFile.ps1
	#break
}

#break
#obtener los xmls de git y si hay nuevos entonces empezar el proceso
.\0_1_GetXmls.ps1

#limpiar el ambiente
.\0_CleanFolders.ps1

#Generar el codigo con codesmith
.\1_CallCodeSmith.ps1 

#Combinamos el codigo generado con la app base
.\2_GenerateApp.ps1

#Compilamos app base y nuevo codigo
.\3_CompilarApp.ps1
sleep 15

#Generamos el container de docker
#sleep 20

#ahora no se genera el docker si no se movera a un repositorio Git
#.\4_DockerCreate.ps1

#Write-Host "Mover a carpeta Git"
.\4_0_MoveToGit.ps1

#Write-Host "Push a Git"
.\5_PushToGit.ps1

#Creamos el archivo de Fin de Proceso para marcar el estatus Terminado en Estatus.txt
	 Write-Host "Estatus Terminado en Archivo Log"
	.\CreateLogFile.ps1 -Estatus "Terminado"
sleep 10
Write-Host "Fin de Proceso"



#docker ps
#Start-Process http://localhost:91/swagger/index.html
