FROM amazonlinux:2023 AS base
WORKDIR /app
ENV LD_LIBRARY_PATH="/app/clidriver/lib/"
RUN dnf install -y libxml2-devel
RUN dnf install -y pam-devel


FROM amazonlinux:2023 AS build
WORKDIR /src
RUN dnf install -y dotnet-sdk-8.0

COPY ["./AWSDotnet8OC.csproj", "."]
RUN dotnet restore "./AWSDotnet8OC.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "AWSDotnet8OC.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AWSDotnet8OC.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV PATH=$PATH:/app/clidriver/lib:/app/clidriver/adm
CMD tail -f /dev/null
