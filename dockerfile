FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app
COPY *.csproj ./
RUN dotnet restore
COPY . ./
RUN dotnet publish -c Release -o out


FROM mcr.microsoft.com/dotnet/aspnet:8.0

WORKDIR /app

EXPOSE 8080
EXPOSE 8081

COPY --from=build-env /app/out .
COPY --from=joeyzhao2018/test-serverless-init:v1 /datadog-init /app/datadog-init
COPY --from=datadog/dd-lib-dotnet-init /datadog-init/monitoring-home/ /dd_tracer/dotnet/
ENV DD_SERVICE=joey-aas-container-dotnet
ENV DD_ENV=dev
ENV DD_VERSION=1
ENTRYPOINT ["/app/datadog-init"]
CMD ["dotnet", "MyFirstAzureWebApp.dll"]
