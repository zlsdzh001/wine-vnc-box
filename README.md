# wine-vnc-box
wine-vnc-box：Docker镜像，集成了Wine和VNC，可用于运行Windows程序。

## 简介

该项目提供一个开源的Docker镜像，打包了Wine和VNC。这意味着您可以在任何支持Docker的系统上运行Windows程序，而无需在宿主机上直接安装这些程序。通过VNC，您可以远程访问和控制正在运行的Windows程序。

## 架构
因为用到的wine的一些包目前只支持amd架构，因此该镜像仅支持在amd架构的平台上使用


## 如何使用


创建wine的启动脚本`start.sh`
```

# 必要的步骤，启动桌面环境
/entrypoint.sh &

wine /home/app/my-app.exe
```


创建Dockerfile
```
FROM furacas/wine-vnc-box:latest

# 复制Windows程序到镜像中
COPY ./my-app.exe /home/app/

# 复制启动脚本
COPY ./start.sh /home/app/


CMD ["/start.sh"]
```

构建docker镜像
```
docker build -t my-wine-app .
```

启动
```
docker run -p 8080:8080 my-wine-app
```

现在，你可以使用浏览器访问localhost:8080，来远程访问和控制你的Windows程序。