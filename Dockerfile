# See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

# This stage is used when running from VS in fast mode (Default for Debug configuration)
FROM public.ecr.aws/lambda/dotnet:8-x86_64 AS base
WORKDIR /app
ENV LD_LIBRARY_PATH="/app/clidriver/lib/"
RUN dnf install -y libxml2-devel
RUN dnf install -y pam-devel

# This stage is used to build the service project
FROM public.ecr.aws/lambda/dotnet:8-x86_64 AS build
#RUN dnf install -y dotnet-sdk-8.0
RUN dnf install -y dotnet-sdk-8.0
WORKDIR /src
COPY ["AWSDotnet8OC/AWSDotnet8OC.csproj", "AWSDotnet8OC/"]
RUN dotnet restore "AWSDotnet8OC/AWSDotnet8OC.csproj"
COPY . .
WORKDIR "/src/AWSDotnet8OC"
RUN dotnet build "./AWSDotnet8OC.csproj" -c Release -o /app/build

# This stage is used to publish the service project to be copied to the final stage
FROM build AS publish
RUN dotnet publish "./AWSDotnet8OC.csproj" -c Release -o /app/publish /p:UseAppHost=false

# This stage is used in production or when running from VS in regular mode (Default when not using the Debug configuration)
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV PATH=$PATH:/app/clidriver/lib:/app/clidriver/adm
CMD tail -f /dev/null
