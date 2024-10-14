# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /source

# Copy the solution and restore dependencies
COPY *.sln .
COPY TodoList.Web/TodoList.Web.csproj TodoList.Web/
COPY TodoList.UnitTests/TodoList.UnitTests.csproj TodoList.UnitTests/
COPY TodoList.Core/TodoList.Core.csproj TodoList.Core/
COPY TodoList.Data/TodoList.Data.csproj TodoList.Data/
COPY TodoList.API/TodoList.API.csproj TodoList.API/
RUN dotnet restore

# Copy the rest of the files and build the project
COPY . .
WORKDIR /source/TodoList.Web
RUN dotnet publish -c Release -o /app

# Stage 2: Serve
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "TodoList.Web.dll"]
