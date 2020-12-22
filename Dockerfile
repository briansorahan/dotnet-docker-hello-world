FROM        mcr.microsoft.com/dotnet/core/sdk:3.1-bionic AS build
WORKDIR	    /app
COPY        . .
RUN         dotnet publish -c Release -o /app
ENTRYPOINT	["dotnet", "/app/dotnet-docker-hello-world.dll"]
