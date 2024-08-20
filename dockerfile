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
COPY --from=datadog/serverless-init:1 / /app/
# COPY --from=datadog/serverless-init:1 /datadog-init /app/datadog-init
# COPY ./dotnet.sh .
RUN chmod u+x dotnet.sh && ./dotnet.sh
# COPY --from=ghcr.io/datadog/dd-trace-dotnet/dd-lib-dotnet-init:cf2c5942f74f22306fa2178390848f568c4bdf3a /datadog-init/monitoring-home/ /dd_tracer/dotnet/
# COPY --from=joeyzhao2018/test-serverless-init:v2 /datadog-init /app/datadog-init
# COPY --from=datadog/dd-lib-dotnet-init /datadog-init/monitoring-home/ /dd_tracer/dotnet/
# below this is for local testing
# COPY datadog-agent /app/datadog-init
# ENV DD_HISTOGRAM_AGGREGATES="avg median max count"
# ENV DD_HISTOGREM_PERCENTILES="0.95"
# ENV DD_SERVICE=joey-aas-container-dotnet
ENV DD_ENV=joeyback
ENV DD_VERSION=1
# ENV DD_LOG_LEVEL=trace
ENV DD_SITE=datadoghq.com
ENV DD_TRACE_ENABLED=true
ENV DD_CUSTOM_METRICS_ENABLED=true
# ENV DD_SERVICE=joeydotnet
ENTRYPOINT ["/app/datadog-init"]
CMD ["dotnet", "MyFirstAzureWebApp.dll"]
