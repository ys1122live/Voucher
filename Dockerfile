FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

ENTRYPOINT ["dotnet", "GameVoucherManageCore.dll"]