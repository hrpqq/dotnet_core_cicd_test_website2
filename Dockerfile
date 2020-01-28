FROM mcr.microsoft.com/dotnet/core/runtime:3.1 AS base
WORKDIR /app
EXPOSE 5001

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["console.csproj", "./"]
RUN dotnet restore "./console.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "console.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "console.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "console.dll"]
